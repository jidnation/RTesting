import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:reach_me/core/components/custom_textfield.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/features/account/presentation/widgets/image_placeholder.dart';

class PostReach extends StatefulWidget {
  const PostReach({Key? key}) : super(key: key);

  @override
  State<PostReach> createState() => _PostReachState();
}

class _PostReachState extends State<PostReach> {
  Future<bool> _promptPermissionSetting() async {
    if (Platform.isIOS &&
            await Permission.storage.request().isGranted &&
            await Permission.photos.request().isGranted ||
        Platform.isAndroid && await Permission.storage.request().isGranted) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, size: 17),
                      padding: EdgeInsets.zero,
                      splashColor: Colors.transparent,
                      splashRadius: 20,
                      constraints: const BoxConstraints(),
                      onPressed: () => RouteNavigators.pop(context),
                    ),
                    const SizedBox(width: 20),
                    const Text(
                      'Create a reach',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: SvgPicture.asset('assets/svgs/send.svg'),
                  onPressed: () => RouteNavigators.pop(context),
                ),
              ],
            ).paddingSymmetric(h: 16),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const ImagePlaceholder(width: 33, height: 33),
                    const SizedBox(width: 12),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (globals.loginResponse!.firstName! +
                                  ' ' +
                                  globals.loginResponse!.lastName!)
                              .toTitleCase(),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor2,
                          ),
                        ),
                        const Text(
                          'Abuja, Nigeria',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.greyShade1),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () =>
                          RouteNavigators.route(context, const TagLocation()),
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset('assets/svgs/location.svg'),
                            const Text(
                              '   Location',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textColor2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Text(
                      '10/200',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textColor2,
                      ),
                    ),
                  ],
                ),
              ],
            ).paddingSymmetric(h: 16),
            const SizedBox(height: 20),
            const Divider(color: Color(0xFFEBEBEB), thickness: 0.5),
            const TextField(
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              minLines: 1,
              maxLines: 6,
              maxLength: 200,
              decoration: InputDecoration(
                hintText: "What's on your mind?",
                hintStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.greyShade1,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
            ).paddingSymmetric(h: 16),
            const Spacer(),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.camera_alt,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              color: const Color(0xFFF5F5F5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset('assets/svgs/world.svg'),
                      const SizedBox(width: 9),
                      const Text(
                        'Everyone can reply',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColor2,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        icon: SvgPicture.asset('assets/svgs/emoji.svg'),
                        splashColor: Colors.transparent,
                        splashRadius: 20,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        onPressed: () {},
                        splashColor: Colors.transparent,
                        splashRadius: 20,
                        padding: EdgeInsets.zero,
                        icon: SvgPicture.asset('assets/svgs/gallery.svg'),
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        splashColor: Colors.transparent,
                        splashRadius: 20,
                        icon: SvgPicture.asset('assets/svgs/mic.svg'),
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}

class TagLocation extends StatelessWidget {
  const TagLocation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 17),
                    padding: EdgeInsets.zero,
                    splashColor: Colors.transparent,
                    splashRadius: 20,
                    constraints: const BoxConstraints(),
                    onPressed: () => RouteNavigators.pop(context),
                  ),
                  const Text(
                    'Tag Location',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: Container(
                      width: 36,
                      height: 26,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 17,
                        color: AppColors.white,
                      ),
                    ),
                    onPressed: () => RouteNavigators.pop(context),
                  ),
                ],
              ).paddingSymmetric(h: 16),
              const SizedBox(height: 22),
              const CustomRoundTextField(
                hintText: 'Search Location',
              ).paddingSymmetric(h: 16),
              const SizedBox(height: 15),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(33),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Abuja, Nigeria',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Color(0xFFC4C4C4),
                        ),
                      ),
                    )
                  ],
                ),
              ).paddingSymmetric(h: 16),
              const SizedBox(height: 10),
              ListTile(
                title: const Text(
                  'Michael Okpara University of Agriculture',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textColor2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  'Owerri, Imo State, Nigeria',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textColor2.withOpacity(0.5),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ListTile(
                title: const Text(
                  'Michael Okpara University of Agriculture',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textColor2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  'Owerri, Imo State, Nigeria',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textColor2.withOpacity(0.5),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
