import '../../presentation/bloc/video_call_bloc.dart';
import '../datasources/call_remote_datasource.dart';

class VideoCallRepository {
  VideoCallRepository({VideoCallRemoteDataSource? videoCallRemoteDataSource})
      : _videoCallRemoteDataSource =
            videoCallRemoteDataSource ?? VideoCallRemoteDataSource();

  final VideoCallRemoteDataSource _videoCallRemoteDataSource;

Future<dynamic>  initiatePrivateCall(InitiatePrivateCall privateCall)async {
   await _videoCallRemoteDataSource.initiatePrivateCall(privateCall);
  }

  answerPrivateCall() {}

  completePrivateCall() {}

  rejectPrivateCall() {}

  updatePrivateCall() {}
}
