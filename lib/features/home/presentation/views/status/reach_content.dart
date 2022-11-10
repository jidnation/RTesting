import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../dictionary/data/models/recently_added_model.dart';

class ReachText extends HookWidget {
  const ReachText({required this.getRecentlyAddedWord, Key? key})
      : super(key: key);
  final GetRecentlyAddedWord getRecentlyAddedWord;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: 20.0,
              ),
              Column(
                children: <Widget>[
                  Text('${getRecentlyAddedWord.abbr}'),
                  Text('${getRecentlyAddedWord.word}'),
                ],
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.add),
              )
            ],
          ),
        ],
      ),
    );
  }
}
