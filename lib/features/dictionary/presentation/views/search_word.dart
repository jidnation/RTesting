import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reach_me/core/components/rm_spinner.dart';
import 'package:reach_me/core/components/snackbar.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/features/dictionary/data/models/get_word_model.dart';
import 'package:reach_me/features/dictionary/dictionary_bloc/bloc/dictionary_bloc.dart';
import 'package:reach_me/features/dictionary/dictionary_bloc/bloc/dictionary_event.dart';
import 'package:reach_me/features/dictionary/dictionary_bloc/bloc/dictionary_state.dart';
import 'package:reach_me/features/dictionary/presentation/views/add_to_glossary.dart';
import 'package:reach_me/features/dictionary/presentation/widgets/custom_textfield.dart';
import 'package:reach_me/features/dictionary/presentation/widgets/search_custom_button.dart';

class SearchWord extends StatefulHookWidget {
  const SearchWord({Key? key}) : super(key: key);

  @override
  State<SearchWord> createState() => _SearchWordState();
}

class _SearchWordState extends State<SearchWord> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _showWords = useState(GetWordClass());
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<DictionaryBloc, DictionaryState>(
            bloc: globals.dictionaryBloc,
            listener: (context, state) {
              // if (state is LoadingSearchedWords) {
              //   Snackbars.success(context, message: 'Searching');
              // }
              if (state is DisplaySearchedWordSuccess) {
                _showWords.value = state.wordData;
              }
              if (state is GetSearchedWordError) {
                Snackbars.error(context, message: 'Word not found');
              }
            },
            builder: (context, state) {
              bool _isLoading = state is LoadingSearchedWords;
              bool _isSuccess = state is DisplaySearchedWordSuccess;
              bool _isFailure = state is GetSearchedWordError;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        InkWell(
                          child: const Icon(Icons.arrow_back),
                          onTap: () => RouteNavigators.pop(context),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        SearchCustomTextField(
                          controller: controller,
                          onChanged: (value) {
                            return null;
                          },
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: ConstrainedBox(
                          constraints: const BoxConstraints(
                              maxWidth: 419, maxHeight: 190),
                          child: _isLoading
                              ? const CircularLoader()
                              : _isSuccess
                                  ? Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(24.5),
                                        color: Colors.white,
                                      ),
                                      height: 121,
                                      width: 410,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 18.0,
                                          right: 25,
                                          top: 16,
                                        ),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                  children: [
                                                    TextSpan(
                                                        text:
                                                            '${_showWords.value.abbr} : ',
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.blue)),
                                                    TextSpan(
                                                        text:
                                                            '${_showWords.value.word} ; '),
                                                    TextSpan(
                                                        text: _showWords
                                                            .value.meaning,
                                                        style:
                                                            const TextStyle())
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : _isFailure
                                      ? TextButton(
                                          child: const Text(
                                            'Add Word to Dictionary',
                                            style: TextStyle(
                                                color: Color(0xff001824)),
                                          ),
                                          onPressed: () =>
                                              RouteNavigators.route(context,
                                                  const AddToGlossary()),
                                        )
                                      : const Text('Search Word')),
                    ),
                    const Spacer(),
                    CustomButton(
                      buttonText: 'Search Dictionary',
                      onPressed: () {
                        globals.dictionaryBloc!
                            .add(GetWordEvent(controller.text));
                      },
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
