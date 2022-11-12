import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/features/dictionary/presentation/widgets/custom_textfield.dart';
import 'package:reach_me/features/dictionary/presentation/widgets/search_custom_button.dart';

class RemoveSearchWord extends StatefulHookWidget {
  const RemoveSearchWord({Key? key}) : super(key: key);

  @override
  State<RemoveSearchWord> createState() => _RemoveSearchWordState();
}

class _RemoveSearchWordState extends State<RemoveSearchWord> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SafeArea(
          child: Container(
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
                      onChanged: (value) {
                        return null;
                      },
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: Stack(
                    children: [
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: CustomButton(
                            onPressed: () {},
                            buttonText: 'Remove From Dictionary',
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
