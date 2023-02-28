// import 'package:audio_waveforms/audio_waveforms.dart';
// import 'package:flutter/foundation.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:reach_me/core/models/file_result.dart';
//
// class AudioRecordingService {
//   final _soundRecorderController = RecorderController()
//     ..androidEncoder = AndroidEncoder.aac
//     ..androidOutputFormat = AndroidOutputFormat.aac_adts
//     ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
//     ..sampleRate = 16000;
//   String? _fileName;
//
//   final recording = ValueNotifier<bool>(false);
//
//   AudioRecordingService() {
//     _soundRecorderController.addListener(() {
//       if (_soundRecorderController.recorderState == RecorderState.recording) {
//         recording.value = true;
//       } else {
//         recording.value = false;
//       }
//     });
//   }
//
//   Future<void> record({required String fileName}) async {
//     _fileName = fileName;
//     final path = await _recordPath();
//     _soundRecorderController.record(path);
//   }
//
//   Future<FileResult?> stop() async {
//     final path = await _recordPath();
//     _soundRecorderController.stop(true);
//     return FileResult(path: path, fileName: _fileName ?? 'reach_aud.aac');
//   }
//
//   Future<String> _recordPath() async {
//     final directory = await getTemporaryDirectory();
//     return '${directory.path}/${_fileName ?? 'reach_aud.aac'}';
//   }
//
//   bool get isRecording => recording.value;
//
//   RecorderController get recorderController => _soundRecorderController;
// }
