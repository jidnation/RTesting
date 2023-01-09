import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_cutter/audio_cutter.dart';
// import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
// import 'package:light_compressor/light_compressor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_compress/video_compress.dart' as vc;
// import 'package:video_compress/video_compress.dart';
import 'package:video_thumbnail/video_thumbnail.dart' as t;
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

import '../models/file_result.dart';
import '../utils/file_url_converter.dart';
import '../utils/file_utils.dart';

class MediaService {
  final ImageCropper _cropper = ImageCropper();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  Future<FileResult?> getImage({required bool fromGallery}) async {
    dynamic res;
    if (fromGallery) {
      final _res = await AssetPicker.pickAssets(
        _navigatorKey.currentContext!,
        pickerConfig: AssetPickerConfig(
          maxAssets: 1,
          requestType: RequestType.image,
          textDelegate: const EnglishAssetPickerTextDelegate(),
          specialPickerType: SpecialPickerType.noPreview,
        ),
      );
      if (_res == null || _res.isEmpty) return null;
      res = _res.first;
    } else {
      res = await CameraPicker.pickFromCamera(
        _navigatorKey.currentContext!,
        locale: const Locale('en'),
        pickerConfig: const CameraPickerConfig(
          enableRecording: false,
        ),
      );

      if (res == null) return null;
    }
    final file = await res.originFile;
    if (file == null) return null;
    return FileResult(
        path: file.path,
        size: file.lengthSync() / 1024,
        duration: res.videoDuration.inSeconds,
        height: res.height,
        width: res.width,
        fileName: (file as File).path.split('/').last);
  }

  // Future<FileResult?> pickFromGallery() async {
  //   final res = await AssetPicker.pickAssets(
  //     _navigatorKey.currentContext!,
  //     pickerConfig: AssetPickerConfig(
  //       maxAssets: 1,
  //       specialPickerType: SpecialPickerType.noPreview,
  //       requestType: RequestType.common,
  //     ),
  //   );
  //   if (res == null || res.isEmpty) return null;
  //   final file = await res.first.originFile;
  //   if (file == null) return null;
  //   return FileResult(
  //       path: file.path,
  //       size: file.lengthSync() / 1024,
  //       duration: res.first.videoDuration.inSeconds,
  //       height: res.first.height,
  //       width: res.first.width,
  //       fileName: (file).path.split('/').last);
  // }

  Future<FileResult?> getVideo() async {
    final res = await AssetPicker.pickAssets(
      _navigatorKey.currentContext!,
      pickerConfig: const AssetPickerConfig(
        maxAssets: 1,
        requestType: RequestType.video,
      ),
    );
    if (res == null || res.isEmpty) return null;
    final file = await res.first.originFile;
    if (file == null) return null;
    return FileResult(
        path: file.path,
        size: file.lengthSync() / 1024,
        duration: res.first.videoDuration.inSeconds,
        height: res.first.height,
        width: res.first.width,
        fileName: (file).path.split('/').last);
  }

  Future<FileResult?> getFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowedExtensions: FileUtils.docExts, type: FileType.custom);
    if (result == null) return null;
    File? file = File(result.files.single.path!);
    return FileResult(
        path: file.path,
        size: result.files.first.size / 1024,
        fileName: (file).path.split('/').last);
  }

  Future<FileResult?> getAudio({required BuildContext context}) async {
    final res = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        maxAssets: 1,
        requestType: RequestType.audio,
        specialPickerType: SpecialPickerType.noPreview,
      ),
    );
    if (res == null || res.isEmpty) return null;
    final file = await res.first.originFile;
    if (file == null) return null;
    return FileResult(
        path: file.path,
        size: file.lengthSync() / 1024,
        duration: res.first.videoDuration.inSeconds,
        height: res.first.height,
        width: res.first.width,
        fileName: (file).path.split('/').last);
  }

  Future<FileResult?> getImageCropped(
      {required FileResult file, int? size}) async {
    final res = await _cropper.cropImage(
      sourcePath: file.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      cropStyle: CropStyle.circle,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 100,
      maxWidth: size,
      maxHeight: size,
      compressFormat: ImageCompressFormat.jpg,
      uiSettings: [
        IOSUiSettings(title: ''),
        AndroidUiSettings(
          toolbarTitle: 'Crop',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
        ),
      ],
    );
    if (res == null) return null;
    return file.copyWith(path: res.path);
  }

  Future<FileResult> resizeImage(
      {required FileResult file, required Size size}) async {
    final res = await FlutterNativeImage.compressImage(
      file.path,
      targetWidth: size.width.toInt(),
      targetHeight: (size.width * size.aspectRatio).toInt(),
    );
    return file.copyWith(path: res.path);
  }

  Future<FileResult> compressImage(
      {required FileResult file, required int quality}) async {
    final res = await FlutterNativeImage.compressImage(
      file.path,
      quality: quality,
    );
    return file.copyWith(path: res.path);
  }

  //cutting the audio file based on the time frame
  Future<File> audioCutter(
      {required String audioPath, required int endTime}) async {
    File outputFile = File('');
    var result = await AudioCutter.cutAudio(audioPath, 0.0, endTime.toDouble());
    outputFile = File(result);

    return outputFile;
  }

  //converting the file to url
  Future<String?>? urlConverter({required String filePath}) async {
    File file = File(filePath);
    String? fileUrl = await FileConverter().convertMe(filePath: filePath);
    unawaited(file.delete());
    return fileUrl;
  }

  Future<FileResult> compressVideo({required FileResult file}) async {
    final res = await vc.VideoCompress.compressVideo(
      file.path,
      quality: vc.VideoQuality.MediumQuality,
    );

    print('size1:::::::::::::::${res!.filesize! / 1024}');
    return FileResult(
        path: res.path!,
        size: res.filesize! / 1024,
        duration: file.duration,
        height: file.height,
        width: file.width,
        fileName: res.path!.split('/').last);
  }

  // Future<String> compressMomentVideo({required String filePath}) async {
  //   final String videoName =
  //       'ReachMe-${DateTime.now().millisecondsSinceEpoch}.mp4';
  //   final LightCompressor _lightCompressor = LightCompressor();
  //   final dynamic response = await _lightCompressor.compressVideo(
  //     path: filePath,
  //     // destinationPath: _destinationPath,
  //     videoQuality: VideoQuality.low,
  //     isMinBitrateCheckEnabled: false,
  //     video: Video(videoName: videoName),
  //     android: AndroidConfig(isSharedStorage: true, saveAt: SaveAt.Movies),
  //     ios: IOSConfig(saveInGallery: true),
  //   );
  //   File(filePath).delete();
  //   // final res = await VideoCompress.compressVideo(
  //   //   filePath,
  //   //   quality: VideoQuality.DefaultQuality,
  //   // );
  //
  //   // print('size1:::::::::::::::${res!.filesize! / 1024}');
  //   return response.destinationPath;
  // }

  Future<String> removeAudio({required String filePath}) async {
    final vc.MediaInfo? res = await vc.VideoCompress.compressVideo(
      filePath,
      includeAudio: false,
      quality: vc.VideoQuality.MediumQuality,
    );
    return res!.path!;
  }

  Future<PlatformFile?> getAudioFiles() async {
    print('....function called....');
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
        onFileLoading: (FilePickerStatus status) => print(status),
      );
      PlatformFile file = result!.files.first;
      int fileSize = file.size;
      print('....file size:::: $fileSize');
      // String? audioUrl =
      //     await FileConverter().convertMe(filePath: file.path!);
      // return audioUrl;
      return file;
    } on PlatformException catch (e) {
      print('Unsupported operation' + e.toString());
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<FileResult?> pickFromCamera(
      {required BuildContext context, bool? enableRecording}) async {
    final res = await CameraPicker.pickFromCamera(context,
        locale: Locale('en'),
        pickerConfig:
            CameraPickerConfig(enableRecording: enableRecording ?? false));
    if (res == null) return null;
    final file = await res.originFile;
    if (file == null) return null;
    String? thumbnail = (await getVideoThumbnail(videoPath: file.path))?.path;
    return FileResult(
        path: file.path,
        size: file.lengthSync() / 1024,
        duration: res.videoDuration.inSeconds,
        height: res.height,
        width: res.width,
        thumbnail: thumbnail,
        fileName: (file).path.split('/').last);
  }

  Future<List<FileResult>?> pickFromGallery(
      {required BuildContext context,
      RequestType? requestType,
      int? maxAssets}) async {
    List<AssetEntity>? res;
    if (requestType == null) {
      res = await AssetPicker.pickAssets(context,
          pickerConfig: AssetPickerConfig(
            maxAssets: maxAssets ?? 1,
            specialPickerType: SpecialPickerType.noPreview,
          ));
    } else {
      res = await AssetPicker.pickAssets(context,
          pickerConfig: AssetPickerConfig(
              specialPickerType: SpecialPickerType.noPreview,
              maxAssets: maxAssets ?? 1,
              requestType: requestType));
    }
    if (res == null || res.isEmpty) return null;

    List<FileResult> results = [];
    for (var e in res) {
      final file = await e.originFile;
      if (file == null) return null;
      String? thumbnail;
      if (FileUtils.isVideo(file)) {
        thumbnail = (await getVideoThumbnail(videoPath: file.path))?.path;
      }
      results.add(FileResult(
          path: file.path,
          size: file.lengthSync() / 1024,
          duration: e.videoDuration.inSeconds,
          height: e.height,
          width: e.width,
          thumbnail: thumbnail,
          fileName: (file).path.split('/').last));
    }
    return results;
  }

  Future<FileResult?> getVideoThumbnail({required String videoPath}) async {
    String? thumbnailPath;
    int? height, width;
    thumbnailPath = await t.VideoThumbnail.thumbnailFile(
      video: videoPath,
      imageFormat: t.ImageFormat.PNG,
      thumbnailPath: (await getTemporaryDirectory()).path,
      quality: 100,
    );
    if (thumbnailPath == null) return null;
    File imageFile =
        File(thumbnailPath); // Or any other way to get a File instance.
    var decodedImage = await decodeImageFromList(imageFile.readAsBytesSync());
    height = decodedImage.height;
    width = decodedImage.width;
    // print('WIDTH' + decodedImage.width.toString());
    // print('HEIGHT' + decodedImage.height.toString());

    // Image image = Image.file(File(thumbnailPath));
    // Completer completer = Completer<ui.Image>();
    // image.image
    //     .resolve(const ImageConfiguration())
    //     .addListener(ImageStreamListener((ImageInfo info, bool _) {
    //   completer.complete(info.image);
    //   height = info.image.height;
    //   width = info.image.width;
    //   print('height:' + height.toString());
    //   print('width:' + width.toString());
    // }));

    return FileResult(
        path: thumbnailPath,
        size: File(thumbnailPath).lengthSync() / 1024,
        height: height == null ? null : height / 1.0,
        width: width == null ? null : width / 1.0,
        fileName: thumbnailPath.split('/').last);
  }

  // Future<String?> videoAudioMerger(BuildContext context,
  //     {required String videoPath,
  //     required String audioPath,
  //     required int time}) async {
  //   String timeLimit = '00:00:';
  //   String outputPath = '/storage/emulated/0/Download/output.mp4';
  //   String? fileUrl;
  //   if (await Permission.storage.request().isGranted) {
  //     if (time.toInt() < 10) {
  //       timeLimit = timeLimit + '0' + time.toString();
  //     } else {
  //       timeLimit = timeLimit + time.toString();
  //     }
  //
  //     /// To combine audio with video
  //     ///
  //     /// Merging video and audio, with audio re-encoding
  //     /// -c:v copy -c:a aac
  //     ///
  //     /// Copying the audio without re-encoding
  //     /// -c copy
  //     ///
  //     /// Replacing audio stream
  //     /// -c:v copy -c:a aac -map 0:v:0 -map 1:a:0
  //     String commandToExecute =
  //         '-r 15 -f mp4 -i $videoPath -f mp3 -i $audioPath -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 -t $timeLimit -y $outputPath';
  //
  //     await FFmpegKit.executeAsync(commandToExecute, (session) async {
  //       final ReturnCode? returnCode = await session.getReturnCode();
  //       if (ReturnCode.isSuccess(returnCode)) {
  //         String file = await compressMomentVideo(filePath: outputPath);
  //         fileUrl = await urlConverter(filePath: file);
  //         momentFeedStore.postMoment(context, videoUrl: fileUrl);
  //         // SUCCESS
  //       } else if (ReturnCode.isCancel(returnCode)) {
  //         fileUrl = null;
  //         // CANCEL
  //       } else {
  //         fileUrl = null;
  //         // ERROR
  //       }
  //     });
  //     return fileUrl;
  //   } else if (await Permission.storage.isPermanentlyDenied) {
  //     openAppSettings();
  //   } else {
  //     return null;
  //   }
  //   return null;
  // }

  // Future<String?> videoAudioViewerMerger(BuildContext context,
  //     {required String videoPath,
  //     required String audioPath,
  //     required int time}) async {
  //   String timeLimit = '00:00:';
  //   String outputPath = '/storage/emulated/0/Download/viewer.mp4';
  //   String? fileUrl;
  //
  //   momentFeedStore.updateMerger(true);
  //   if (await Permission.storage.request().isGranted) {
  //     if (time.toInt() < 10) {
  //       timeLimit = timeLimit + '0' + time.toString();
  //     } else {
  //       timeLimit = timeLimit + time.toString();
  //     }
  //
  //     /// To combine audio with video
  //     ///
  //     /// Merging video and audio, with audio re-encoding
  //     /// -c:v copy -c:a aac
  //     ///
  //     /// Copying the audio without re-encoding
  //     /// -c copy
  //     ///
  //     /// Replacing audio stream
  //     /// -c:v copy -c:a aac -map 0:v:0 -map 1:a:0
  //     String commandToExecute =
  //         '-r 15 -f mp4 -i $videoPath -f mp3 -i $audioPath -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 -t $timeLimit -y $outputPath';
  //     print(":::::::::::::::::::::: MERGING STARTED :::::::::::::::");
  //     await FFmpegKit.executeAsync(commandToExecute, (session) async {
  //       final ReturnCode? returnCode = await session.getReturnCode();
  //       if (ReturnCode.isSuccess(returnCode)) {
  //         print(":::::::::::::::::::::: MERGING SUCCESS :::::::::::::::");
  //         momentFeedStore.updateMerger(false, isDone: true);
  //         momentCtrl.mergedVideoPath(outputPath);
  //         // SUCCESS
  //       } else if (ReturnCode.isCancel(returnCode)) {
  //         fileUrl = null;
  //         // CANCEL
  //       } else {
  //         print(":::::::::::::::::::::: MERGING FAIL :::::::::::::::");
  //
  //         fileUrl = null;
  //         // ERROR
  //       }
  //     });
  //     return fileUrl;
  //   } else if (await Permission.storage.isPermanentlyDenied) {
  //     openAppSettings();
  //   } else {
  //     return null;
  //   }
  //   return null;
  // }

  Future<FileResult?> downloadFile({required String url}) async {
    final filename = url.split('/').last;
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/$filename';
    final response = await http.get(Uri.parse(url));
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);

    return FileResult(
        path: filePath,
        size: File(filePath).lengthSync() / 1024,
        fileName: url.split('/').last);
  }
}
