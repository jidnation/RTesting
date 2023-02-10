import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/utils/constants.dart';
import '../../core/utils/dimensions.dart';
import 'momentControlRoom/control_room.dart';
import 'moment_feed.dart';

class UserCommentBox extends HookWidget {
  const UserCommentBox({
    Key? key,
    required this.momentFeed,
  }) : super(key: key);

  final MomentModel momentFeed;

  @override
  Widget build(BuildContext context) {
    TextEditingController inputController = useTextEditingController();
    return Container(
      height: getScreenHeight(68),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      width: SizeConfig.screenWidth,
      color: Colors.white,
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(
          height: 40,
          width: 40,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(30),
              image: momentFeed.feedOwnerInfo.profilePicture?.isNotEmpty ?? false
                  ? DecorationImage(
                      image: NetworkImage(momentFeed.feedOwnerInfo.profilePicture!),
                      fit: BoxFit.cover,
                    )
                  : null),
          child: momentFeed.feedOwnerInfo.profilePicture?.isEmpty ?? false
              ? Image.asset("assets/images/app-logo.png")
              : null,
        ),
        const SizedBox(width: 5),
        Expanded(
          child: TextFormField(
            cursorColor: AppColors.primaryColor,
            cursorWidth: 3,
            controller: inputController,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'comment as ${momentFeed.feedOwnerInfo.username}',
                hintStyle: TextStyle(
                  color: const Color(0xff252525).withOpacity(0.5),
                  fontSize: 11.44,
                )),
          ),
        ),
        const SizedBox(width: 5),
        InkWell(
            onTap: () async {
              FocusScope.of(context).unfocus();
              bool isDone = await momentFeedStore.commentOnMoment(context,
                  id: momentFeed.id,
                  userComment: inputController.text.isNotEmpty
                      ? inputController.text
                      : null);
              isDone ? inputController.clear() : null;
            },
            child: SvgPicture.asset('assets/svgs/send.svg'))
      ]),
    );
  }
}
