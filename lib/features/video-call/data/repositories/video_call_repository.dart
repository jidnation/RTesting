import '../datasources/call_remote_datasource.dart';

class VideoCallRepository {
  VideoCallRepository({VideoCallRemoteDataSource? videoCallRemoteDataSource})
      : videoCallRemoteDataSource =
            videoCallRemoteDataSource ?? VideoCallRemoteDataSource();

  final VideoCallRemoteDataSource videoCallRemoteDataSource;

  initiatePrivateCall() {}

  answerPrivateCall() {}

  completePrivateCall() {}

  rejectPrivateCall() {}

  updatePrivateCall() {}
}
