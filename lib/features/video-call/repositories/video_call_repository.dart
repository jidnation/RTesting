import '../../../core/services/api/api_client.dart';
import '../data/call_remote_datasource.dart';

class VideoCallRepository {
  VideoCallRepository(
      {VideoCallRemoteDataSource? videoCallRemoteDataSource,
      ApiClient? apiClient})
      : videoCallRemoteDataSource =
            videoCallRemoteDataSource ?? VideoCallRemoteDataSource(),
        _apiClient = apiClient ?? ApiClient();

  final VideoCallRemoteDataSource videoCallRemoteDataSource;
  final ApiClient _apiClient;


  initiateCall()async{}

  endCall()async{}

}
