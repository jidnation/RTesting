import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AbbreviationContentContainer extends StatefulHookWidget {
  const AbbreviationContentContainer(
      {required this.wordText,
      required this.wordMeaning,
      required this.fullWord,
      Key? key})
      : super(key: key);
  final String wordText;
  final String wordMeaning;
  final String fullWord;

  @override
  State<AbbreviationContentContainer> createState() => _AbbreviationContentContainerState();
}

class _AbbreviationContentContainerState extends State<AbbreviationContentContainer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 419, maxHeight: 150),
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
              top: 36,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                          text: '${widget.wordText} : ',
                          style: const TextStyle(color: Colors.blue)),
                      TextSpan(text: '${widget.fullWord} ; '),
                      TextSpan(
                          text: widget.wordMeaning, style: const TextStyle())
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  '2021-06-13',
                  style: TextStyle(
                      fontFamily: 'poppins', fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
