import 'package:flutter/material.dart';

class AbbreviationCustomButton extends StatelessWidget {
  const AbbreviationCustomButton(
      {Key? key, required this.buttonText, required this.onPressed})
      : super(key: key);
  final String buttonText;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.only(bottom: 44),
        alignment: Alignment.center,
        height: 50,
        width: 190,
        decoration: BoxDecoration(
            color: const Color(0xff001824),
            borderRadius: BorderRadius.circular(30)),
        child: Text(
          buttonText,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}