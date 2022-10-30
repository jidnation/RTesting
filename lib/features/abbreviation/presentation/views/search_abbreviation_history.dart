import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/features/abbreviation/presentation/widgets/search_abbreviation_container.dart';
import 'package:reach_me/features/dictionary/presentation/widgets/search_history_container.dart';

class SearchAbbreviationHistory extends StatefulWidget {
  const SearchAbbreviationHistory({Key? key}) : super(key: key);

  @override
  State<SearchAbbreviationHistory> createState() => _SearchAbbreviationHistoryState();
}

class _SearchAbbreviationHistoryState extends State<SearchAbbreviationHistory> {
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
          'Search History',
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
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView.builder(
          itemCount: 3,
          itemBuilder: (BuildContext context, int index) {
            return SearchAbbreviationContent(
              contentDate: '21-02-12',
              contentText: 'Hand',
              onPressed: () {},
            );
          },
        ),
      ),
    );
  }
}
