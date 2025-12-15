import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:bujuan_music_api/bujuan_music_api.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

import '../services/playback_state_service.dart';

enum LoopMode {
  one, // 单曲循环
  playlist, // 顺序循环整个播放列表
  shuffle, // 随机循环播放
}

class BujuanMusicHandler extends BaseAudioHandler with QueueHandler, SeekHandler, WidgetsBindingObserver {
  // 私有构造函数
  BujuanMusicHandler._internal() {
    // 添加生命周期监听
    WidgetsBinding.instance.addObserver(this);

    // 播放器状态同步到 audio_service
    _player.onPlayerStateChanged.listen((state) {
      playbackState.add(playbackState.value.copyWith(
        playing: state == PlayerState.playing,
        processingState: AudioProcessingState.ready,
        controls: [
          MediaControl.skipToPrevious,
          if (state == PlayerState.playing) MediaControl.pause else MediaControl.play,
          MediaControl.skipToNext,
          MediaControl.stop,
        ],
        systemActions: const {
          MediaAction.seek,
        },
        androidCompactActionIndices: const [1, 2, 3],
      ));

      // 播放状态变化时立即保存
      _stateService.savePlaybackState(immediate: true);
    });
    _player.onPositionChanged.listen((position) {
      playbackState.add(playbackState.value.copyWith(updatePosition: position));

      // 播放位置变化时使用 debounce 保存
      _stateService.savePlaybackState();
    });
    // 播放完成自动下一首
    _player.onPlayerComplete.listen((_) => _handlePlaybackCompleted());
  }

  static final BujuanMusicHandler _instance = BujuanMusicHandler._internal();

  factory BujuanMusicHandler() => _instance;

  final AudioPlayer _player = AudioPlayer();
  final List<MediaItem> _playlist = [];
  final List<int> _shuffledIndices = [];
  final PlaybackStateService _stateService = PlaybackStateService();

  int _currentIndex = 0;

  /// 当前播放索引的响应式 Stream
  final BehaviorSubject<int> currentIndexSubject = BehaviorSubject<int>.seeded(0);
  int _shufflePosition = 0;
  LoopMode _loopMode = LoopMode.playlist;

  LoopMode get loopMode => _loopMode;

  Stream<Duration> get currentPosition => _player.onPositionChanged;

  /// 获取当前播放列表（只读）
  List<MediaItem> get playlist => List.unmodifiable(_playlist);

  /// 获取当前播放索引
  int get currentIndex => _currentIndex;

  /// 更新播放列表
  @override
  Future<void> updateQueue(List<MediaItem> queue, {int index = 0}) async {
    if (queue.isEmpty) return;

    await _player.stop();

    _playlist
      ..clear()
      ..addAll(queue);
    _currentIndex = index;

    if (_loopMode == LoopMode.shuffle) {
      _generateShuffledIndices();
    }

    this.queue.add(_playlist);
    mediaItem.add(_playlist[_currentIndex]);
    await play();

    // 更新播放列表后立即保存状态
    _stateService.savePlaybackState(immediate: true);
  }

  /// 添加歌曲到播放列表末尾
  Future<void> addToQueue(MediaItem item) async {
    _playlist.add(item);
    queue.add(_playlist);

    if (_loopMode == LoopMode.shuffle) {
      _generateShuffledIndices();
    }

    _stateService.savePlaybackState(immediate: true);
  }

  /// 从播放列表中删除指定位置的歌曲
  Future<void> removeFromQueue(int index) async {
    if (index < 0 || index >= _playlist.length) return;

    // 如果是最后一首且只剩一首，清空队列并停止
    if (_playlist.length == 1) {
      await stop();
      _playlist.clear();
      queue.add(_playlist);
      _stateService.savePlaybackState(immediate: true);
      return;
    }

    // 如果删除的是当前播放的歌曲
    if (index == _currentIndex) {
      // 先跳转到下一首
      await skipToNext();
      // 删除歌曲
      _playlist.removeAt(index);
      // 调整当前索引（因为删除了一首，如果当前索引在删除位置之后，需要减1）
      if (_currentIndex > index) {
        _currentIndex--;
      }
    } else {
      // 删除非当前播放的歌曲
      _playlist.removeAt(index);
      // 如果删除的歌曲在当前播放歌曲之前，需要调整索引
      if (_currentIndex > index) {
        _currentIndex--;
      }
    }

    queue.add(_playlist);

    if (_loopMode == LoopMode.shuffle) {
      _generateShuffledIndices();
    }

    _stateService.savePlaybackState(immediate: true);
  }

  /// 跳转到播放列表中的指定位置
  @override
  Future<void> skipToQueueItem(int index) async {
    if (index < 0 || index >= _playlist.length) return;
    _currentIndex = index;
    await _playCurrent();
  }

  /// 生成打乱的播放顺序
  void _generateShuffledIndices() {
    _shuffledIndices
      ..clear()
      ..addAll(List.generate(_playlist.length, (i) => i)..shuffle());

    _shufflePosition = _shuffledIndices.indexOf(_currentIndex);
  }

  /// 设置循环模式
  void setLoopMode(LoopMode mode) {
    _loopMode = mode;
    if (mode == LoopMode.shuffle) {
      _generateShuffledIndices();
    }

    // 播放模式变化时立即保存状态
    _stateService.savePlaybackState(immediate: true);
  }

  /// 获取播放地址
  Future<String> _fetchPlayUrl(String id) async {
    SongUrlListWrap? songUrlEntity = await BujuanMusicManager().songUrl([id]);
    if (songUrlEntity != null && (songUrlEntity.data ?? []).isNotEmpty) {
      return songUrlEntity.data!.first.url ?? '';
    }
    return '';
  }

  /// 播放当前歌曲
  Future<void> _playCurrent() async {
    final item = _playlist[_currentIndex];
    mediaItem.add(item);

    // 更新当前索引的响应式 Stream
    currentIndexSubject.add(_currentIndex);

    // 立即更新 playbackState 为 loading 状态，让系统卡片尽快显示
    playbackState.add(playbackState.value.copyWith(
      processingState: AudioProcessingState.loading,
      playing: false,
      controls: [
        MediaControl.skipToPrevious,
        MediaControl.play,
        MediaControl.skipToNext,
        MediaControl.stop,
      ],
      systemActions: const {
        MediaAction.seek,
      },
    ));

    var url = await _fetchPlayUrl(item.id);
    // print('object----$url');
    var split = url.split('?');
    if (split.length > 1) {
      url = split[0];
    }
    await _player.play(UrlSource(url));
  }

  /// 播放
  @override
  Future<void> play() async {
    // 如果播放器已经暂停（有播放源），恢复播放
    // 否则重新播放当前歌曲（从头开始）
    if (_player.state == PlayerState.paused) {
      await _player.resume();
    } else {
      await _playCurrent();
    }
  }

  @override
  Future<void> seek(Duration position) async {
    playbackState.add(playbackState.value.copyWith(updatePosition: position));
    await _player.seek(position);
  }

  /// 暂停
  @override
  Future<void> pause() async {
    await _player.pause();
  }

  /// 停止
  @override
  Future<void> stop() async {
    await _player.stop();
  }

  /// 播放 / 暂停切换
  Future<void> playOrPause() async {
    if (_player.state == PlayerState.playing) {
      await pause();
    } else {
      await _player.resume();
    }
  }

  /// 下一首
  @override
  Future<void> skipToNext() async {
    switch (_loopMode) {
      case LoopMode.one:
      case LoopMode.playlist:
        _currentIndex = (_currentIndex + 1) % _playlist.length;
        await _playCurrent();
        break;

      case LoopMode.shuffle:
        if (_shuffledIndices.isEmpty) _generateShuffledIndices();

        _shufflePosition++;
        if (_shufflePosition >= _shuffledIndices.length) {
          _generateShuffledIndices();
        }
        _currentIndex = _shuffledIndices[_shufflePosition % _shuffledIndices.length];
        await _playCurrent();
        break;
    }
  }

  /// 上一首
  @override
  Future<void> skipToPrevious() async {
    switch (_loopMode) {
      case LoopMode.one:
      case LoopMode.playlist:
        if (_currentIndex > 0) {
          _currentIndex--;
        } else {
          _currentIndex = _playlist.length - 1;
        }
        await _playCurrent();
        break;

      case LoopMode.shuffle:
        if (_shuffledIndices.isEmpty) _generateShuffledIndices();

        _shufflePosition--;
        if (_shufflePosition < 0) {
          _shufflePosition = _shuffledIndices.length - 1;
        }
        _currentIndex = _shuffledIndices[_shufflePosition];
        await _playCurrent();
        break;
    }
  }

  /// 播放完成时的逻辑
  Future<void> _handlePlaybackCompleted() async {
    switch (_loopMode) {
      case LoopMode.one:
        await _playCurrent();
        break;

      case LoopMode.playlist:
        _currentIndex = (_currentIndex + 1) % _playlist.length;
        await _playCurrent();
        break;

      case LoopMode.shuffle:
        _shufflePosition++;
        if (_shufflePosition >= _shuffledIndices.length) {
          _generateShuffledIndices();
        }
        _currentIndex = _shuffledIndices[_shufflePosition % _shuffledIndices.length];
        await _playCurrent();
        break;
    }
  }

  /// 恢复播放状态
  Future<void> restorePlaybackState() async {
    try {
      final stateData = _stateService.loadPlaybackState();
      if (stateData == null) {
        return;
      }

      // 恢复播放列表
      final playlistData = stateData['playlist'] as List;
      final restoredPlaylist = playlistData
          .map((item) => _stateService.mapToMediaItem(item as Map<String, dynamic>))
          .toList();

      if (restoredPlaylist.isEmpty) {
        return;
      }

      // 恢复播放列表到内存
      _playlist
        ..clear()
        ..addAll(restoredPlaylist);
      queue.add(_playlist);

      // 恢复当前索引
      final currentIndex = stateData['currentIndex'] as int;
      if (currentIndex >= 0 && currentIndex < _playlist.length) {
        _currentIndex = currentIndex;
      } else {
        _currentIndex = 0;
      }
      // 更新当前索引的响应式 Stream
      currentIndexSubject.add(_currentIndex);

      // 恢复播放模式
      final loopModeStr = stateData['loopMode'] as String?;
      if (loopModeStr != null) {
        _loopMode = _stateService.stringToLoopMode(loopModeStr);
        if (_loopMode == LoopMode.shuffle) {
          _generateShuffledIndices();
        }
      }

      // 设置当前媒体项
      final currentItem = _playlist[_currentIndex];
      mediaItem.add(currentItem);

      // 获取播放地址并加载音频（但不播放）
      final url = await _fetchPlayUrl(currentItem.id);
      var cleanUrl = url.split('?')[0];
      await _player.setSourceUrl(cleanUrl);

      // 恢复播放位置
      final playbackPosition = stateData['playbackPosition'] as int? ?? 0;
      if (playbackPosition > 0) {
        final position = Duration(milliseconds: playbackPosition);
        // 确保位置不超过歌曲长度
        final duration = currentItem.duration ?? Duration.zero;
        if (position <= duration) {
          await _player.seek(position);
          playbackState.add(playbackState.value.copyWith(
            updatePosition: position,
            playing: false,
          ));
        }
      }

      print('播放状态已恢复: ${currentItem.title} at ${Duration(milliseconds: playbackPosition)}');
    } catch (e) {
      print('恢复播放状态失败: $e');
      // 恢复失败时清除保存的状态
      _stateService.clearPlaybackState();
    }
  }

  /// 监听应用生命周期变化
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // 当应用进入后台或即将退出时，立即保存播放状态
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      _stateService.savePlaybackState(immediate: true);
      print('应用进入后台，立即保存播放状态');
    }
  }

  /// 释放资源
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stateService.dispose();
  }
}
