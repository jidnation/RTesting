import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/video_call_repository.dart';

part 'video_call_event.dart';
part 'video_call_state.dart';

class VideoCallBloc extends Bloc<VideoCallEvent, VideoCallState> {
  final VideoCallRepository videoCallRepository = VideoCallRepository();
  VideoCallBloc() : super(VideoCallInitial()) {
    on<InitiateCall>((event, emit) => _initiateCall(event, emit));
    on<EndCall>((event, emit) => _endCall(event, emit));
  }

  _initiateCall(InitiateCall event, emit) async {}

  _endCall(EndCall event, emit) async {}
}
