import 'package:cloudinary/cloudinary.dart';

// enum FileType { audio, video, image }

class FileConverter {
  final cloudinary = Cloudinary.signedConfig(
    apiKey: '662963845688955',
    apiSecret: 'k8P1HIWZE5Iq7r5PT4R_GqkeE5A',
    cloudName: 'dwj7naozp',
  );
  Future<String?> convertMe({required String filePath}) async {
    try {
      final response = await cloudinary.upload(
          file: filePath,
          // fileBytes: file.readAsBytesSync(),
          resourceType: CloudinaryResourceType.auto,
          // folder: cloudinaryCustomFolder,
          // fileName: 'some-name',
          progressCallback: (count, total) {
            print('Uploading image from file with progress: $count/$total');
          });
      if (response.isSuccessful) {
        print('Get your image from with ${response.secureUrl}');
      }

      print('>>>>>>>>>>>>>>>>>>> returned >>>> ${response.secureUrl}');
      return '${response.secureUrl}';
    } catch (e) {
      print('>>>>>>>>>>>>>>>>>>>Error returned >>>> ${e.toString()}');
      // print('.....34... ${e.message}');
      // print('......se... ${e.request}');
    }
    return null;
  }
}

// Future<String> saveImageToCloudinary({required File file}) async {
//   CloudinaryResponse response;
//   final _cloudinaryService =
//       CloudinaryPublic('CLOUD_NAME', 'UPLOAD_PRESET', cache: false);
//   try {
//     response = await _cloudinaryService.uploadFile(
//         file.path, CloudinaryResourceType.Auto);
//     print("Cloudinary response ${response.url}");
//     return Future.value(response.secureUrl);
//   } on PlatformException catch (e) {
//     print("Failed to pick image: $e");
//     throw Exception();
//   }
// }
