import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reach_me/core/components/rm_spinner.dart';
import 'package:reach_me/core/components/snackbar.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/features/dictionary/data/models/recently_added_model.dart';
import 'package:reach_me/features/dictionary/dictionary_bloc/bloc/dictionary_event.dart';
import 'package:reach_me/features/dictionary/dictionary_bloc/bloc/dictionary_state.dart';

import '../../dictionary_bloc/bloc/dictionary_bloc.dart';

class DictionaryDialog extends StatefulWidget {
  const DictionaryDialog(
      {Key? key, required this.abbr, required this.word, required this.meaning})
      : super(key: key);
  final String abbr;
  final String word;
  final String meaning;

  @override
  State<DictionaryDialog> createState() => _DictionaryDialogState();
}

class _DictionaryDialogState extends State<DictionaryDialog> {
  final recentWords = ValueNotifier<List<GetRecentlyAddedWord>>([]);
  var items = ValueNotifier<List<GetRecentlyAddedWord>>([]);

  @override
  void initState() {
    super.initState();
    globals.dictionaryBloc!
        .add(GetLibraryWordsEvent(pageLimit: 1000, pageNumber: 1));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Word Library'),
      content: SizedBox(
        height: 150.0,
        child: BlocConsumer<DictionaryBloc, DictionaryState>(
          bloc: globals.dictionaryBloc,
          listener: (context, state) {
            if (state is LoadingWordsLibrarySuccess) {
              recentWords.value = state.data!;
              items.value = state.data!;
            }
            if (state is LoadingWordsLibraryError) {
              Snackbars.error(context, message: state.error);
            }
          },
          builder: (context, state) {
            bool _isLoading = state is LoadingWordsLibrary;
            return _isLoading
                ? const Center(child: CircularLoader())
                : recentWords.value.isEmpty
                    ? const Center(child: Text('No Recent Words'))
                    : Builder(
                        builder: (context) {
                          final word = items.value.firstWhere(
                            (element) => element.abbr == widget.abbr,
                            orElse: () => GetRecentlyAddedWord(),
                          );
                          if (word.abbr == null) {
                            return const Text(
                              'Word not found',
                              style: TextStyle(fontSize: 14, color: Colors.red),
                            );
                          }
                          return ListTile(
                            title: RichText(
                              text: TextSpan(
                                style: const TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                      text: '${word.abbr}: ',
                                      style:
                                          const TextStyle(color: Colors.blue)),
                                  TextSpan(
                                      text: '${word.word}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            subtitle: Text(
                              word.meaning.toString(),
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        },
                      );
          },
        ),
      ),
    );
  }
}
