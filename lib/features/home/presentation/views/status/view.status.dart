import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:reach_me/core/components/custom_textfield.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/core/utils/helpers.dart';
import 'package:reach_me/features/account/presentation/widgets/bottom_sheets.dart';
import 'package:reach_me/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:reach_me/features/home/data/models/status.model.dart';
import 'package:story_time/story_page_view/story_page_view.dart';

class ViewMyStatus extends HookWidget {
  const ViewMyStatus({Key? key, required this.status}) : super(key: key);
  final List<StatusModel> status;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: StoryPageView(
        indicatorDuration: const Duration(seconds: 7),
        itemBuilder: (context, pageIndex, storyIndex) {
          final story = status[storyIndex];
          //final image = images[storyIndex];
          if (story.statusData!.imageMedia != null ||
              (story.statusData!.imageMedia ?? '').isNotEmpty) {
            return Stack(
              children: [
                Positioned.fill(
                  child: Container(color: AppColors.black),
                ),
                Positioned.fill(
                  child: SizedBox(
                    height: size.height,
                    width: size.width,
                    child: CachedNetworkImage(
                      imageUrl: story.statusData!.imageMedia!,
                      fit: BoxFit.fitWidth,
                      placeholder: (context, url) =>
                          const CupertinoActivityIndicator(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 44, left: 8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Helper.renderProfilePicture(
                              story.profileModel!.profilePicture ?? ''),
                          SizedBox(width: getScreenWidth(12)),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '@${globals.user!.username!}',
                                style: TextStyle(
                                  fontSize: getScreenHeight(16),
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return Stack(
            children: [
              Positioned.fill(
                child: Container(color: AppColors.black),
              ),
              //check typename from model and display widgets accordingly

              if (story.statusData!.background!.contains('0x'))
                Positioned.fill(
                  child: Container(
                    height: size.height,
                    width: size.width,
                    decoration: BoxDecoration(
                      color: Helper.getStatusBgColour(
                          story.statusData!.background!),
                    ),
                    child: Center(
                      child: Text(
                        story.statusData!.caption!,
                        textAlign: Helper.getAlignment(
                            story.statusData!.alignment!)['align'],
                        style: Helper.getFont(story.statusData!.font!),
                      ),
                    ),
                  ),
                )
              else
                Positioned.fill(
                  child: Container(
                    height: size.height,
                    width: size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(story.statusData!.background!),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        story.statusData!.caption!,
                        textAlign: Helper.getAlignment(
                            story.statusData!.alignment!)['align'],
                        style: Helper.getFont(story.statusData!.font!),
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 44, left: 8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Helper.renderProfilePicture(
                            story.profileModel!.profilePicture ?? ''),
                        SizedBox(width: getScreenWidth(12)),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '@${globals.user!.username!}',
                              style: TextStyle(
                                fontSize: getScreenHeight(16),
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        gestureItemBuilder: (context, pageIndex, storyIndex) {
          return Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 44),
              child: Container(
                height: getScreenHeight(30),
                decoration: BoxDecoration(
                  color: AppColors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  color: Colors.white,
                  icon: const Icon(Icons.more_horiz_rounded),
                  onPressed: () {
                    showStoryBottomSheet(context, status: status[storyIndex]);
                  },
                ),
              ),
            ),
          );
        },
        pageLength: 1,
        storyLength: (int pageIndex) {
          return status.length;
        },
        onPageLimitReached: () {
          RouteNavigators.pop(context);
        },
      ),
    );
  }
}

class ViewUserStatus extends HookWidget {
  const ViewUserStatus({Key? key, required this.status}) : super(key: key);
  final List<StatusFeedResponseModel> status;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final controller = useTextEditingController();
    return Scaffold(
      body: BlocConsumer<ChatBloc, ChatState>(
          bloc: globals.chatBloc,
          listener: (context, state) {
            if (state is ChatSendSuccess) {
              toast('Message sent successfully');
            }
            if (state is ChatSendError) {
              toast(state.error!);
            }
          },
          builder: (context, state) {
            return StoryPageView(
              indicatorDuration: const Duration(seconds: 100),
              itemBuilder: (context, pageIndex, storyIndex) {
                final story = status[storyIndex];
                //final image = images[storyIndex];
                return Stack(
                  children: [
                    Positioned.fill(
                      child: Container(color: AppColors.black),
                    ),
                    //check typename from model and display widgets accordingly
                    if (story.status!.statusData!.background!.contains('0x'))
                      Positioned.fill(
                        child: Container(
                          height: size.height,
                          width: size.width,
                          decoration: BoxDecoration(
                            color: Helper.getStatusBgColour(
                                story.status!.statusData!.background!),
                          ),
                          child: Center(
                            child: Text(
                              story.status!.statusData!.caption!,
                              textAlign: Helper.getAlignment(story
                                  .status!.statusData!.alignment!)['align'],
                              style: Helper.getFont(
                                  story.status!.statusData!.font!),
                            ),
                          ),
                        ),
                      )
                    else
                      Positioned.fill(
                        child: Container(
                          height: size.height,
                          width: size.width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  story.status!.statusData!.background!),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              story.status!.statusData!.caption!,
                              textAlign: Helper.getAlignment(story
                                  .status!.statusData!.alignment!)['align'],
                              style: Helper.getFont(
                                  story.status!.statusData!.font!),
                            ),
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 44, left: 8),
                      child: Row(
                        children: [
                          Helper.renderProfilePicture(
                              story.statusCreatorModel!.profilePicture ?? ''),
                          SizedBox(width: getScreenWidth(12)),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (story.statusCreatorModel!.firstName! +
                                        ' ' +
                                        story.statusCreatorModel!.lastName!)
                                    .toTitleCase(),
                                style: TextStyle(
                                  fontSize: getScreenHeight(16),
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '@${story.statusCreatorModel!.username!}',
                                style: TextStyle(
                                  fontSize: getScreenHeight(13),
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
              gestureItemBuilder: (context, pageIndex, storyIndex) {
                final story = status[storyIndex];
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 44),
                        child: Container(
                          height: getScreenHeight(30),
                          decoration: BoxDecoration(
                            color: AppColors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            color: Colors.white,
                            icon: const Icon(Icons.more_horiz_rounded),
                            onPressed: () {
                              showUserStoryBottomSheet(context,
                                  status: status[storyIndex]);
                            },
                          ),
                        ),
                      ),
                    ),
                    CustomRoundTextField(
                      hintText: 'Reach out to...',
                      hintStyle: TextStyle(
                        color: AppColors.white.withOpacity(0.5),
                        fontSize: getScreenHeight(14),
                      ),
                      textStyle: TextStyle(
                        color: AppColors.white,
                        fontSize: getScreenHeight(14),
                      ),
                      controller: controller,
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
                      suffixIcon: GestureDetector(
                        onTap: () {
                          if (controller.text.isNotEmpty) {
                            globals.chatBloc!.add(
                              SendChatMessageEvent(
                                senderId: globals.user!.id,
                                receiverId: story.authId,
                                threadId:
                                    '${globals.user!.id}--${story.authId}',
                                value: controller.text.trim(),
                                type: 'text',
                              ),
                            );
                            toast('Sending message...',
                                duration: Toast.LENGTH_LONG);
                            controller.clear();
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
                  ],
                );
              },
              pageLength: 1,
              storyLength: (int pageIndex) {
                return status.length;
              },
              onPageLimitReached: () {
                Navigator.pop(context);
              },
            );
          }),
    );
  }
}
