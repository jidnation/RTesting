import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/utils/constants.dart';
import '../../../../core/utils/dimensions.dart';
import '../../../account/presentation/widgets/image_placeholder.dart';

class ReceiveAudioCall extends StatefulWidget {
  const ReceiveAudioCall(
      {super.key,
      required this.channelName,
      required this.token,
      required this.user});

  final String channelName, token, user;

  @override
  State<ReceiveAudioCall> createState() => _ReceiveAudioCallState();
}

class _ReceiveAudioCallState extends State<ReceiveAudioCall> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            Image.asset(
              'assets/images/incoming_call.png',
              fit: BoxFit.fill,
              height: size.height,
              width: size.width,
            ),
            Positioned(
              top: 100,
              left: 1,
              right: 1,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ImagePlaceholder(
                    width: getScreenWidth(100),
                    height: getScreenHeight(100),
                  ),
                  Text(
                    widget.user,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w400,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Ongoing call',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Stack(
                children: [
                  Opacity(
                    opacity: 0.5,
                    child: Container(
                      width: size.width,
                      height: 100,
                      color: const Color(0xff000000),
                    ),
                  ),
                  SizedBox(
                    width: size.width,
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const SizedBox(
                          width: 26,
                          height: 26,
                        ),
                        FloatingActionButton(
                          onPressed: () {},
                          backgroundColor: const Color(0xffE91C43),
                          child: SvgPicture.asset(
                            'assets/svgs/call.svg',
                            color: AppColors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Stack(
                            children: [
                              const Opacity(
                                opacity: 0.5,
                                child: CircleAvatar(
                                  backgroundColor: Color(0xff000000),
                                  radius: 23,
                                ),
                              ),
                              Positioned(
                                top: 10,
                                left: 10,
                                right: 10,
                                bottom: 10,
                                child: SvgPicture.asset(
                                  'assets/svgs/mic.svg',
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
