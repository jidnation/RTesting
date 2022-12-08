import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:reach_me/core/components/rm_spinner.dart';
import 'package:reach_me/core/components/snackbar.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/features/dictionary/data/models/gethistory_model.dart';
import 'package:reach_me/features/dictionary/dictionary_bloc/bloc/dictionary_event.dart';
import 'package:reach_me/features/dictionary/presentation/widgets/search_history_container.dart';

import '../../dictionary_bloc/bloc/dictionary_bloc.dart';
import '../../dictionary_bloc/bloc/dictionary_state.dart';

class SearchHistory extends StatefulWidget {
  const SearchHistory({Key? key}) : super(key: key);

  @override
  State<SearchHistory> createState() => _SearchHistoryState();
}

class _SearchHistoryState extends State<SearchHistory> {
  final _getHistory = ValueNotifier<List<GetSearchedWordsHistory>>([]);
  @override
  void initState() {
    super.initState();
    globals.dictionaryBloc!
        .add(GetSearchHistoryEvent(pageLimit: 1000, pageNumber: 1));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DictionaryBloc, DictionaryState>(
      bloc: globals.dictionaryBloc,
      listener: (context, state) {
        if (state is SearchedHistorySuccess) {
          _getHistory.value = state.data!;
        }
        if (state is SearchHistoryErrorState) {
          Snackbars.error(context, message: state.error);
        }
        if (state is DeletingWordError) {
          Snackbars.error(context, message: 'Error Deleting content');
        }

        if (state is DeletingWordSuccess) {
          Snackbars.success(context, message: "Deleted Successfully");
        }
        if (state is DeleteAllHistorySuccess) {
          Snackbars.success(context,
              message: "All History Cleared Successfully");
        }

        if (state is DeleteAllHistoryError) {
          Snackbars.error(context, message: 'Error Clearing history');
        }
      },
      builder: (context, state) {
        bool _isLoading = state is LoadingSearchedHistory;
        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: AppBar(
            actions: [
              TextButton(
                onPressed: () {
                  globals.dictionaryBloc?.add(
                    DeleteAllHistoryEvent(),
                  );
                  setState(() {
                    globals.dictionaryBloc!.add(
                      GetSearchHistoryEvent(pageLimit: 300, pageNumber: 1),
                    );
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(
                    8.0,
                   ),
                  child: Text(
                    _getHistory.value.isEmpty ? "" : 'Clear History',
                    style: TextStyle(
                      fontSize: getScreenHeight(13),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      color: Colors.red,
                    ),
                  ),
                ),
              )
            ],
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
          body: RefreshIndicator(
            onRefresh: onRefresh,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _isLoading
                  ? const Center(child: CircularLoader())
                  : _getHistory.value.isEmpty
                      ? const Center(child: Text('No search history'))
                      : ListView.builder(
                          itemCount: _getHistory.value.length,
                          itemBuilder: (BuildContext context, int index) {
                            return SearchHistoryContent(
                              contentDate: dateFormatter(
                                  _getHistory.value[index].createdAt!),
                              contentText: _getHistory.value[index].word!,
                              onPressed: () {
                                globals.dictionaryBloc?.add(DeleteWordEvent(
                                    historyId:
                                        _getHistory.value[index].historyId!));

                                setState(() {
                                  globals.dictionaryBloc!.add(
                                      GetSearchHistoryEvent(
                                          pageLimit: 1000, pageNumber: 1));
                                });
                              },
                            );
                          },
                        ),
            ),
          ),
        );
      },
    );
  }

  Future<void> onRefresh() async {
    globals.dictionaryBloc!
        .add(GetSearchHistoryEvent(pageLimit: 1000, pageNumber: 1));
  }

  String dateFormatter(String dateToFormat) {
    var date = DateTime.fromMillisecondsSinceEpoch(int.parse(dateToFormat));
    var dateParse = DateFormat.yMMMMd('en_US').format(date);
    return dateParse;
  }
}
