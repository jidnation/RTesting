import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/features/dictionary/presentation/views/add_to_glossary.dart';
import 'package:reach_me/features/dictionary/presentation/views/recently_added.dart';
import 'package:reach_me/features/dictionary/presentation/views/search_history.dart';
import 'package:reach_me/features/dictionary/presentation/views/search_word.dart';
import 'package:reach_me/features/dictionary/presentation/views/word_library.dart';
import 'package:reach_me/features/dictionary/presentation/widgets/word_container.dart';

class DictionaryView extends StatefulHookWidget {
  const DictionaryView({Key? key, this.scaffoldKey}) : super(key: key);
  final GlobalKey<ScaffoldState>? scaffoldKey;
  @override
  State<DictionaryView> createState() => _DictionaryViewState();
}

class _DictionaryViewState extends State<DictionaryView> {
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
          'Dictionary',
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
            contentText: 'Add to Dictionary',
            onPressed: () =>
                RouteNavigators.route(context, const AddToGlossary()),
          ),
          DictionaryTab(
            contentText: 'Search Word',
            onPressed: () => RouteNavigators.route(context, const SearchWord()),
          ),
          DictionaryTab(
            contentText: 'Recently Added',
            onPressed: () =>
                RouteNavigators.route(context, const RecentlyAdded()),
          ),
          DictionaryTab(
            contentText: 'Search History',
            onPressed: () =>
                RouteNavigators.route(context, const SearchHistory()),
          ),
          // DictionaryTab(
          //   contentText: 'World Library',
          //   onPressed: () =>
          //       RouteNavigators.route(context, const WordLibrary()),
          // ),
        ],
      ),
    );
  }
}
