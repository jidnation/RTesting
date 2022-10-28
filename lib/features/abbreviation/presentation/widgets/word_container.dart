import 'package:flutter/material.dart';

class AbbreviationTab extends StatelessWidget {
  const AbbreviationTab({Key? key, required this.contentText, required this.onPressed}) : super(key: key);
  final String contentText;
final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.symmetric(vertical: 15.0),
        width: double.infinity,
        height: 41,
        decoration: const BoxDecoration(color: Color(0XFFF5F5F5)),
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Text(contentText),
        ),
      ),
    );
  }
}
