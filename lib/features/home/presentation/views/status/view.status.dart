import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reach_me/core/components/custom_textfield.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/core/utils/helpers.dart';
import 'package:reach_me/features/account/presentation/widgets/bottom_sheets.dart';
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
              Positioned.fill(
                child: Container(
                  height: size.height,
                  width: size.width,
                  decoration: BoxDecoration(
                    color: story.statusData!.background!.contains('Color')
                        ? Color(int.parse(story.statusData!.background!))
                        : null,
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
                child: Row(
                  children: [
                    Helper.renderProfilePicture(
                        story.profileModel!.profilePicture ?? ''),
                    SizedBox(width: getScreenWidth(12)),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (globals.user!.firstName! +
                                  ' ' +
                                  globals.user!.lastName!)
                              .toTitleCase(),
                          style: TextStyle(
                            fontSize: getScreenHeight(16),
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '@${globals.user!.username!}',
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
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomRoundTextField(
                    hintText: 'Reach out to...',
                    textCapitalization: TextCapitalization.none,
                    fillColor: AppColors.black.withOpacity(0.5),
                    enabledBorderSide:
                        const BorderSide(width: 1, color: AppColors.white),
                    focusedBorderSide:
                        const BorderSide(width: 1, color: AppColors.white),
                  )
                ],
              ).paddingOnly(b: 35, r: 8, l: 8)
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
          Navigator.pop(context);
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

    return Scaffold(
      body: StoryPageView(
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
              Positioned.fill(
                child: Container(
                  height: size.height,
                  width: size.width,
                  decoration: BoxDecoration(
                    color: story.status!.statusData!.background!
                            .contains('Color')
                        ? Color(
                            int.parse(story.status!.statusData!.background!))
                        : null,
                    image: DecorationImage(
                      image: AssetImage(story.status!.statusData!.background!),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      story.status!.statusData!.caption!,
                      textAlign: Helper.getAlignment(
                          story.status!.statusData!.alignment!)['align'],
                      style: Helper.getFont(story.status!.statusData!.font!),
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
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomRoundTextField(
                    hintText: 'Reach out to...',
                    textCapitalization: TextCapitalization.none,
                    fillColor: AppColors.black.withOpacity(0.5),
                    enabledBorderSide:
                        const BorderSide(width: 1, color: AppColors.white),
                    focusedBorderSide:
                        const BorderSide(width: 1, color: AppColors.white),
                  )
                ],
              ).paddingOnly(b: 35, r: 8, l: 8)
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
                    //showStoryBottomSheet(context, status: status[storyIndex]);
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
          Navigator.pop(context);
        },
      ),
    );
  }
}
