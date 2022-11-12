import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reach_me/core/components/rm_spinner.dart';
import 'package:reach_me/core/components/snackbar.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/features/dictionary/data/models/recently_added_model.dart';
import 'package:reach_me/features/dictionary/dictionary_bloc/bloc/dictionary_event.dart';
import 'package:reach_me/features/dictionary/dictionary_bloc/bloc/dictionary_state.dart';
import 'package:reach_me/features/dictionary/presentation/widgets/custom_textfield.dart';

import '../../dictionary_bloc/bloc/dictionary_bloc.dart';

class DictionaryDialog extends StatefulHookWidget {
  const DictionaryDialog({Key? key}) : super(key: key);

  @override
  State<DictionaryDialog> createState() => _DictionaryDialogState();
}

class _DictionaryDialogState extends State<DictionaryDialog> {
  @override
  Widget build(BuildContext context) {
    final _recentWords = ValueNotifier<List<GetRecentlyAddedWord>>([]);

    useMemoized(() {
      globals.dictionaryBloc!
          .add(GetRecentAddedWordsEvent(pageLimit: 100, pageNumber: 1));
    });
    return AlertDialog(
      title: const Text('Word Library'),
      content: SizedBox(
        width: double.minPositive,
        child: BlocConsumer<DictionaryBloc, DictionaryState>(
          bloc: globals.dictionaryBloc,
          listener: (context, state) {
            if (state is GetRecentlyAddedWordsSuccess) {
              _recentWords.value = state.data!;
            }
            if (state is DisplayRecentlyAddedWordsError) {
              Snackbars.error(context, message: state.error);
            }
          },
          builder: (context, state) {
            bool _isLoading = state is LoadingRecentlyAddedWords;
            return _isLoading
                ? const CircularLoader()
                : _recentWords.value.isEmpty
                    ? const Center(child: Text('No Recent Words'))
                    : Column(
                        children: [
                          SearchCustomTextField(onChanged: (value) {
                            return;
                          }),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: _recentWords.value.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                title: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(color: Colors.black),
                                    children: [
                                      TextSpan(
                                          text:
                                              '${_recentWords.value[index].abbr} : ',
                                          style: const TextStyle(
                                              color: Colors.blue)),
                                      TextSpan(
                                          text:
                                              '${_recentWords.value[index].word}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                subtitle: Text(
                                  _recentWords.value[index].meaning.toString(),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              );
                            },
                          ),
                        ],
                      );
          },
        ),
      ),
    );
  }
}
