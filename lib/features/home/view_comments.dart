import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/components/custom_textfield.dart';
import 'package:reach_me/core/components/profile_picture.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:readmore/readmore.dart';

class ViewCommentsScreen extends StatelessWidget {
  static String id = 'view_comments_screen';
  const ViewCommentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
          backgroundColor: AppColors.white,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
          centerTitle: false,
          elevation: 0,
          leading: IconButton(
            icon: SvgPicture.asset(
              'assets/svgs/arrow-back.svg',
              width: 19,
              height: 12,
            ),
            onPressed: () => RouteNavigators.pop(context),
          ),
          title: const Text('Comments',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor2))),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: const [
                ProfilePicture(),
                Text('Rooney Brown',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black)),
                Text('On my way to Dubai #luxury 👌😁😁',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black)),
                Text('10h',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textColor4))
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              children: const [
                CommentsTile(),
                CommentsTile(),
                CommentsTile(),
                CommentsTile(),
                CommentsTile(),
                CommentsTile(),
                CommentsTile(),
                CommentsTile(),
                CommentsTile(),
                CommentsTile(),
              ],
            ),
          ),
          const Divider(),
          CustomTextField(
            textCapitalization: TextCapitalization.characters,
            hintText: 'Comment as RooneyBrown...',
            suffixIcon: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.send),
            ),
            prefixIcon: const ProfilePicture(),
          )
        ],
      ),
    );
  }
}

class CommentsTile extends StatelessWidget {
  const CommentsTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
   
    return Row(
      children: [
        const ProfilePicture(),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: const [
                  Text(
                    'Gospel Chapel',
                    style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                        fontFamily: 'Poppins'),
                  ),
                  ReadMoreText(
                    "                                   Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                    trimMode: TrimMode.Line,
                    style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black,
                        fontFamily: 'Poppins'),
                  ),
                ],
              ),
              // RichText(
              //   text: const TextSpan(
              //       text: 'Gospel Chapel',
              //       style: TextStyle(
              //           fontSize: 12,
              //           fontWeight: FontWeight.w500,
              //           color: AppColors.black,
              //           fontFamily: 'Poppins'),
              //       children: [
              //         TextSpan(
              //           text:
              //               '   Yo bro! here we go again jsdjfnsjfjskdfnkjsdfjksdfskjdjck nsdjkfnsdjknjdsknfjksdnjksndjkfnsjdknfjkdsnfjkdsjksdndsjkndsjknfdsjkdsjksfjskdfsdjk.',
              //           style: TextStyle(
              //               fontSize: 11,
              //               fontWeight: FontWeight.w400,
              //               color: AppColors.black,
              //               fontFamily: 'Poppins'),
              //         )
              //       ]),
              // ),
              const SizedBox(height: 1),
              const Text(
                '22h ago     12 Likes',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: AppColors.greyShade1,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '... view 12 replies',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: AppColors.greyShade1,
                ),
              ),
            ],
          ),
        )
      ],
    ).paddingSymmetric(h: 8, v: 8);
  }
}


