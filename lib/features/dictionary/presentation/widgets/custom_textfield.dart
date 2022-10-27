import 'package:flutter/material.dart';

class SearchCustomTextField extends StatelessWidget {
  const SearchCustomTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: const Color(0xffF5F5F5),
                borderRadius: BorderRadius.circular(33)),
            height: 50,
            child: TextField(
              decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: const TextStyle(color: Color(0xffCECECE)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(33),
                      borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(33),
                      borderSide: BorderSide.none)),
            ),
          )),
    );
  }
}
