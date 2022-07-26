import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/components/snackbar.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/core/utils/helpers.dart';
import 'package:reach_me/features/home/data/dtos/create.status.dto.dart';
import 'package:reach_me/features/home/presentation/bloc/social-service-bloc/ss_bloc.dart';
import 'package:reach_me/features/home/presentation/views/home_screen.dart';

class TextStatus extends StatefulHookWidget {
  const TextStatus({Key? key}) : super(key: key);

  @override
  State<TextStatus> createState() => _TextStatusState();
}

class _TextStatusState extends State<TextStatus> {
  Set active = {};

  handleTap(int index) {
    if (active.isNotEmpty) active.clear();
    setState(() {
      active.add(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isCameraStatus = useState(false);
    final isAudioStatus = useState(false);
    final isTextStatus = useState(true);
    final currentSelectedBg = useState<String>('assets/images/status-bg-1.jpg');
    final bgList = useState([
      'assets/images/status-bg-1.jpg',
      'assets/images/status-bg-2.jpg',
      'assets/images/status-bg-3.jpg'
    ]);
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(currentSelectedBg.value),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 60, 0, 35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
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
              ).paddingSymmetric(h: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: SizedBox(
                      width: getScreenWidth(65),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: bgList.value.length,
                            itemBuilder: (context, index) {
                              return BgButton(
                                isSelected:
                                    active.contains(index) ? true : false,
                                image: bgList.value[index],
                                onTap: () {
                                  handleTap(index);
                                  currentSelectedBg.value = bgList.value[index];
                                },
                              );
                            },
                          ),
                          FittedBox(
                            child: Text(
                              'Backgrounds',
                              style: TextStyle(
                                fontSize: getScreenHeight(13),
                                color: AppColors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        ],
                      ),
                    ).paddingOnly(l: 20),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        RouteNavigators.routeReplace(context,
                            TextStatus2(image: currentSelectedBg.value));
                      },
                      child: Text(
                        'Tap to type',
                        style: TextStyle(
                          fontSize: getScreenHeight(17),
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
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
                              },
                              icon: SvgPicture.asset('assets/svgs/pen.svg',
                                  color: isTextStatus.value
                                      ? AppColors.black
                                      : null),
                              //  padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ),
                          // Container(
                          //   padding: const EdgeInsets.all(1),
                          //   decoration: BoxDecoration(
                          //     shape: BoxShape.circle,
                          //     color: isAudioStatus.value
                          //         ? AppColors.white
                          //         : Colors.transparent,
                          //   ),
                          //   child: IconButton(
                          //     onPressed: () {
                          //       isAudioStatus.value = true;
                          //       isTextStatus.value = false;
                          //       isCameraStatus.value = false;
                          //     },
                          //     icon: SvgPicture.asset(
                          //         'assets/svgs/status-mic.svg',
                          //         color: isAudioStatus.value
                          //             ? AppColors.black
                          //             : null),
                          //     // padding: EdgeInsets.zero,
                          //     constraints: const BoxConstraints(),
                          //   ),
                          // ),
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
                                RouteNavigators.pop(context);
                              },
                              icon: SvgPicture.asset('assets/svgs/Camera.svg',
                                  color: isCameraStatus.value
                                      ? AppColors.black
                                      : null),
                              //padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ),
                        ],
                      ),
                    ).paddingOnly(r: 24),
                  )
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10),
                height: getScreenHeight(100),
                width: getScreenWidth(100),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.75),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.black.withOpacity(0.80),
                    width: 10,
                  ),
                ),
                child: Center(
                  child: Text(
                    'Aa',
                    style: TextStyle(
                      fontSize: getScreenHeight(21),
                      color: AppColors.black,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class BgButton extends StatelessWidget {
  const BgButton({
    Key? key,
    required this.image,
    required this.onTap,
    required this.isSelected,
  }) : super(key: key);

  final Function() onTap;
  final String image;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Container(
        height: getScreenHeight(35),
        width: getScreenHeight(35),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          border: isSelected
              ? Border.all(
                  color: AppColors.white,
                  width: 2,
                )
              : null,
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.cover,
          ),
        ),
      ),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    ).paddingOnly(b: 10);
  }
}

class TextStatus2 extends StatefulHookWidget {
  const TextStatus2({Key? key, required this.image}) : super(key: key);
  final String image;

  @override
  State<TextStatus2> createState() => _TextStatus2State();
}

class _TextStatus2State extends State<TextStatus2> {
  Set active = {};

  handleTap(int index) {
    if (active.isNotEmpty) active.clear();
    setState(() {
      active.add(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final currentAlignment = useState('center');
    final alignments = useState(['center', 'left', 'right', 'justify']);

    final selectedColour = useState<Color?>(null);
    final bgcolours = useState([
      const Color(0xFFC12626),
      const Color(0xFFFE9800),
      const Color(0xFF25B900),
      const Color(0xFF0077B6)
    ]);

    final currentFont = useState('inter');
    final fontsList = useState(['amita', 'poppins', 'inter']);

    final selectedImageBg = useState(widget.image);
    final bgImgsList = useState([
      'assets/images/status-bg-1.jpg',
      'assets/images/status-bg-2.jpg',
      'assets/images/status-bg-3.jpg'
    ]);

    final controller = useTextEditingController();
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          color: selectedColour.value,
          image: selectedColour.value == null
              ? DecorationImage(
                  image: AssetImage(selectedImageBg.value),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 60, 24, 35),
          child: BlocConsumer<SocialServiceBloc, SocialServiceState>(
              bloc: globals.socialServiceBloc,
              listener: (context, state) {
                if (state is CreateStatusLoading) {
                  Snackbars.success(
                    context,
                    message: 'Uploading status...',
                    milliseconds: 1000,
                  );
                }
              },
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => RouteNavigators.pop(context),
                          icon: Transform.scale(
                            scale: 1.8,
                            child: SvgPicture.asset('assets/svgs/dc-back.svg'),
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        IconButton(
                          onPressed: () {
                            if (controller.text.isNotEmpty) {
                              globals.socialServiceBloc!.add(
                                CreateStatusEvent(
                                  createStatusDto: CreateStatusDto(
                                    caption: controller.text,
                                    alignment: currentAlignment.value,
                                    font: currentFont.value,
                                    background: selectedColour.value != null
                                        ? selectedColour.value
                                            .toString()
                                            .replaceAll('Color(', '')
                                            .replaceAll(')', '')
                                        : selectedImageBg.value,
                                    type: 'text',
                                  ),
                                ),
                              );
                              RouteNavigators.pop(context);
                            }
                          },
                          icon: Transform.scale(
                            scale: 1.8,
                            child: SvgPicture.asset('assets/svgs/dc-send.svg'),
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        )
                      ],
                    ),
                    SizedBox(height: getScreenHeight(30)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: SvgPicture.asset(
                                'assets/svgs/status-smile.svg'),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          IconButton(
                            onPressed: () {
                              // Helper.iterate(
                              //     currentAlignment.value, alignments.value);
                              for (var i = 0;
                                  i < alignments.value.length;
                                  i++) {
                                if (alignments.value[i] ==
                                    currentAlignment.value) {
                                  if (i == alignments.value.length - 1) {
                                    currentAlignment.value =
                                        alignments.value[0];
                                  } else {
                                    currentAlignment.value =
                                        alignments.value[i + 1];
                                  }
                                  break;
                                }
                              }
                            },
                            icon: Icon(
                              Helper.getAlignment(
                                  currentAlignment.value)['align_icon'],
                              color: AppColors.white,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          TextButton(
                            onPressed: () {
                              for (var i = 0; i < fontsList.value.length; i++) {
                                if (fontsList.value[i] == currentFont.value) {
                                  if (i == fontsList.value.length - 1) {
                                    currentFont.value = fontsList.value[0];
                                  } else {
                                    currentFont.value = fontsList.value[i + 1];
                                  }
                                  break;
                                }
                              }
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            child: Text('Font',
                                style: Helper.getFont(currentFont.value)),
                          ),
                          IconButton(
                            onPressed: () {
                              selectedColour.value = null;
                              for (var i = 0;
                                  i < bgImgsList.value.length;
                                  i++) {
                                if (bgImgsList.value[i] ==
                                    selectedImageBg.value) {
                                  if (i == bgImgsList.value.length - 1) {
                                    selectedImageBg.value = bgImgsList.value[0];
                                  } else {
                                    selectedImageBg.value =
                                        bgImgsList.value[i + 1];
                                  }
                                  break;
                                }
                              }
                            },
                            icon: SvgPicture.asset('assets/svgs/pallete.svg'),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          IconButton(
                            onPressed: () {
                              for (var i = 0; i < bgcolours.value.length; i++) {
                                if (bgcolours.value[i] ==
                                        selectedColour.value ||
                                    selectedColour.value == null) {
                                  if (i == bgcolours.value.length - 1) {
                                    selectedColour.value = bgcolours.value[0];
                                  } else {
                                    selectedColour.value =
                                        bgcolours.value[i + 1];
                                  }
                                  break;
                                }
                              }
                            },
                            icon: Container(
                              decoration: BoxDecoration(
                                color: selectedColour.value ?? AppColors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: getScreenHeight(50)),
                    Flexible(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          TextFormField(
                            cursorColor: AppColors.white,
                            controller: controller,
                            maxLength: 250,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                              counterText: '',
                            ),
                            textAlign: Helper.getAlignment(
                                currentAlignment.value)['align'],
                            style: Helper.getFont(currentFont.value),
                            maxLines: 10,
                          ),
                        ],
                      ),
                    )
                  ],
                );
              }),
        ),
      ),
    );
  }
}
