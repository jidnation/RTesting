import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/features/dictionary/data/models/recently_added_model.dart';

class ContentContainer extends StatelessWidget {
  const ContentContainer(
      {required this.getRecentlyAddedWord,
      this.showButtons = false,
      Key? key,
      this.onDelete,
      this.onEdit})
      : super(key: key);
  final GetRecentlyAddedWord getRecentlyAddedWord;
  final bool showButtons;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.5),
          color: Colors.white,
        ),
        width: 410,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 18.0,
            right: 25,
            top: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          dateFormatter(getRecentlyAddedWord.createdAt!),
                          style: const TextStyle(
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w600),
                        ),
                        showButtons
                            ? const SizedBox()
                            : RichText(
                                softWrap: true,
                                text: TextSpan(
                                  style: const TextStyle(color: Colors.black),
                                  children: [
                                    const TextSpan(
                                        text: 'creator: ',
                                        style: TextStyle(color: Colors.blue)),
                                    TextSpan(
                                      text:
                                          '@${getRecentlyAddedWord.wordOwnerProfile!.username!}',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              showButtons
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          softWrap: true,
                          text: TextSpan(
                            style: const TextStyle(color: Colors.black),
                            children: [
                              const TextSpan(
                                  text: 'creator: ',
                                  style: TextStyle(color: Colors.blue)),
                              TextSpan(
                                text:
                                    '@${getRecentlyAddedWord.wordOwnerProfile!.username!}',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 40.0, bottom: 10),
                          child: Container(
                            height: 40.0,
                            decoration: const BoxDecoration(
                                color: AppColors.greyShade10,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                  onPressed: onEdit,
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                    color: AppColors.primaryColor,
                                    size: 20,
                                  ),
                                ),
                                IconButton(
                                  onPressed: onDelete,
                                  icon: const Icon(
                                    Icons.delete_outlined,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox()
            ],
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
