import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:reach_me/core/components/custom_textfield.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/assets.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/core/utils/helpers.dart';
import 'package:reach_me/features/account/presentation/widgets/bottom_sheets.dart';
import 'package:reach_me/features/chat/data/models/chat.dart';
import 'package:reach_me/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:reach_me/features/home/data/models/status.model.dart';
import 'package:reach_me/features/home/presentation/widgets/video_preview.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'view.status.dart';
import 'widgets/status_indicator.dart';

class StatusViewPage extends StatefulHookWidget {
  final List<StatusFeedModel> status;
  final bool? isMuted;
  final bool isMe;
  const StatusViewPage(
      {Key? key, required this.status, this.isMuted, this.isMe = false})
      : super(key: key);

  @override
  State<StatusViewPage> createState() => _StatusViewPageState();
}

class _StatusViewPageState extends State<StatusViewPage> {
  int _remTime = 5;
  int _statusDur = 0;
  double _percent = 0;
  late Timer _timer;
  List<bool> _watched = [];
  int _currentIndex = 0;
  final audioPlayer = AudioPlayer();
  bool _audioPaused = false;
  List<StatusFeedModel> stories = [];
  StatusFeedModel get story => stories[_currentIndex];
  final _keyboardController = KeyboardVisibilityController();
  final _replyTEC = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    stories = widget.status;
    super.initState();
    _watched = List.generate(stories.length, (index) => false);
    _initStatus();
    _initialiseKeyboardListener();
  }

  @override
  void dispose() {
    if (mounted) _timer.cancel();
    audioPlayer.stop();
    audioPlayer.dispose();
    globals.statusVideoController?.dispose();
    super.dispose();
  }

  void _initialiseKeyboardListener() {
    _keyboardController.onChange.listen((event) {
      if (event) {
        _pauseTimer();
      } else {
        _resumeTimer();
      }
    });
    audioPlayer.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.playing) {}
    });
  }

  int get statusMillisec {
    if (story.status?.statusData?.audioMedia != null ||
        story.status?.statusData?.videoMedia != null) {
      return 30000;
    } else {
      return 7000;
    }
  }

  void _startTimer(int milliSec, {double? percent, bool? useCustomTime}) {
    _remTime = milliSec;
    double _factor =
        (useCustomTime ?? false) ? (50 / _statusDur) : (50 / statusMillisec);
    _percent = percent ?? 0;
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if ((_percent + _factor) < 1) {
        _percent += _factor;
        _remTime -= 50;
        if (mounted) {
          setState(() {});
        }
      } else {
        _percent = 1;
        _watched[_currentIndex] = true;
        if (_currentIndex < stories.length - 1) {
          _nextStatus();
        } else {
          _timer.cancel();
          _nextStatus();
        }
      }
    });
  }

  void _restartTimer(int milliSecs, {bool? useCustomTime}) {
    _timer.cancel();
    _startTimer(milliSecs, useCustomTime: useCustomTime);
  }

  Future<void> _initStatus() async {
    if (story.status?.type == 'text') {
      _startTimer(7000);
    } else if (story.status?.statusData?.audioMedia != null) {
      debugPrint("audio Player file: ${story.status!.statusData!.audioMedia}");
      await audioPlayer
          .play(UrlSource("${story.status!.statusData!.audioMedia}"));
      await audioPlayer.getDuration().then((value) {
        _statusDur = (value?.inMilliseconds ?? 30000) > 30000
            ? 30000
            : (value?.inMilliseconds ?? 30000);
        setState(() {});
        _startTimer(_statusDur, useCustomTime: true);
      });
    } else if (story.status?.statusData?.videoMedia != null) {
      _percent = 0;
      setState(() {});
    } else if (story.status?.statusData?.imageMedia != null) {
      _startTimer(7000);
    }
  }

  Future<void> _changeStatus() async {
    _focusNode.unfocus();
    _replyTEC.clear();
    if (audioPlayer.state == PlayerState.playing) {
      audioPlayer.stop();
      audioPlayer.dispose();
    }
    if (story.status?.type == 'text') {
      _restartTimer(7000);
    } else if (story.status?.statusData?.audioMedia != null) {
      _timer.cancel();
      _percent = 0;
      setState(() {});
      debugPrint("audio Player file: ${story.status!.statusData!.audioMedia}");
      await audioPlayer
          .play(UrlSource("${story.status!.statusData!.audioMedia}"));
      // final duration = await
      audioPlayer.getDuration().then((value) {
        _statusDur = (value?.inMilliseconds ?? 30000) > 30000
            ? 30000
            : (value?.inMilliseconds ?? 30000);
        setState(() {});
        _restartTimer(_statusDur, useCustomTime: true);
      });
    } else if (story.status?.statusData?.videoMedia != null) {
      _timer.cancel();
      _percent = 0;
      setState(() {});
    } else if (story.status?.statusData?.imageMedia != null) {
      _restartTimer(7000);
    }
  }

  void _resumeTimer() {
    _startTimer(_remTime,
        percent: _percent,
        useCustomTime: story.status?.statusData?.audioMedia != null ||
            story.status?.statusData?.videoMedia != null);
    globals.statusVideoController?.play();
    if (audioPlayer.state == PlayerState.paused) {
      _audioPaused = false;
      audioPlayer.resume();
      setState(() {});
    }
    if (mounted) setState(() {});
  }

  void _pauseTimer() {
    _timer.cancel();
    if (mounted) setState(() {});
    globals.statusVideoController?.pause();
    if (audioPlayer.state == PlayerState.playing) {
      _audioPaused = true;
      audioPlayer.pause();
      setState(() {});
    }
  }

  Future<void> _previousStatus() async {
    // as long as this isnt the first story
    if (_currentIndex > 0) {
      // set previous and curent story watched percentage back to 0
      _watched[_currentIndex - 1] = false;
      _watched[_currentIndex] = false;
      // go to previous story
      _currentIndex--;
      setState(() {});
      await _changeStatus();
    } else if (_currentIndex == 0) {
      // set previous and curent story watched percentage back to 0
      _watched[_currentIndex] = false;
      // go to previous story
      setState(() {});
      await _changeStatus();
    }
  }

  Future<void> _nextStatus() async {
    // if there are more stories left
    if (_currentIndex < stories.length - 1) {
      // finish current story
      _watched[_currentIndex] = true;
      // move to next story
      _currentIndex++;
      setState(() {});
      await _changeStatus();
    }
    // if user is on the last story, finish this story
    else {
      _watched[_currentIndex] = true;
      if (mounted) Navigator.of(context, rootNavigator: true).pop(stories);
    }
  }

  void _onTapDown(TapUpDetails details) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dx = details.globalPosition.dx;
    // user taps on first half of screen
    if (dx < screenWidth / 2) {
      _previousStatus();
    }
    // user taps on second half of screen
    else {
      _nextStatus();
    }
  }

  // audioPlayer.play(UrlSource("${story.statusData!.audioMedia}"));

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, stories);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: null,
        backgroundColor: AppColors.black,
        body: BlocConsumer<ChatBloc, ChatState>(
          bloc: globals.chatBloc,
          listener: (context, state) {
            if (state is ChatSendSuccess) {
              toast('Message sent successfully');
              _replyTEC.clear();
              _focusNode.unfocus();
            }
            if (state is ChatSendError) {
              toast(state.error!);
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: KeyboardVisibilityBuilder(
                builder: (context, visible) {
                  return Stack(
                    children: [
                      // if ((story.status?.statusData?.imageMedia ?? '').isNotEmpty)
                      Positioned.fill(
                        child: story.status?.type == 'video'
                            ? Container(
                                height: size.height,
                                width: size.width,
                                color: AppColors.black,
                                child: VideoPreview(
                                  key: Key(story.status!.statusId!),
                                  isLocalVideo: false,
                                  onInitialised: (controller) {
                                    _statusDur = controller
                                            .videoPlayerController
                                            ?.value
                                            .duration
                                            ?.inMilliseconds ??
                                        30000;
                                    setState(() {});
                                    _startTimer(
                                        _statusDur > 30000 ? 30000 : _statusDur,
                                        useCustomTime: true);
                                  },
                                  loop: false,
                                  showControls: false,
                                  path: story.status!.statusData!.videoMedia!,
                                ),
                              )
                            : ((story.status?.statusData?.imageMedia ?? '')
                                    .isNotEmpty)
                                ? SizedBox(
                                    height: size.height,
                                    width: size.width,
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          story.status!.statusData!.imageMedia!,
                                      fit: BoxFit.fitWidth,
                                      // imageBuilder: (c, r){
                                      //
                                      // },
                                      // imageBuilder: (c, ip) {
                                      //   Console.log(
                                      //       'taaaggggg::1::', ip.toString());
                                      //   return Image.network(story
                                      //       .status!.statusData!.imageMedia!);
                                      // },
                                      // progressIndicatorBuilder: (c, s, p) {
                                      //   // Console.log(
                                      //   //     'taaaggggg::2::',
                                      //   //     'd=' +
                                      //   //         p.downloaded.toString() +
                                      //   //         '|| p=' +
                                      //   //         p.progress.toString());
                                      //   if (((p.progress ?? 1.0) == 1.0) &&
                                      //       (_percent == 0)) {
                                      //     _startTimer(7000);
                                      //   }
                                      //   return const CupertinoActivityIndicator(
                                      //     color: AppColors.white,
                                      //   );
                                      // },
                                      placeholder: (context, url) =>
                                          const CupertinoActivityIndicator(
                                        color: AppColors.white,
                                      ),
                                    ),
                                  )
                                : ((story.status?.statusData!.audioMedia ?? '')
                                        .isNotEmpty)
                                    ? SizedBox(
                                        height: size.height,
                                        width: size.width,
                                        child: Center(
                                          child: Stack(
                                            children: [
                                              Image.asset(
                                                AppAssets.audioRipple,
                                                height: getScreenHeight(250),
                                              ),
                                              Positioned(
                                                top: 45,
                                                left: 72,
                                                child:
                                                    Helper.renderProfilePicture(
                                                        story.statusOwnerProfile
                                                            ?.profilePicture,
                                                        size: 135),
                                              ),
                                            ],
                                          ),
                                        ))
                                    : Container(
                                        height: size.height,
                                        width: size.width,
                                        decoration: BoxDecoration(
                                            color: Helper.getStatusBgColour(
                                                '${story.status?.statusData!.background}'),
                                            image: (story.status?.statusData
                                                            ?.background ??
                                                        '')
                                                    .contains('0x')
                                                ? null
                                                : DecorationImage(
                                                    image: AssetImage(story
                                                            .status
                                                            ?.statusData
                                                            ?.background ??
                                                        ''),
                                                    fit: BoxFit.cover,
                                                  )),
                                        child: Center(
                                          child: Text(
                                            '${story.status?.statusData!.caption}',
                                            textAlign: Helper.getAlignment(
                                                    '${story.status?.statusData!.alignment}')[
                                                'align'],
                                            style: Helper.getFont(
                                                '${story.status?.statusData!.font}'),
                                          ),
                                        ),
                                      ),
                      ),
                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 8),
                            child: Row(
                              children: List.generate(
                                  stories.length,
                                  (index) => Expanded(
                                        child: StatusIndicator(
                                            percent: index == _currentIndex
                                                ? _percent
                                                : _watched[index]
                                                    ? 1
                                                    : 0),
                                      )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                        child: Container(
                                          padding: EdgeInsets.all(
                                              Platform.isIOS ? 4 : 8),
                                          child: Icon(
                                            Platform.isIOS
                                                ? Icons.chevron_left
                                                : Icons.keyboard_backspace,
                                            color: AppColors.white,
                                          ),
                                        ),
                                        onTap: () =>
                                            Navigator.pop(context, stories)),
                                    Helper.renderProfilePicture(story
                                        .statusOwnerProfile!.profilePicture),
                                    SizedBox(width: getScreenWidth(12)),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            (story.statusOwnerProfile!
                                                        .firstName! +
                                                    ' ' +
                                                    story.statusOwnerProfile!
                                                        .lastName!)
                                                .toTitleCase(),
                                            style: TextStyle(
                                              fontSize: getScreenHeight(16),
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                '@${story.statusOwnerProfile!.username!}',
                                                style: TextStyle(
                                                  fontSize: getScreenHeight(13),
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                timeago.format(
                                                    story.status!.createdAt!),
                                                style: TextStyle(
                                                  fontSize: getScreenHeight(13),
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () async {
                                          if (widget.isMe) {
                                            _pauseTimer();
                                            final res =
                                                await showStoryBottomSheet(
                                                    context,
                                                    status: story.status!);
                                            _resumeTimer();
                                            if (res == null) return;
                                            if (res is String) {
                                              if (_currentIndex ==
                                                  (stories.length - 1)) {
                                                stories.removeAt(_currentIndex);
                                                _nextStatus();
                                              } else {
                                                stories.removeAt(_currentIndex);
                                                setState(() {});
                                              }
                                              // _nextStatus();
                                            }
                                          } else {
                                            _pauseTimer();
                                            final res =
                                                await showUserStoryBottomSheet(
                                                    context,
                                                    isMuted: widget.isMuted,
                                                    status: story);
                                            _resumeTimer();
                                            if (res == null) return;
                                            if (res is MuteResult) {
                                              Navigator.pop(context, res);
                                            }
                                          }
                                        },
                                        icon: Icon(
                                          Icons.more_horiz,
                                          color: AppColors.white,
                                        ))
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Expanded(
                            child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTapUp: (details) => _onTapDown(details),
                                onLongPress: () {
                                  _pauseTimer();
                                },
                                onLongPressUp: () {
                                  _resumeTimer();
                                },
                                child: Container()),
                          ),
                          // SizedBox(
                          //   height: 4,
                          // ),
                          Visibility(
                            visible: !(widget.isMe),
                            child: CustomRoundTextField(
                              hintText: 'Reach out to...',
                              focusNode: _focusNode,
                              hintStyle: TextStyle(
                                color: AppColors.white.withOpacity(0.5),
                                fontSize: getScreenHeight(14),
                              ),
                              textStyle: TextStyle(
                                color: AppColors.white,
                                fontSize: getScreenHeight(14),
                              ),
                              controller: _replyTEC,
                              isFilled: true,
                              textCapitalization: TextCapitalization.none,
                              fillColor: AppColors.black.withOpacity(0.3),
                              enabledBorderSide: const BorderSide(
                                width: 0.5,
                                color: AppColors.white,
                              ),
                              focusedBorderSide: const BorderSide(
                                width: 0.5,
                                color: AppColors.white,
                              ),
                              onTap: () {
                                // _timer.cancel();
                              },
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  if (_replyTEC.text.isNotEmpty) {
                                    globals.chatBloc!.add(
                                      SendChatMessageEvent(
                                          senderId: globals.user!.id,
                                          receiverId:
                                              story.statusOwnerProfile!.authId,
                                          value: _replyTEC.text.trim(),
                                          type: 'text',
                                          quotedData:
                                              jsonEncode(story.toJson()),
                                          messageMode: MessageMode.quoted.name),
                                    );
                                    toast('Sending message...',
                                        duration: Toast.LENGTH_LONG);
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(7),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/svgs/send.svg',
                                    width: 25,
                                    height: 25,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ).paddingOnly(b: 35, r: 8, l: 8),
                          ),
                          // Text(
                          //   _remTime.toString(),
                          //   style: const TextStyle(fontSize: 24, color: AppColors.white),
                          // ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
