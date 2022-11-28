import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/components/snackbar.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/validator.dart';
import 'package:reach_me/features/dictionary/dictionary_bloc/bloc/dictionary_bloc.dart';
import 'package:reach_me/features/dictionary/dictionary_bloc/bloc/dictionary_event.dart';
import 'package:reach_me/features/dictionary/dictionary_bloc/bloc/dictionary_state.dart';
import 'package:reach_me/features/dictionary/presentation/widgets/add_to_glossary_textbox.dart';
import 'package:reach_me/features/dictionary/presentation/widgets/search_custom_button.dart';

import '../../../../core/utils/dimensions.dart';

class AddToGlossary extends StatefulWidget {
  const AddToGlossary({Key? key}) : super(key: key);

  @override
  State<AddToGlossary> createState() => _AddToGlossaryState();
}

class _AddToGlossaryState extends State<AddToGlossary> {
  TextEditingController abbrController = TextEditingController();
  TextEditingController wordController = TextEditingController();
  TextEditingController languageController = TextEditingController();
  TextEditingController meaningController = TextEditingController();
  final _formValidationKey = GlobalKey<FormState>();
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
          'Add to Dictionary',
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
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: BlocConsumer<DictionaryBloc, DictionaryState>(
            bloc: globals.dictionaryBloc,
            listener: (context, state) {
              if (state is AddedToDBState) {
                Snackbars.success(context, message: 'Added to dictionary');
                RouteNavigators.pop(context);
              } else if (state is ErrorState) {
                Snackbars.error(context, message: state.error);
              }
            },
            builder: (context, state) {
              bool _isLoading = state is AddingToDBState;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Padding(
                  padding: const EdgeInsets.only(top: 68.0),
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
                          validator: (value) =>
                              Validator.validateText(value ?? ''),
                        ),
                        AddToGlossaryTextBox(
                          controller: wordController,
                          hintText: 'word',
                          validator: (value) =>
                              Validator.validateText(value ?? ''),
                        ),
                        AddToGlossaryTextBox(
                          controller: languageController,
                          hintText: 'Language',
                          validator: (value) =>
                              Validator.validateText(value ?? ''),
                        ),
                        AddToGlossaryTextBox(
                          controller: meaningController,
                          hintText: 'Meaning',
                          maxLines: 5,
                          validator: (value) =>
                              Validator.validateText(value ?? ''),
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
                                    globals.dictionaryBloc!
                                        .add(SaveDataToGlossaryEvent(
                                      abbr: abbrController.text,
                                      language: languageController.text,
                                      meaning: meaningController.text,
                                      word: wordController.text,
                                    ));
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
              );
            },
          ),
        ),
      ),
    );
  }
}
