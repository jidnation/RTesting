import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reach_me/core/components/snackbar.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/validator.dart';
import 'package:reach_me/features/dictionary/dictionary_bloc/bloc/dictionary_bloc.dart';
import 'package:reach_me/features/dictionary/dictionary_bloc/bloc/dictionary_event.dart';
import 'package:reach_me/features/dictionary/dictionary_bloc/bloc/dictionary_state.dart';
import 'package:reach_me/features/dictionary/presentation/widgets/add_to_glossary_textbox.dart';
import 'package:reach_me/features/dictionary/presentation/widgets/search_custom_button.dart';

class EditGlossaryDialog extends StatefulWidget {
  const EditGlossaryDialog(
      {Key? key,
      required this.wordId,
      required this.word,
      required this.language,
      required this.meaning,
      required this.abbr})
      : super(key: key);
  final String wordId;
  final String abbr;
  final String word;
  final String language;
  final String meaning;
  @override
  State<EditGlossaryDialog> createState() => _EditGlossaryDialogState();
}

class _EditGlossaryDialogState extends State<EditGlossaryDialog> {
  TextEditingController abbrController = TextEditingController();
  TextEditingController wordController = TextEditingController();
  TextEditingController languageController = TextEditingController();
  TextEditingController meaningController = TextEditingController();
  final _formValidationKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    abbrController.text = widget.abbr;
    wordController.text = widget.word;
    languageController.text = widget.language;
    meaningController.text = widget.meaning;
  }

  @override
  void dispose() {
    abbrController.dispose();
    wordController.dispose();
    languageController.dispose();
    meaningController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Word'),
      content: BlocConsumer<DictionaryBloc, DictionaryState>(
        bloc: globals.dictionaryBloc,
        listener: (context, state) {
          if (state is EditGlossarySuccessState) {
            Snackbars.success(context, message: 'Word Edited Succesfully');
            RouteNavigators.pop(context);
          } else if (state is EditGlossaryErrorState) {
            Snackbars.error(context, message: state.error);
          }
        },
        builder: (context, state) {
          bool _isLoading = state is EditGlossaryLoadingState;
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Form(
                  key: _formValidationKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AddToGlossaryTextBox(
                        controller: abbrController,
                        height: 80,
                        hintText: 'Abbreviaton',
                        validator: (value) => Validator.emptyField(value ?? ''),
                      ),
                      AddToGlossaryTextBox(
                        controller: wordController,
                        hintText: 'word',
                        validator: (value) => Validator.emptyField(value ?? ''),
                      ),
                      AddToGlossaryTextBox(
                        controller: languageController,
                        hintText: 'Language',
                        validator: (value) => Validator.emptyField(value ?? ''),
                      ),
                      AddToGlossaryTextBox(
                        controller: meaningController,
                        hintText: 'Meaning',
                        maxLines: 5,
                        validator: (value) => Validator.emptyField(value ?? ''),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      CustomButton(
                        isLoading: _isLoading,
                        buttonText: 'Save',
                        onPressed: !_isLoading
                            ? () {
                                if (_formValidationKey.currentState!
                                    .validate()) {
                                  globals.dictionaryBloc!.add(
                                    EditGlossaryEvent(
                                      abbr: abbrController.text,
                                      language: languageController.text,
                                      meaning: meaningController.text,
                                      word: wordController.text,
                                      wordId: widget.wordId,
                                    ),
                                  );
                                } else {
                                  return;
                                }
                              }
                            : () {},
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
