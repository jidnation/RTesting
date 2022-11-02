import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/features/dictionary/presentation/widgets/add_to_glossary_textbox.dart';
import 'package:reach_me/features/dictionary/presentation/widgets/search_custom_button.dart';

import '../../../../core/utils/dimensions.dart';

class AddToGlossary extends StatelessWidget {
  const AddToGlossary({Key? key}) : super(key: key);

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
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Padding(
              padding: const EdgeInsets.only(top: 68.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const AddToGlossaryTextBox(
                    height: 80,
                    hintText: 'Abbreviaton',
                  ),
                  const AddToGlossaryTextBox(
                    hintText: 'word',
                  ),
                  const AddToGlossaryTextBox(
                    hintText: 'Language',
                  ),
                  const AddToGlossaryTextBox(
                    hintText: 'Meaning',
                    maxLines: 5,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  CustomButton(buttonText: 'Save', onPressed: () {})
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
