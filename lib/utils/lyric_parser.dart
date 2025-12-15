/// 歌词解析工具类
/// 用于解析LRC格式歌词并提供卡拉OK功能所需的数据结构

/// 单行歌词数据
class LyricLine {
  /// 歌词显示的时间点
  final Duration time;

  /// 原文歌词文本
  final String text;

  /// 翻译文本（如果有）
  final String? translation;

  LyricLine({
    required this.time,
    required this.text,
    this.translation,
  });

  @override
  String toString() {
    return 'LyricLine(time: ${time.inSeconds}s, text: $text${translation != null ? ', translation: $translation' : ''})';
  }
}

/// 解析后的完整歌词数据
class ParsedLyrics {
  /// 所有歌词行
  final List<LyricLine> lines;

  /// 是否包含翻译
  final bool hasTranslation;

  ParsedLyrics({
    required this.lines,
    this.hasTranslation = false,
  });

  /// 是否为空歌词
  bool get isEmpty => lines.isEmpty;

  /// 根据当前播放时间查找对应的歌词行索引
  /// 使用二分查找算法，时间复杂度 O(log n)
  int findCurrentLineIndex(Duration position) {
    if (lines.isEmpty) return -1;

    int left = 0;
    int right = lines.length - 1;
    int result = -1;

    while (left <= right) {
      int mid = (left + right) ~/ 2;
      if (lines[mid].time <= position) {
        result = mid;
        left = mid + 1;
      } else {
        right = mid - 1;
      }
    }

    return result;
  }
}

/// 解析LRC格式歌词
///
/// 支持标准LRC格式：[mm:ss.xx]歌词内容
/// 同时支持原文和翻译歌词的匹配
///
/// [lrcText] 原文歌词LRC文本
/// [translationText] 翻译歌词LRC文本（可选）
///
/// 返回 [ParsedLyrics] 解析后的歌词数据
ParsedLyrics parseLyrics(String? lrcText, String? translationText) {
  // 解析原文歌词
  final lrcLines = _parseSingleLyric(lrcText);

  // 解析翻译歌词
  final trcLines = _parseSingleLyric(translationText);

  // 合并原文和翻译
  final mergedLines = _mergeLyrics(lrcLines, trcLines);

  return ParsedLyrics(
    lines: mergedLines,
    hasTranslation: trcLines.isNotEmpty,
  );
}

/// 解析单个LRC文本
///
/// LRC格式示例：
/// ```
/// [00:12.50]第一行歌词
/// [00:17.20]第二行歌词
/// [00:21.10]第三行歌词
/// ```
List<LyricLine> _parseSingleLyric(String? text) {
  if (text == null || text.isEmpty) return [];

  final lines = <LyricLine>[];

  // LRC时间标签正则：[分:秒.毫秒]
  // 示例：[00:12.50] 或 [01:23.45]
  final regex = RegExp(r'\[(\d+):(\d+)\.(\d+)\](.*)');

  for (var line in text.split('\n')) {
    final trimmedLine = line.trim();
    if (trimmedLine.isEmpty) continue;

    final match = regex.firstMatch(trimmedLine);
    if (match != null) {
      try {
        final minutes = int.parse(match.group(1)!);
        final seconds = int.parse(match.group(2)!);

        // LRC格式中的时间可能是2位(百分之一秒)或3位(毫秒)
        // 例如: [00:12.50] 或 [00:12.500]
        final timeStr = match.group(3)!;
        final milliseconds = timeStr.length == 2
            ? int.parse(timeStr) * 10  // 2位: 百分之一秒，需要*10转换为毫秒
            : int.parse(timeStr);       // 3位: 直接就是毫秒

        final lyricText = match.group(4)!.trim();

        // 只添加非空的歌词
        if (lyricText.isNotEmpty) {
          lines.add(LyricLine(
            time: Duration(
              minutes: minutes,
              seconds: seconds,
              milliseconds: milliseconds,
            ),
            text: lyricText,
          ));
        }
      } catch (e) {
        // 解析失败的行跳过
        print('LRC解析错误: $line, 错误: $e');
        continue;
      }
    }
  }

  // 按时间排序，确保歌词顺序正确
  lines.sort((a, b) => a.time.compareTo(b.time));

  return lines;
}

/// 合并原文和翻译歌词
///
/// 策略：按时间戳匹配，将翻译添加到对应的原文行
/// 如果时间戳不完全匹配，使用最接近的翻译行
Map<Duration, String> _buildTranslationMap(List<LyricLine> translationLines) {
  final map = <Duration, String>{};
  for (var line in translationLines) {
    map[line.time] = line.text;
  }
  return map;
}

List<LyricLine> _mergeLyrics(
  List<LyricLine> lrcLines,
  List<LyricLine> translationLines,
) {
  if (lrcLines.isEmpty) return [];
  if (translationLines.isEmpty) return lrcLines;

  // 构建翻译映射表
  final translationMap = _buildTranslationMap(translationLines);

  // 为每一行原文查找对应的翻译
  return lrcLines.map((lrcLine) {
    // 优先查找完全匹配的翻译
    String? translation = translationMap[lrcLine.time];

    // 如果没有完全匹配，查找最接近的翻译
    if (translation == null) {
      Duration? closestTime;
      Duration minDiff = Duration(hours: 1); // 初始值设为一个较大的值

      for (var trcTime in translationMap.keys) {
        final diff = (lrcLine.time - trcTime).abs();
        if (diff < minDiff && diff < Duration(seconds: 1)) {
          // 只接受1秒内的差异
          minDiff = diff;
          closestTime = trcTime;
        }
      }

      if (closestTime != null) {
        translation = translationMap[closestTime];
      }
    }

    return LyricLine(
      time: lrcLine.time,
      text: lrcLine.text,
      translation: translation,
    );
  }).toList();
}
