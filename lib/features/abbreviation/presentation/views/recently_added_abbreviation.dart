import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/features/dictionary/presentation/widgets/content_container.dart';

class RecentlyAddedAbbreviation extends StatefulHookWidget {
  const RecentlyAddedAbbreviation({Key? key}) : super(key: key);

  @override
  State<RecentlyAddedAbbreviation> createState() =>
      _RecentlyAddedAbbreviationState();
}

class _RecentlyAddedAbbreviationState extends State<RecentlyAddedAbbreviation> {
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        leading: IconButton(
            icon: SvgPicture.asset(
              'assets/svgs/back.svg',
              width: 19,
              height: 12,
              color: AppColors.black,
            ),
            onPressed: () => RouteNavigators.pop(context)),
        backgroundColor: Colors.grey.shade50,
        centerTitle: false,
        title: Text(
          'Recently Added Abbr',
          style: TextStyle(
            fontSize: getScreenHeight(16),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        elevation: 0,
        toolbarHeight: 50,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15.0,),
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return const ContentContainer(
              fullWord: 'Character',
              wordMeaning:
                  'the mental and moralthe mental and moral the mental and moral the mental and moral qualities distinctive to an individual.',
              wordText: 'Char',
            );
          },
        ),
      ),
    );
  }
}
