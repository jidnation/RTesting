import 'package:reach_me/core/helper/logger.dart';

import '../../../../core/services/api/api_client.dart';
import '../datasources/call_remote_datasource.dart';

class VideoCallRepository {
  VideoCallRepository(
      {VideoCallRemoteDataSource? videoCallRemoteDataSource,
      ApiClient? apiClient})
      : videoCallRemoteDataSource =
            videoCallRemoteDataSource ?? VideoCallRemoteDataSource(),
        _apiClient = apiClient ?? ApiClient();

  final VideoCallRemoteDataSource videoCallRemoteDataSource;
  final ApiClient _apiClient;

  initiateCall() async {
    var test = await videoCallRemoteDataSource.testNotifications();
    Console.log('test notifications', test);
  }

  endCall() async {}
}
