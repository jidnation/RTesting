import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:pedantic/pedantic.dart';
import 'package:video_player/video_player.dart';

abstract class VideoControllerService {
  Future<VideoPlayerController> getControllerForVideo(String videoUrl);
  Future<BetterPlayerDataSource> getControllerForTimeLineVideo(String videoUrl);
  Future<File?> getAudioFile(String audioUrl);
}

class CachedVideoControllerService extends VideoControllerService {
  final BaseCacheManager _cacheManager;

  CachedVideoControllerService(this._cacheManager);

  @override
  Future<VideoPlayerController> getControllerForVideo(String videoUrl) async {
    final fileInfo = await _cacheManager.getFileFromCache(videoUrl);

    if (fileInfo == null) {
      print('[VideoControllerService]: No video in cache');

      print('[VideoControllerService]: Saving video to cache');
      unawaited(_cacheManager.downloadFile(videoUrl));

      return VideoPlayerController.network(videoUrl);
    } else {
      print('[VideoControllerService]: Loading video from cache');
      return VideoPlayerController.file(fileInfo.file);
    }
  }

  @override
  Future<BetterPlayerDataSource> getControllerForTimeLineVideo(
      String videoUrl) async {
    final fileInfo = await _cacheManager.getFileFromCache(videoUrl);

    if (fileInfo == null) {
      print('[VideoControllerService]: No timeLinevideo in cache');

      print('[VideoControllerService]: Saving timeLinevideo to cache');
      unawaited(_cacheManager.downloadFile(videoUrl));

      return BetterPlayerDataSource(
          BetterPlayerDataSourceType.network, videoUrl);
    } else {
      print('[VideoControllerService]: Loading timeLinevideo from cache');

      // var filePath = await Utils.getFileUrl(Constants.fileTestVideoUrl);
      // File file = File(filePath);

      List<int> bytes = fileInfo.file.readAsBytesSync().buffer.asUint8List();
      BetterPlayerDataSource dataSource =
          BetterPlayerDataSource.memory(bytes, videoExtension: "mp4");

      return dataSource;
    }
  }

  @override
  Future<File?> getAudioFile(String audioUrl) async {
    final fileInfo = await _cacheManager.getFileFromCache(audioUrl);

    if (fileInfo == null) {
      print('[VideoControllerService]: No audio in cache');

      print('[VideoControllerService]: Saving audio to cache');
      unawaited(_cacheManager.downloadFile(audioUrl));

      return null;
    } else {
      print('[VideoControllerService]: Loading audio from cache');
      return fileInfo.file;
    }
  }
}
