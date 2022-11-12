import 'package:flutter/material.dart';

class AddToGlossaryTextBox extends StatelessWidget {
  const AddToGlossaryTextBox(
      {Key? key,
      required this.hintText,
      this.controller,
      this.maxLines,
      this.height,
      this.validator,
      this.width})
      : super(key: key);
  final String hintText;
  final int? maxLines;
  final double? height;
  final double? width;
  final FormFieldValidator<String>? validator;

  final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 19),
      height: height,
      width: width,
      child: TextFormField(
        validator: validator,
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
            hintText: hintText,
            focusedBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            enabledBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            focusColor: Colors.red,
            focusedErrorBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            errorBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      ),
    );
  }
}
