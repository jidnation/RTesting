import 'package:flutter/material.dart';
import 'package:reach_me/core/components/bottom_sheet_list_tile.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/features/account/presentation/views/abbreviation.dart';
import 'package:reach_me/features/account/presentation/views/dictionary.dart';
import 'package:reach_me/features/account/presentation/views/qr_code.dart';
import 'package:reach_me/features/account/presentation/views/saved_post.dart';
import 'package:reach_me/features/account/presentation/views/starred_profile.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/extensions.dart';

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
                  onPressed: () =>
                      RouteNavigators.route(context, const Dictionary())),
              KebabBottomTextButton(
                  label: 'Abbreviation',
                  onPressed: () =>
                      RouteNavigators.route(context, const Abbreviation())),
              KebabBottomTextButton(
                  label: 'Starred Profile',
                  onPressed: () {
                    RouteNavigators.route(
                        context, const StarredProfileScreen());
                  }),
              KebabBottomTextButton(
                  label: 'QR Code',
                  onPressed: () {
                    RouteNavigators.route(context, const QRCodeScreen());
                  }),
              KebabBottomTextButton(
                  label: 'Saved Post',
                  onPressed: () {
                    RouteNavigators.route(context, const SavedPostScreen());
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
