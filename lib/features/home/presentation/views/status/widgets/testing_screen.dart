import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../core/utils/constants.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../core/utils/dimensions.dart';

class TestingScreen extends StatelessWidget {
  const TestingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Stack(children: [
              SizedBox(
                height: 70,
                child: Column(
                  children: [
                    Container(
                      height: 49.44,
                      width: 49.44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    height: 20,
                    width: 20,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      border: Border.all(
                        color: Colors.white,
                        width: 1.2,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                        child: Icon(
                      Icons.add,
                      size: 13,
                      color: Colors.white,
                    )),
                  ))
            ]),
            const SizedBox(height: 20),
            const MomentTabs(
              icon: Icons.favorite_outline_outlined,
              value: "24k",
            ),
            const SizedBox(height: 20),
            Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              SvgPicture.asset('assets/svgs/comment.svg', color: Colors.white),
              const SizedBox(height: 5),
              const CustomText(
                text: '3k',
                weight: FontWeight.w500,
                color: Colors.white,
                size: 13.28,
              )
            ]),
            const SizedBox(height: 20),
            SvgPicture.asset(
              'assets/svgs/message.svg',
              color: Colors.white,
              width: 24.44,
              height: 22,
            ),

            /////
            // /////////////////////////
            Column(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const CustomText(
                  text: '@jasonstatham',
                  color: Colors.white,
                  weight: FontWeight.w600,
                  size: 16.28,
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: getScreenWidth(300),
                  child: const CustomText(
                    text:
                        'The normal ride through the street...\ni sure miss my home #moviestudio...\nMore',
                    color: Colors.white,
                    weight: FontWeight.w600,
                    // overflow: TextOverflow.ellipsis,
                    size: 16.28,
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        SvgPicture.asset('assets/svgs/music.svg'),
                        const SizedBox(width: 10),
                        const CustomText(
                          text: 'Original Audio',
                          color: Colors.white,
                          weight: FontWeight.w600,
                          size: 15.28,
                        )
                      ]),
                      Container(
                        height: 50,
                        width: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.red,
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                              )
                            ]),
                      )
                    ])
              ]),
            ]),
          ]),
        ),
      ),
    );
  }
}

class MomentTabs extends StatelessWidget {
  final String value;
  final IconData icon;
  const MomentTabs({
    Key? key,
    required this.value,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Icon(
        icon,
        color: Colors.white,
        size: 30,
      ),
      const SizedBox(height: 5),
      CustomText(
        text: value,
        weight: FontWeight.w500,
        color: Colors.white,
        size: 13.28,
      )
    ]);
  }
}
