import 'dart:io';
import 'dart:ui';

class FileResult {
  String path;
  num? height;
  num? width;
  int? duration;
  double? size;
  String? fileName;
  String? thumbnail;

  FileResult(
      {required this.path,
      this.height,
      this.width,
      this.duration,
      this.size,
      this.thumbnail,
      this.fileName});

  set file(File val) => path = val.path;
  File get file => File(path);

  double? get aspectRatio =>
      width != null && height != null ? width! / height! : null;

  Size fitToWidth(double maxDimension) {
    late Size size;
    final width = (this.width ?? 0).toDouble();
    final height = (this.height ?? 0).toDouble();
    if (width >= height) {
      size = Size(maxDimension, (maxDimension * width) / height);
    } else {
      size = Size((maxDimension * height) / width, maxDimension);
    }
    this.width = size.width;
    this.height = size.height;
    return size;
  }

  FileResult copyWith(
      {String? path,
      num? height,
      num? width,
      int? duration,
      double? size,
      String? thumbnail,
      String? fileName}) {
    return FileResult(
        path: path ?? this.path,
        height: height ?? this.height,
        width: width ?? this.width,
        duration: duration ?? this.duration,
        size: size ?? this.size,
        thumbnail: thumbnail ?? this.thumbnail,
        fileName: fileName ?? this.fileName);
  }
}
