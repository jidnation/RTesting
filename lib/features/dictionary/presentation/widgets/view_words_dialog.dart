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
        .add(GetRecentAddedWordsEvent(pageLimit: 100, pageNumber: 1));
  }

  void filterWords(String query) {
    List<GetRecentlyAddedWord> filteredList = <GetRecentlyAddedWord>[];
    filteredList.addAll(recentWords.value);
    if (query.isNotEmpty) {
      List<GetRecentlyAddedWord> dummyData = <GetRecentlyAddedWord>[];
      for (var item in filteredList) {
        if (item.abbr!.toLowerCase().contains(query)) {
          dummyData.add(item);
        }
      }
      setState(() {
        items.value.clear();
        items.value.addAll(dummyData);
      });
      return;
    } else {
      setState(() {
        items.value.clear();
        items.value.addAll(recentWords.value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Word Library'),
      content: SizedBox(
        width: double.minPositive,
        child: BlocConsumer<DictionaryBloc, DictionaryState>(
          bloc: globals.dictionaryBloc,
          listener: (context, state) {
            if (state is GetRecentlyAddedWordsSuccess) {
              recentWords.value = state.data!;
              items.value = state.data!;
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Builder(builder: (context) {
                              final word = items.value.firstWhere(
                                (element) => element.abbr == widget.abbr,
                                orElse: () => GetRecentlyAddedWord(),
                              );
                              if (word.abbr == null) {
                                return const Text(
                                  'Word not found',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.red),
                                );
                              }

                              return ListTile(
                                title: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(color: Colors.black),
                                    children: [
                                      TextSpan(
                                          text: '${word.abbr}: ',
                                          style: const TextStyle(
                                              color: Colors.blue)),
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
                            }),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: 50,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'Search words',
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
                                onChanged: ((value) => filterWords(
                                      value,
                                    )),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: items.value.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return ListTile(
                                      title: RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                              color: Colors.black),
                                          children: [
                                            TextSpan(
                                                text:
                                                    '${items.value[index].abbr}: ',
                                                style: const TextStyle(
                                                    color: Colors.blue)),
                                            TextSpan(
                                                text:
                                                    '${items.value[index].word}',
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                      subtitle: Text(
                                        items.value[index].meaning.toString(),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    );
                                  },
                                ),
                              ),
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
