import 'package:flutter/material.dart';

class SearchHistoryContent extends StatelessWidget {
  const SearchHistoryContent(
      {Key? key,
      required this.contentText,
      required this.contentDate,
      required this.onPressed})
      : super(key: key);
  final String contentText;
  final String contentDate;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.5),
        color: Colors.white,
      ),
      height: 121,
      width: 410,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 30.0,
          right: 25,
          top: 36,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(contentText),
                Text(contentDate),
              ],
            ),
            IconButton(onPressed: onPressed, icon: const Icon(Icons.close)),
          ],
        ),
      ),
    );
  }
}
