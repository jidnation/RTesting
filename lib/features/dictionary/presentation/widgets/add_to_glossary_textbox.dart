import 'package:flutter/material.dart';

class AddToGlossaryTextBox extends StatelessWidget {
  const AddToGlossaryTextBox(
      {Key? key,
      required this.hintText,
      this.controller,
      this.maxLines,
      this.height,
      this.width})
      : super(key: key);
  final String hintText;
  final int? maxLines;
  final double? height;
  final double? width;

  final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 19),
      height: height,
      width: width,
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          focusedBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusColor: Colors.red,
        ),
      ),
    );
  }
}
