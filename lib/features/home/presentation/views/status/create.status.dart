import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/features/home/presentation/views/status/text.status.dart';

late List<CameraDescription> _cameras;

class CreateStatus extends StatefulHookWidget {
  const CreateStatus({Key? key}) : super(key: key);

  @override
  State<CreateStatus> createState() => _CreateStatusState();
}

class _CreateStatusState extends State<CreateStatus>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  CameraController? controller;
  bool cameraLoading = true;
  XFile? imageFile;
  XFile? videoFile;

  @override
  void initState() {
    super.initState();
    getAvailableCameras();
  }

  Future<void> getAvailableCameras() async {
    _cameras = await availableCameras().then((value) {
      initializeCamera(value[1]);
      return value;
    });
  }

  Future<void> initializeCamera(CameraDescription description) async {
    controller = CameraController(description, ResolutionPreset.max);
    controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      cameraLoading = false;
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access.');
            break;
          default:
            print('Handle other errors.');
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isCameraStatus = useState(true);
    final isAudioStatus = useState(false);
    final isTextStatus = useState(false);
    return Scaffold(
      backgroundColor: AppColors.black.withOpacity(0.1),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: cameraLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : CameraPreview(
                      controller!,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
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
                              IconButton(
                                onPressed: () {
                                  if (controller!.value.flashMode ==
                                      FlashMode.off) {
                                    controller!.setFlashMode(FlashMode.always);
                                  } else {
                                    controller!.setFlashMode(FlashMode.off);
                                  }
                                  setState(() {});
                                },
                                icon: Transform.scale(
                                  scale: 1.8,
                                  child: SvgPicture.asset(
                                    'assets/svgs/dc-flashlight.svg',
                                    height: getScreenHeight(71),
                                  ),
                                ),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ).paddingSymmetric(h: 24),
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
                                        onPressed: () {
                                          isTextStatus.value = true;
                                          isCameraStatus.value = false;
                                          isAudioStatus.value = false;
                                          RouteNavigators.routeReplace(
                                              context, const TextStatus());
                                        },
                                        icon: SvgPicture.asset(
                                            'assets/svgs/pen.svg',
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
                                        onPressed: () {
                                          isAudioStatus.value = true;
                                          isTextStatus.value = false;
                                          isCameraStatus.value = false;
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
                        ],
                      ).paddingOnly(t: 50),
                    ),
            ),
            Container(
              // height: size.height,
              width: size.width,
              decoration: const BoxDecoration(
                  //  color: AppColors.black.withOpacity(0.9),
                  ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: getScreenHeight(44)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: IconButton(
                          onPressed: () {},
                          icon: Transform.scale(
                            scale: 1.8,
                            child: SvgPicture.asset(
                              'assets/svgs/check-gallery.svg',
                              height: getScreenHeight(71),
                            ),
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ),
                      SizedBox(width: getScreenWidth(70)),
                      Flexible(
                        child: InkWell(
                          onTap: () async {
                            await controller!.takePicture();
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.white,
                            ),
                            padding: const EdgeInsets.all(20),
                            child: SvgPicture.asset(
                              'assets/svgs/Camera.svg',
                              color: AppColors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: getScreenWidth(70)),
                      Flexible(
                        child: IconButton(
                          onPressed: () {
                            if (_cameras.isNotEmpty && _cameras.length > 1) {
                              if (_cameras.length == 2) {
                                if (controller!.description.lensDirection ==
                                    CameraLensDirection.front) {
                                  initializeCamera(_cameras[0]);
                                } else {
                                  initializeCamera(_cameras[1]);
                                }
                              } else {
                                initializeCamera(_cameras[1]);
                              }
                            }
                            setState(() {});
                          },
                          icon: Transform.scale(
                            scale: 1.8,
                            child: SvgPicture.asset(
                              'assets/svgs/flip-camera.svg',
                              height: getScreenHeight(71),
                            ),
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: getScreenHeight(44))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// This allows a value of type T or T? to be treated as a value of type T?.
///
/// We use this so that APIs that have become non-nullable can still be used
/// with `!` and `?` on the stable branch.
// TODO(ianh): Remove this once we roll stable in late 2021.
T? _ambiguate<T>(T? value) => value;