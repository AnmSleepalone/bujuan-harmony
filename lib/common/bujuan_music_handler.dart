import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:bujuan_music_api/bujuan_music_api.dart';

enum LoopMode {
  one, // 单曲循环
  playlist, // 顺序循环整个播放列表
  shuffle, // 随机循环播放
}

class BujuanMusicHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  // 私有构造函数
  BujuanMusicHandler._internal() {
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
    });
    _player.onPositionChanged.listen((position) {
      playbackState.add(playbackState.value.copyWith(updatePosition: position));
    });
    // 播放完成自动下一首
    _player.onPlayerComplete.listen((_) => _handlePlaybackCompleted());
  }

  static final BujuanMusicHandler _instance = BujuanMusicHandler._internal();

  factory BujuanMusicHandler() => _instance;

  final AudioPlayer _player = AudioPlayer();
  final List<MediaItem> _playlist = [];
  final List<int> _shuffledIndices = [];

  int _currentIndex = 0;
  int _shufflePosition = 0;
  LoopMode _loopMode = LoopMode.playlist;

  LoopMode get loopMode => _loopMode;

  Stream<Duration> get currentPosition => _player.onPositionChanged;

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
    await _playCurrent();
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
}
