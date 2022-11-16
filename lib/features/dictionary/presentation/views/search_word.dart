import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reach_me/core/components/snackbar.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/features/dictionary/data/models/recently_added_model.dart';
import 'package:reach_me/features/dictionary/dictionary_bloc/bloc/dictionary_bloc.dart';
import 'package:reach_me/features/dictionary/dictionary_bloc/bloc/dictionary_event.dart';
import 'package:reach_me/features/dictionary/dictionary_bloc/bloc/dictionary_state.dart';
import 'package:reach_me/features/dictionary/presentation/views/remove_word.dart';
import 'package:reach_me/features/dictionary/presentation/widgets/content_container.dart';
import 'package:reach_me/features/dictionary/presentation/widgets/custom_textfield.dart';
import 'package:reach_me/features/dictionary/presentation/widgets/search_custom_button.dart';

class SearchWord extends StatefulHookWidget {
  const SearchWord({Key? key}) : super(key: key);

  @override
  State<SearchWord> createState() => _SearchWordState();
}

class _SearchWordState extends State<SearchWord> {
  TextEditingController controller = TextEditingController();
  final _showWords = useState(GetRecentlyAddedWord());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SafeArea(
          child: BlocConsumer<DictionaryBloc, DictionaryState>(
              bloc: globals.dictionaryBloc,
              listener: (context, state) {
                if (state is LoadingSearchedWords) {
                  Snackbars.success(context, message: 'Searching');
                }
                if (state is DisplaySearchedWordSuccess) {
                  _showWords.value = state.wordData as GetRecentlyAddedWord;
                }
                if (state is GetSearchedWordError) {
                  Snackbars.error(context, message: state.error);
                }
              },
              builder: (context, state) {
                bool _isLoading = state is LoadingSearchedWords;
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
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24.5),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                  color: Colors.blue)),
                                          TextSpan(
                                              text:
                                                  '${_showWords.value.word} ; '),
                                          TextSpan(
                                              text: _showWords.value.meaning,
                                              style: const TextStyle())
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    // Text(
                                    //   dateParse,
                                    //   style: const TextStyle(
                                    //       fontFamily: 'poppins', fontWeight: FontWeight.w600),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.9,
                        child: Stack(
                          children: [
                            Align(
                                alignment: Alignment.bottomCenter,
                                child: CustomButton(
                                  onPressed: () {
                                    globals.dictionaryBloc!
                                        .add(GetWordEvent(controller.text));
                                  },
                                  // onPressed: () => RouteNavigators.route(
                                  //     context, const RemoveSearchWord()),
                                  buttonText: 'Add to Dictionary',
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }
}
