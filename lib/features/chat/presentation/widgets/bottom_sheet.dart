import 'package:flutter/material.dart';
import 'package:reach_me/core/components/bottom_sheet_list_tile.dart';
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
              KebabBottomTextButton(label: 'Mute message', onPressed: () {}),
              KebabBottomTextButton(label: 'Clear chat', onPressed: () {}),
              KebabBottomTextButton(label: 'Search', onPressed: () {}),
              KebabBottomTextButton(label: 'Report', onPressed: () {}),
              KebabBottomTextButton(label: 'Restrict', onPressed: () {}),
              KebabBottomTextButton(label: 'Block', onPressed: () {}),
              const SizedBox(height: 20),
            ]));
      });
}