import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/features/account/presentation/widgets/bottom_sheets.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/extensions.dart';

class CommentReacherCard extends StatelessWidget {
  const CommentReacherCard({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: size.width,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(
                color: AppColors.blackShade4,
                offset: Offset(0, 4),
                blurRadius: 8,
                spreadRadius: 0)
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      clipBehavior: Clip.hardEdge,
                      child: Image.asset(
                          'assets/images/user.png',
                          fit: BoxFit.fill),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle),
                    ).paddingOnly(l: 15, t: 10),
                    const SizedBox(width: 9),
                    Column(
                      mainAxisAlignment:
                          MainAxisAlignment.start,
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            const Text('Rooney Brown',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight:
                                        FontWeight.w500,
                                    color: AppColors
                                        .textColor2)),
                            const SizedBox(width: 3),
                            SvgPicture.asset(
                                'assets/svgs/verified.svg')
                          ],
                        ),
                        RichText(
                          text: const TextSpan(
                              text: 'Comments on ',
                              style: TextStyle(
                                fontSize: 9,
                                fontFamily: 'Poppins',
                                fontWeight:
                                    FontWeight.w400,
                                color:
                                    AppColors.textColor4,
                                height: 1,
                              ),
                              children: [
                                TextSpan(
                                    text: '@tayy_dev',
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: AppColors
                                          .primaryColor,
                                      fontFamily:
                                          'Poppins',
                                      fontWeight:
                                          FontWeight.w400,
                                      height: 1,
                                    ))
                              ]),
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          '22 Jan',
                          style: TextStyle(
                            fontSize: 10,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            color: AppColors.textColor4,
                            height: 1,
                          ),
                        )
                      ],
                    ).paddingOnly(t: 10),
                  ],
                ),
                IconButton(
                    onPressed: () async {
                      await showKebabCommentBottomSheet(context);
                    },
                    iconSize: 19,
                    padding: const EdgeInsets.all(0),
                    icon: SvgPicture.asset(
                        'assets/svgs/more-vertical.svg'))
              ],
            ),
            Flexible(
              child: const Text(
                "Someone said “when you become independent, you’ld understand why the prodigal son came back home”",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ).paddingSymmetric(v: 10, h: 15),
            ),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}