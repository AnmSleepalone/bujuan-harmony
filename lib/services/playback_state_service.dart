import 'dart:async';
import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive.dart';

import '../common/bujuan_music_handler.dart';
import '../common/values/app_config.dart';

/// 播放状态持久化服务
class PlaybackStateService {
  // 私有构造函数
  PlaybackStateService._internal();

  static final PlaybackStateService _instance = PlaybackStateService._internal();

  factory PlaybackStateService() => _instance;

  Timer? _debounceTimer;
  static const Duration _debounceDuration = Duration(seconds: 5);

  /// 保存播放状态
  /// [immediate] 是否立即保存，不使用 debounce
  void savePlaybackState({bool immediate = false}) {
    if (immediate) {
      _saveState();
    } else {
      // 使用 debounce 避免频繁写入
      _debounceTimer?.cancel();
      _debounceTimer = Timer(_debounceDuration, _saveState);
    }
  }

  /// 实际保存状态的方法
  void _saveState() {
    try {
      final handler = BujuanMusicHandler();
      final mediaItem = handler.mediaItem.valueOrNull;
      final playbackState = handler.playbackState.valueOrNull;
      final queue = handler.queue.valueOrNull ?? [];

      // 如果没有正在播放的歌曲，不保存状态
      if (mediaItem == null || queue.isEmpty) {
        return;
      }

      final currentIndex = queue.indexWhere((item) => item.id == mediaItem.id);
      if (currentIndex == -1) {
        return;
      }

      // 构建要保存的状态数据
      final stateData = {
        'currentSongId': mediaItem.id,
        'currentSongTitle': mediaItem.title,
        'currentSongArtist': mediaItem.artist,
        'currentSongArtUri': mediaItem.artUri?.toString(),
        'currentSongDuration': mediaItem.duration?.inMilliseconds,
        'playbackPosition': playbackState?.updatePosition.inMilliseconds ?? 0,
        'currentIndex': currentIndex,
        'loopMode': _loopModeToString(handler.loopMode),
        'playlist': queue.map((item) => _mediaItemToMap(item)).toList(),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      // 保存到 Hive
      GetIt.I<Box>().put(AppConfig.playbackState, jsonEncode(stateData));
    } catch (e) {
      print('保存播放状态失败: $e');
    }
  }

  /// 加载播放状态
  Map<String, dynamic>? loadPlaybackState() {
    try {
      final stateJson = GetIt.I<Box>().get(AppConfig.playbackState) as String?;
      if (stateJson == null || stateJson.isEmpty) {
        return null;
      }

      final stateData = jsonDecode(stateJson) as Map<String, dynamic>;

      // 检查数据有效性
      if (!_isStateValid(stateData)) {
        clearPlaybackState();
        return null;
      }

      return stateData;
    } catch (e) {
      print('加载播放状态失败: $e');
      clearPlaybackState();
      return null;
    }
  }

  /// 清除播放状态
  void clearPlaybackState() {
    try {
      GetIt.I<Box>().delete(AppConfig.playbackState);
    } catch (e) {
      print('清除播放状态失败: $e');
    }
  }

  /// 检查保存的状态是否有效
  bool _isStateValid(Map<String, dynamic> stateData) {
    // 检查必要字段是否存在
    if (stateData['currentSongId'] == null ||
        stateData['playlist'] == null ||
        stateData['currentIndex'] == null) {
      return false;
    }

    // 检查播放列表是否为空
    final playlist = stateData['playlist'] as List?;
    if (playlist == null || playlist.isEmpty) {
      return false;
    }

    // 检查索引是否有效
    final currentIndex = stateData['currentIndex'] as int?;
    if (currentIndex == null || currentIndex < 0 || currentIndex >= playlist.length) {
      return false;
    }

    // 可以添加时间戳检查，避免加载过期的状态（例如30天前的）
    final timestamp = stateData['timestamp'] as int?;
    if (timestamp != null) {
      final savedTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();
      if (now.difference(savedTime).inDays > 30) {
        return false;
      }
    }

    return true;
  }

  /// 将 LoopMode 转换为字符串
  String _loopModeToString(LoopMode mode) {
    switch (mode) {
      case LoopMode.one:
        return 'one';
      case LoopMode.playlist:
        return 'playlist';
      case LoopMode.shuffle:
        return 'shuffle';
    }
  }

  /// 将字符串转换为 LoopMode
  LoopMode stringToLoopMode(String mode) {
    switch (mode) {
      case 'one':
        return LoopMode.one;
      case 'shuffle':
        return LoopMode.shuffle;
      case 'playlist':
      default:
        return LoopMode.playlist;
    }
  }

  /// 将 MediaItem 转换为 Map
  Map<String, dynamic> _mediaItemToMap(MediaItem item) {
    return {
      'id': item.id,
      'title': item.title,
      'artist': item.artist,
      'album': item.album,
      'artUri': item.artUri?.toString(),
      'duration': item.duration?.inMilliseconds,
      'extras': item.extras,
    };
  }

  /// 将 Map 转换为 MediaItem
  MediaItem mapToMediaItem(Map<String, dynamic> map) {
    return MediaItem(
      id: map['id'] as String,
      title: map['title'] as String,
      artist: map['artist'] as String?,
      album: map['album'] as String?,
      artUri: map['artUri'] != null ? Uri.parse(map['artUri'] as String) : null,
      duration: map['duration'] != null ? Duration(milliseconds: map['duration'] as int) : null,
      extras: map['extras'] as Map<String, dynamic>?,
    );
  }

  /// 销毁时取消定时器
  void dispose() {
    _debounceTimer?.cancel();
  }
}
