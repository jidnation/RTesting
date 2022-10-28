import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/features/abbreviation/presentation/views/abbreviation_library.dart';
import 'package:reach_me/features/abbreviation/presentation/views/recently_added_abbreviation.dart';
import 'package:reach_me/features/abbreviation/presentation/views/search_abbreviation.dart';
import 'package:reach_me/features/abbreviation/presentation/views/search_abbreviation_history.dart';
import 'package:reach_me/features/dictionary/presentation/widgets/word_container.dart';

class AbbreviationView extends StatefulHookWidget {
  const AbbreviationView({Key? key, this.scaffoldKey}) : super(key: key);
  final GlobalKey<ScaffoldState>? scaffoldKey;
  @override
  State<AbbreviationView> createState() => _AbbreviationViewState();
}

class _AbbreviationViewState extends State<AbbreviationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Abbreviation',
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
      body: Column(
        children: [
          DictionaryTab(
            contentText: 'Search Abbreviation',
            onPressed: () =>
                RouteNavigators.route(context, const SearchAbbreviation()),
          ),
          DictionaryTab(
            contentText: 'Recently Added Abbr',
            onPressed: () => RouteNavigators.route(
                context, const RecentlyAddedAbbreviation()),
          ),
          DictionaryTab(
            contentText: 'Search History',
            onPressed: () => RouteNavigators.route(
                context, const SearchAbbreviationHistory()),
          ),
          DictionaryTab(
            contentText: 'Abbs Library',
            onPressed: () =>
                RouteNavigators.route(context, const AbbreviationLibrary()),
          ),
        ],
      ),
    );
  }
}
