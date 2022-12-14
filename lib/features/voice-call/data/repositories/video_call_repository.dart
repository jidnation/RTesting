import '../datasources/audio_call_remote_datasource.dart';

class VoiceCallRepository {
  VoiceCallRepository({VoiceCallRemoteDataSource? videoCallRemoteDataSource})
      : _videoCallRemoteDataSource =
            videoCallRemoteDataSource ?? VoiceCallRemoteDataSource();

  final VoiceCallRemoteDataSource _videoCallRemoteDataSource;

  Future<dynamic> initiatePrivateCall() async {
    await _videoCallRemoteDataSource.initiatePrivateCall();
  }

  answerPrivateCall() {}

  completePrivateCall() {}

  rejectPrivateCall() {}

  updatePrivateCall() {}
}
