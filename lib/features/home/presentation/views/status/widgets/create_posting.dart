import 'package:camera/camera.dart';
import 'package:deepar_flutter/deepar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reach_me/core/utils/extensions.dart';

import '../../../../../../core/services/navigation/navigation_service.dart';
import '../../../../../../core/utils/constants.dart';
import '../../../../../../core/utils/dimensions.dart';
import '../audio.status.dart';
import '../text.status.dart';

class CreatePosting extends StatefulHookWidget {
  final DeepArController? controller;
  final BuildContext context;
  const CreatePosting({this.controller, Key? key, required this.context})
      : super(key: key);

  @override
  State<CreatePosting> createState() => _CreatePostingState();
}

class _CreatePostingState extends State<CreatePosting> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    final isCameraStatus = useState(true);
    final isAudioStatus = useState(false);
    final isTextStatus = useState(false);
    return Column(children: [
      Expanded(
        child: Container(
          width: size.width,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Stack(children: [
            Transform.scale(
              scaleX: (!(SizeConfig.screenHeight > 782) ? 0.52 : 0.46) /
                  deviceRatio,
              child: DeepArPreview(
                widget.controller!,
              ),
            ),
            Container(
              child: Column(
                  //mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
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
                            onTap: () async {
                              await widget.controller!.toggleFlash();
                              setState(() {});
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: !widget.controller!.flashState
                                    ? Colors.black.withOpacity(0.4)
                                    : Colors.white,
                              ),
                              child: SvgPicture.asset(
                                'assets/svgs/flash-icon.svg',
                                height: 10,
                                color: !widget.controller!.flashState
                                    ? Colors.white
                                    : Colors.black,
                                width: 10,
                                // fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ]).paddingSymmetric(h: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.black.withOpacity(0.50),
                            borderRadius: BorderRadius.circular(33),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isTextStatus.value
                                      ? AppColors.white
                                      : Colors.transparent,
                                ),
                                child: IconButton(
                                  onPressed: () async {
                                    isTextStatus.value = true;
                                    isCameraStatus.value = false;
                                    isAudioStatus.value = false;
                                    RouteNavigators.routeReplace(
                                        context, const TextStatus());
                                  },
                                  icon: SvgPicture.asset('assets/svgs/pen.svg',
                                      color: isTextStatus.value
                                          ? AppColors.black
                                          : null),
                                  //  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isAudioStatus.value
                                      ? AppColors.white
                                      : Colors.transparent,
                                ),
                                child: IconButton(
                                  onPressed: () async {
                                    isAudioStatus.value = true;
                                    isTextStatus.value = false;
                                    isCameraStatus.value = false;
                                    RouteNavigators.routeReplace(
                                        context, const AudioStatus());
                                  },
                                  icon: SvgPicture.asset(
                                      'assets/svgs/status-mic.svg',
                                      color: isAudioStatus.value
                                          ? AppColors.black
                                          : null),
                                  // padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isCameraStatus.value
                                      ? AppColors.white
                                      : Colors.transparent,
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    isCameraStatus.value = true;
                                    isAudioStatus.value = false;
                                    isTextStatus.value = false;
                                  },
                                  icon: SvgPicture.asset(
                                      'assets/svgs/Camera.svg',
                                      color: isCameraStatus.value
                                          ? AppColors.black
                                          : null),
                                  //padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ).paddingSymmetric(h: 20),
                    const SizedBox.shrink(),
                  ]).paddingOnly(t: 50),
            ),
          ]),
        ),
      ),
    ]);
  }
}
