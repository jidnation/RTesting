import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reach_me/core/components/snackbar.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/features/home/data/dtos/create.status.dto.dart';
import 'package:reach_me/features/home/presentation/bloc/social-service-bloc/ss_bloc.dart';
import 'package:reach_me/features/home/presentation/views/status/audio.status.dart';
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

  Future<File?> getImage(ImageSource source) async {
    final _picker = ImagePicker();
    try {
      final imageFile = await _picker.pickImage(
        source: source,
        imageQuality: 50,
        maxHeight: 900,
        maxWidth: 600,
      );

      if (imageFile != null) {
        File image = File(imageFile.path);
        return image;
      }
    } catch (e) {
      // print(e);
    }
    return null;
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
      backgroundColor: const Color(0xFF001824),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: cameraLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  :  ListView(
          // shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child:CameraPreview(
                      controller!,
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
                          onPressed: () async {
                            final image = await getImage(ImageSource.gallery);
                            if (image != null) {
                              RouteNavigators.route(context,
                                  BuildCameraPreview(image: XFile(image.path)));
                            }
                          },
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
                            await controller!.takePicture().then((value) =>
                                RouteNavigators.route(
                                    context, BuildCameraPreview(image: value)));
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

class BuildCameraPreview extends StatelessWidget {
  const BuildCameraPreview({
    Key? key,
    required this.image,
  }) : super(key: key);
  final XFile image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001824),
      body: BlocConsumer<SocialServiceBloc, SocialServiceState>(
          bloc: globals.socialServiceBloc,
          listener: (context, state) {
            if (state is MediaUploadLoading) {
              Snackbars.success(
                context,
                message: 'Uploading status...',
                milliseconds: 1000,
              );
            }
            if (state is MediaUploadError) {
              Snackbars.error(context, message: state.error);
            }
            if (state is MediaUploadSuccess) {
              globals.socialServiceBloc!.add(
                CreateStatusEvent(
                  createStatusDto: CreateStatusDto(
                    caption: 'NIL',
                    type: 'image',
                    imageMedia: state.image,
                  ),
                ),
              );
              RouteNavigators.pop(context);
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Positioned.fill(
                  child: Image.file(
                    File(image.path),
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: getScreenHeight(50)),
                  child: Column(
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
                              globals.socialServiceBloc!.add(
                                  MediaUploadEvent(media: File(image.path)));
                            },
                            icon: Transform.scale(
                              scale: 1.8,
                              child: SvgPicture.asset(
                                'assets/svgs/dc-send.svg',
                                height: getScreenHeight(71),
                              ),
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ).paddingSymmetric(h: 24),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
