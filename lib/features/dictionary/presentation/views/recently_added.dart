import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/components/rm_spinner.dart';
import 'package:reach_me/core/components/snackbar.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/features/dictionary/data/models/recently_added_model.dart';
import 'package:reach_me/features/dictionary/dictionary_bloc/bloc/dictionary_bloc.dart';
import 'package:reach_me/features/dictionary/dictionary_bloc/bloc/dictionary_event.dart';
import 'package:reach_me/features/dictionary/dictionary_bloc/bloc/dictionary_state.dart';
import 'package:reach_me/features/dictionary/presentation/widgets/edit_glossary_dialog.dart';
import 'package:reach_me/features/dictionary/presentation/widgets/content_container.dart';

class RecentlyAdded extends StatefulWidget {
  const RecentlyAdded({Key? key}) : super(key: key);

  @override
  State<RecentlyAdded> createState() => _RecentlyAddedState();
}

class _RecentlyAddedState extends State<RecentlyAdded> {
  final _recentWords = ValueNotifier<List<GetRecentlyAddedWord>>([]);
  @override
  void initState() {
    super.initState();
    globals.dictionaryBloc!
        .add(GetRecentAddedWordsEvent(pageLimit: 1000, pageNumber: 1));
  }

  Future<void> onRefresh() async {
    globals.dictionaryBloc!
        .add(GetRecentAddedWordsEvent(pageLimit: 1000, pageNumber: 1));
  }

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
          'Recently Added',
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
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: BlocConsumer<DictionaryBloc, DictionaryState>(
          bloc: globals.dictionaryBloc,
          listener: (context, state) {
            if (state is GetRecentlyAddedWordsSuccess) {
              _recentWords.value = state.data!;
            }
            if (state is DisplayRecentlyAddedWordsError) {
              Snackbars.error(context, message: state.error);
            }
            if (state is DeleteUserWordFailure) {
              Snackbars.error(context, message: 'Error deleting content');
            }
            if (state is DeleteUserWordSuccess) {
              Snackbars.success(context, message: 'Word Deleted Succesfully');
            }
          },
          builder: (context, state) {
            bool _isLoading = state is LoadingRecentlyAddedWords;

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 15.0),
              child: _isLoading
                  ? const Center(child: CircularLoader())
                  : _recentWords.value.isEmpty
                      ? const Center(child: Text('No Recent Words'))
                      : ListView.builder(
                          itemCount: _recentWords.value.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ContentContainer(
                              onDelete: () {
                                globals.dictionaryBloc?.add(DeleteUserWordEvent(
                                    wordId: _recentWords.value[index].wordId!));

                                setState(() {
                                  globals.dictionaryBloc!.add(
                                      GetRecentAddedWordsEvent(
                                          pageLimit: 1000, pageNumber: 1));
                                });
                              },
                              onEdit: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return EditGlossaryDialog(
                                      word: _recentWords.value[index].word!,
                                      abbr: _recentWords.value[index].abbr!,
                                      language: _recentWords.value[index].language!,
                                      meaning: _recentWords.value[index].meaning!,
                                      wordId: _recentWords.value[index].wordId!,
                                    );
                                  },
                                );
                              },
                              showButtons: true,
                              getRecentlyAddedWord: _recentWords.value[index],
                            );
                          },
                        ),
            );
          },
        ),
      ),
    );
  }
}
