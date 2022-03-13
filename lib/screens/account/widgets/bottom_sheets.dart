import 'package:flutter/material.dart';
import 'package:reach_me/components/bottom_sheet_list_tile.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/screens/account/views/abbreviation.dart';
import 'package:reach_me/screens/account/views/dictionary.dart';
import 'package:reach_me/screens/account/views/qr_code.dart';
import 'package:reach_me/screens/account/views/saved_post.dart';
import 'package:reach_me/screens/account/views/starred_profile.dart';
import 'package:reach_me/utils/constants.dart';
import 'package:reach_me/utils/extensions.dart';

Future showKebabBottomSheet(BuildContext context) {
  return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
            decoration: const BoxDecoration(
              color: AppColors.greyShade7,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: ListView(shrinkWrap: true, children: [
              Center(
                child: Container(
                    height: 4,
                    width: 58,
                    decoration: BoxDecoration(
                        color: AppColors.greyShade4,
                        borderRadius: BorderRadius.circular(40))),
              ).paddingOnly(t: 23),
              const SizedBox(height: 20),
              KebabBottomTextButton(
                  label: 'Dictionary',
                  onPressed: () => NavigationService.navigateTo(Dictionary.id)),
              KebabBottomTextButton(
                  label: 'Abbreviation',
                  onPressed: () =>
                      NavigationService.navigateTo(Abbreviation.id)),
              KebabBottomTextButton(
                  label: 'Starred Profile',
                  onPressed: () {
                    NavigationService.navigateTo(StarredProfileScreen.id);
                  }),
              KebabBottomTextButton(
                  label: 'QR Code',
                  onPressed: () {
                    NavigationService.navigateTo(QRCodeScreen.id);
                  }),
              KebabBottomTextButton(
                  label: 'Saved Post',
                  onPressed: () {
                    NavigationService.navigateTo(SavedPostScreen.id);
                  }),
              KebabBottomTextButton(label: 'Share Profile', onPressed: () {}),
              KebabBottomTextButton(label: 'More', onPressed: () {}),
              const SizedBox(height: 20),
            ]));
      });
}

Future showKebabCommentBottomSheet(BuildContext context) {
  return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
            decoration: const BoxDecoration(
              color: AppColors.greyShade7,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: ListView(shrinkWrap: true, children: [
              Center(
                child: Container(
                    height: 4,
                    width: 58,
                    decoration: BoxDecoration(
                        color: AppColors.greyShade4,
                        borderRadius: BorderRadius.circular(40))),
              ).paddingOnly(t: 23),
              const SizedBox(height: 20),
              KebabBottomTextButton(label: 'Delete comment', onPressed: () {}),
              KebabBottomTextButton(label: 'Share', onPressed: () {}),
              const SizedBox(height: 20),
            ]));
      });
}
