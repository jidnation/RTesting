import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reach_me/features/dictionary/data/models/recently_added_model.dart';

class ContentContainer extends HookWidget {
  const ContentContainer({required this.getRecentlyAddedWord, Key? key})
      : super(key: key);
  final GetRecentlyAddedWord getRecentlyAddedWord;

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
                          text: '${getRecentlyAddedWord.abbr} : ',
                          style: const TextStyle(color: Colors.blue)),
                      TextSpan(text: '${getRecentlyAddedWord.word} ; '),
                      TextSpan(
                          text: getRecentlyAddedWord.meaning,
                          style: const TextStyle())
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  '${getRecentlyAddedWord.createdAt}',
                  style: const TextStyle(
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