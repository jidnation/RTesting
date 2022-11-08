import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_thumbnail/video_thumbnail.dart' as t;
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

import '../models/file_result.dart';
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
        locale: Locale('en'),
        pickerConfig: CameraPickerConfig(
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

  Future<FileResult?> pickFromGallery() async {
    final res = await AssetPicker.pickAssets(
      _navigatorKey.currentContext!,
      pickerConfig: AssetPickerConfig(
        maxAssets: 1,
        specialPickerType: SpecialPickerType.noPreview,
        requestType: RequestType.common,
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

  Future<FileResult?> getVideo() async {
    final res = await AssetPicker.pickAssets(
      _navigatorKey.currentContext!,
      pickerConfig: AssetPickerConfig(
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

  Future<FileResult?> getAudio() async {
    final res = await AssetPicker.pickAssets(
      _navigatorKey.currentContext!,
      pickerConfig: AssetPickerConfig(
        maxAssets: 1,
        requestType: RequestType.audio,
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

  Future<FileResult> compressVideo({required FileResult file}) async {
    final res = await VideoCompress.compressVideo(
      file.path,
      quality: VideoQuality.MediumQuality,
    );
    return FileResult(
        path: res!.path!,
        size: res.filesize! / 1024,
        duration: file.duration,
        height: file.height,
        width: file.width,
        fileName: res.path!.split('/').last);
  }

  Future<FileResult?> loadMediaFromCamera({bool? enableRecording}) async {
    final res = await CameraPicker.pickFromCamera(_navigatorKey.currentContext!,
        locale: Locale('en'),
        pickerConfig:
            CameraPickerConfig(enableRecording: enableRecording ?? false));
    if (res == null) return null;
    final file = await res.originFile;
    if (file == null) return null;
    return FileResult(
        path: file.path,
        size: file.lengthSync() / 1024,
        duration: res.videoDuration.inSeconds,
        height: res.height,
        width: res.width,
        fileName: (file).path.split('/').last);
  }

  Future<FileResult?> loadMediaFromGallery(
      {required BuildContext context, RequestType? requestType}) async {
    List<AssetEntity>? res;
    if (requestType == null) {
      res = await AssetPicker.pickAssets(context,
          pickerConfig: AssetPickerConfig(
            maxAssets: 1,
            specialPickerType: SpecialPickerType.noPreview,
          ));
    } else {
      res = await AssetPicker.pickAssets(context,
          pickerConfig: AssetPickerConfig(
              specialPickerType: SpecialPickerType.noPreview,
              maxAssets: 1,
              requestType: requestType));
    }
    if (res == null || res.isEmpty) return null;
    final file = await res.first.originFile;
    if (file == null) return null;
    String? thumbnail;
    if (FileUtils.isVideo(file)) {
      thumbnail = (await getVideoThumbnail(videoPath: file.path))?.path;
      // thumbnail = await t.VideoThumbnail.thumbnailFile(
      //   video: file.path,
      //   imageFormat: t.ImageFormat.JPEG,
      //   thumbnailPath: (await getTemporaryDirectory()).path,
      //   maxWidth:
      //       128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      //   quality: 100,
      // );
    }
    return FileResult(
        path: file.path,
        size: file.lengthSync() / 1024,
        duration: res.first.videoDuration.inSeconds,
        height: res.first.height,
        width: res.first.width,
        thumbnail: thumbnail,
        fileName: (file).path.split('/').last);
  }

  Future<FileResult?> getVideoThumbnail({required String videoPath}) async {
    String? thumbnailPath;
    int? height, width;
    thumbnailPath = await t.VideoThumbnail.thumbnailFile(
      video: videoPath,
      imageFormat: t.ImageFormat.PNG,
      thumbnailPath: (await getTemporaryDirectory()).path,
      // maxWidth:
      //     256, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
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
}
