import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reach_me/core/components/rm_spinner.dart';
import 'package:reach_me/core/components/snackbar.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/features/dictionary/data/models/recently_added_model.dart';
import 'package:reach_me/features/dictionary/dictionary_bloc/bloc/dictionary_event.dart';
import 'package:reach_me/features/dictionary/dictionary_bloc/bloc/dictionary_state.dart';

import '../../dictionary_bloc/bloc/dictionary_bloc.dart';

class DictionaryDialog extends StatefulHookWidget {
  const DictionaryDialog({Key? key}) : super(key: key);

  @override
  State<DictionaryDialog> createState() => _DictionaryDialogState();
}

class _DictionaryDialogState extends State<DictionaryDialog> {
  @override
  Widget build(BuildContext context) {
    final recentWords = ValueNotifier<List<GetRecentlyAddedWord>>([]);

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
              recentWords.value = state.data!;
            }
            if (state is DisplayRecentlyAddedWordsError) {
              Snackbars.error(context, message: state.error);
            }
          },
          builder: (context, state) {
            bool _isLoading = state is LoadingRecentlyAddedWords;
            return _isLoading
                ? const CircularLoader()
                : recentWords.value.isEmpty
                    ? const Center(child: Text('No Recent Words'))
                    : SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: 50,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'Search',
                                  prefixIcon: const Icon(Icons.search),
                                  hintStyle:
                                      const TextStyle(color: Color(0xffCECECE)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onChanged: searchWord,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: recentWords.value.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  title: RichText(
                                    text: TextSpan(
                                      style:
                                          const TextStyle(color: Colors.black),
                                      children: [
                                        TextSpan(
                                            text:
                                                '${recentWords.value[index].abbr} : ',
                                            style: const TextStyle(
                                                color: Colors.blue)),
                                        TextSpan(
                                            text:
                                                '${recentWords.value[index].word}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                  subtitle: Text(
                                    recentWords.value[index].meaning.toString(),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
          },
        ),
      ),
    );

    
  }

  
}
void searchWord(String? word) {
    // final suggestions = recentWords .where((recentWords.value) {
    //   final text = recentWords.value.toLowerCase();
    //   final textInput = word.toLowerCase();
    //   return suggestions.contains(textInput);
    // }).toList();
   
  }