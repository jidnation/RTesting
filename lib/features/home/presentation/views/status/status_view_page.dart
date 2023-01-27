import 'dart:async';
import 'dart:convert';

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
  double _percent = 0;
  late Timer _timer;
  List<bool> _watched = [];
  int _currentIndex = 0;
  final audioPlayer = AudioPlayer();
  bool isPlaying = true;
  StatusFeedModel get story => widget.status[_currentIndex];
  // BetterPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _startTimer(7000);
    _watched = List.generate(widget.status.length, (index) => false);
  }

  @override
  void dispose() {
    _timer.cancel();
    audioPlayer.stop();
    audioPlayer.dispose();
    globals.statusVideoController?.dispose();
    // _videoController?.dispose();
    super.dispose();
  }

  void _startTimer(int milliSec, {double? percent}) {
    _remTime = milliSec;
    double _factor = (50 / milliSec);
    _percent = percent ?? 0;
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_percent + _factor < 1) {
        _percent += _factor;
        _remTime -= 50;
        if (mounted) {
          setState(() {});
        }
      } else {
        _percent = 1;
        _watched[_currentIndex] = true;
        if (_currentIndex < widget.status.length - 1) {
          _currentIndex++;
          setState(() {});
          _changeStatus();
        } else {
          // Navigator.pop(context);
          _timer.cancel();
          _nextStatus();
        }
      }
    });
  }

  void _restartTimer(int milliSecs) {
    _timer.cancel();
    _startTimer(milliSecs);
  }

  void _changeStatus() {
    if (audioPlayer.state == PlayerState.playing) {
      audioPlayer.stop();
    }
    if (story.status?.type == 'text' || story.status?.type == 'image') {
      _restartTimer(7000);
    } else {
      if (story.status?.type == 'audio') {
        debugPrint(
            "audio Player file: ${story.status!.statusData!.audioMedia}");
        audioPlayer.play(UrlSource("${story.status!.statusData!.audioMedia}"));
        _restartTimer(30000);
      }
      if (story.status?.type == 'video') {
        _timer.cancel();
        _percent = 0;
        setState(() {});
      }
    }
  }

  void _resumeTimer() {
    _startTimer(_remTime, percent: _percent);
  }

  void _previousStatus() {
    // as long as this isnt the first story
    if (_currentIndex > 0) {
      // set previous and curent story watched percentage back to 0
      _watched[_currentIndex - 1] = false;
      _watched[_currentIndex] = false;
      // go to previous story
      _currentIndex--;
      setState(() {});
      _changeStatus();
    } else if (_currentIndex == 0) {
      // set previous and curent story watched percentage back to 0
      _watched[_currentIndex] = false;
      // go to previous story
      setState(() {});
      _changeStatus();
    }
  }

  void _nextStatus() {
    // if there are more stories left
    if (_currentIndex < widget.status.length - 1) {
      // finish current story
      _watched[_currentIndex] = true;
      // move to next story
      _currentIndex++;
      setState(() {});
      _changeStatus();
    }
    // if user is on the last story, finish this story
    else {
      _watched[_currentIndex] = true;
      Navigator.of(context, rootNavigator: true).pop(context);
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
    final _replyTEC = useTextEditingController();
    final _focusNode = useFocusNode();
    final _keyboardController = KeyboardVisibilityController();
    final size = MediaQuery.of(context).size;
    useEffect(() {
      _keyboardController.onChange.listen((event) {
        if (event) {
          _timer.cancel();
          globals.statusVideoController?.pause();
        } else {
          _resumeTimer();
          globals.statusVideoController?.play();
        }
      });
    }, []);
    return Scaffold(
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
                              child:
                                  // _videoController == null
                                  //     ? VideoPreview(
                                  //         key:
                                  //             Key(story.status!.statusId! + 'temp'),
                                  //         isLocalVideo: false,
                                  //         onInitialised: (controller) {
                                  //           _startTimer(30000);
                                  //           _videoController = controller;
                                  //           setState(() {});
                                  //         },
                                  //         loop: true,
                                  //         showControls: false,
                                  //         path:
                                  //             story.status!.statusData!.videoMedia!,
                                  //       )
                                  //     :
                                  VideoPreview(
                                key: Key(story.status!.statusId!),
                                isLocalVideo: false,
                                onInitialised: (controller) {
                                  _startTimer(30000);
                                },
                                loop: true,
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
                                    // progressIndicatorBuilder: (c, s, p) {
                                    //   return CupertinoActivityIndicator(
                                    //       color: AppColors.white);
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
                                        child: Helper.renderProfilePicture(
                                            story.statusOwnerProfile
                                                ?.profilePicture,
                                            size: 100),
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
                                widget.status.length,
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
                                  Helper.renderProfilePicture(
                                      story.statusOwnerProfile!.profilePicture),
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
                                          showStoryBottomSheet(context,
                                              status: story.status!);
                                        } else {
                                          final res =
                                              await showUserStoryBottomSheet(
                                                  context,
                                                  isMuted: widget.isMuted,
                                                  status: story);
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
                                _timer.cancel();
                                globals.statusVideoController?.pause();
                              },
                              onLongPressUp: () {
                                _resumeTimer();
                                globals.statusVideoController?.play();
                              },
                              child: Container()),
                        ),
                        // SizedBox(
                        //   height: 4,
                        // ),
                        Visibility(
                          visible: !(widget.isMe ?? false),
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
                              _timer.cancel();
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
                                        quotedData: jsonEncode(story.toJson()),
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
    );
  }
}
