import 'package:camera/camera.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../core/services/navigation/navigation_service.dart';
import '../../../../../../core/utils/dimensions.dart';

class LiveScreen extends StatefulWidget {
  final CameraController? controller;
  final CarouselController slidingController;
  const LiveScreen({
    Key? key,
    this.controller,
    required this.slidingController,
  }) : super(key: key);

  @override
  State<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    widget.controller!.setFlashMode(FlashMode.auto);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(children: [
      Expanded(
        child: Container(
          width: size.width,
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          )),
          // height: size.height * 0.8,
          child: CameraPreview(
            widget.controller!,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Stack(children: [
                const SizedBox(height: 40),
                Positioned(
                  top: 15,
                  right: 0,
                  left: 0,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            widget.slidingController.jumpToPage(0);
                            RouteNavigators.pop(context);
                          },
                          icon: Transform.scale(
                            scale: 1.8,
                            child: SvgPicture.asset(
                              'assets/svgs/dc-cancel.svg',
                              height: getScreenHeight(71),
                            ),
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        InkWell(
                          onTap: () async {},
                          child: Container(
                              height: 40,
                              width: 40,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.black.withOpacity(0.4),
                              ),
                              child: SvgPicture.asset(
                                'assets/svgs/Setting.svg',
                                height: 10,
                                color: Colors.white,
                                width: 10,
                                // fit: BoxFit.contain,
                              )),
                        ),
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 320,
                            height: 80,
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.white, width: 3)),
                                  child: const CircleAvatar(
                                    backgroundImage:
                                        AssetImage("assets/images/user.png"),
                                  ),
                                ),
                                Positioned(
                                  left: 20,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.white, width: 3)),
                                    child: const CircleAvatar(
                                      backgroundImage:
                                          AssetImage("assets/images/user.png"),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 40,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.white, width: 3)),
                                    child: const CircleAvatar(
                                      backgroundImage:
                                          AssetImage("assets/images/user.png"),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 60,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.white, width: 3)),
                                    child: const CircleAvatar(
                                      backgroundImage:
                                          AssetImage("assets/images/user.png"),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 80,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.white, width: 3)),
                                    child: const CircleAvatar(
                                      backgroundImage:
                                          AssetImage("assets/images/user.png"),
                                    ),
                                  ),
                                ),
                                const Positioned(
                                  left: 140,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 12.0),
                                    child: Text(
                                      "9 Reachers are active now",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    ]);
  }
}
