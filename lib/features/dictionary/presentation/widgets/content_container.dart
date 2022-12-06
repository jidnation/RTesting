import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:reach_me/features/dictionary/data/models/recently_added_model.dart';

class ContentContainer extends StatelessWidget {
  const ContentContainer(
      {required this.getRecentlyAddedWord, this.showButtons = false, Key? key, this.onDelete, this.onEdit})
      : super(key: key);
  final GetRecentlyAddedWord getRecentlyAddedWord;
  final bool showButtons;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 419, maxHeight: 190),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.5),
            color: Colors.white,
          ),
          height: 130,
          width: 410,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 18.0,
              right: 25,
              top: 16,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    maxLines: 5,
                    softWrap: true,
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
                    dateFormatter(getRecentlyAddedWord.createdAt!),
                    style: const TextStyle(
                        fontFamily: 'poppins', fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  showButtons
                      ? Padding(
                          padding: const EdgeInsets.only(left: 240.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: onEdit,
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.black87,
                                ),
                              ),
                              IconButton(
                                onPressed: onDelete,
                                icon: const Icon(
                                  Icons.delete_forever_outlined,
                                  color: Colors.red,
                                ),
                              )
                            ],
                          ),
                        )
                      : const SizedBox()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String dateFormatter(String dateToFormat) {
    var date = DateTime.fromMillisecondsSinceEpoch(int.parse(dateToFormat));
    var dateParse = DateFormat.yMMMMd('en_US').format(date);
    return dateParse;
  }
}
