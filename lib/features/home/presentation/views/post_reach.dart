import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:reach_me/core/components/custom_textfield.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/features/account/presentation/widgets/image_placeholder.dart';
import 'package:reach_me/features/home/data/models/post_model.dart';
import 'package:reach_me/features/home/presentation/bloc/social-service-bloc/ss_bloc.dart';

class PostReach extends StatefulHookWidget {
  const PostReach({Key? key}) : super(key: key);

  @override
  State<PostReach> createState() => _PostReachState();
}

class _PostReachState extends State<PostReach> {
  Future<File?> getImage(ImageSource source) async {
    final _picker = ImagePicker();
    try {
      final imageFile = await _picker.pickImage(
        source: source,
        imageQuality: 50,
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
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final counter = useState(0);
    final controller = useTextEditingController();
    final _imageList = useState<List<File>>([]);
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.close, size: 17),
                              padding: EdgeInsets.zero,
                              splashColor: Colors.transparent,
                              splashRadius: 20,
                              constraints: const BoxConstraints(),
                              onPressed: () => RouteNavigators.pop(context),
                            ),
                            const SizedBox(width: 20),
                            const Text(
                              'Create a reach',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: SvgPicture.asset('assets/svgs/send.svg'),
                          onPressed: () {
                            if (controller.text.isNotEmpty ||
                                _imageList.value.isNotEmpty) {
                              globals.socialServiceBloc!.add(CreatePostEvent(
                                content: controller.text,
                                commentOption: 'everyone',
                              ));
                              RouteNavigators.pop(context);
                            }
                          },
                        ),
                      ],
                    ).paddingSymmetric(h: 16),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const ImagePlaceholder(width: 33, height: 33),
                            const SizedBox(width: 12),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  (globals.user!.firstName! +
                                          ' ' +
                                          globals.user!.lastName!)
                                      .toTitleCase(),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textColor2,
                                  ),
                                ),
                                const Text(
                                  'Nigeria',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.greyShade1),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => RouteNavigators.route(
                                  context, const TagLocation()),
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                        'assets/svgs/location.svg'),
                                    const Text(
                                      '   Location',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textColor2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Text(
                              counter.value.toString() + '/' + '200',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: counter.value == 200
                                    ? Colors.red
                                    : AppColors.textColor2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ).paddingSymmetric(h: 16),
                    const SizedBox(height: 20),
                    const Divider(color: Color(0xFFEBEBEB), thickness: 0.5),
                    TextField(
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      minLines: 1,
                      maxLines: 6,
                      controller: controller,
                      maxLength: 200,
                      onChanged: (val) {
                        counter.value = val.length;
                      },
                      decoration: const InputDecoration(
                        counterText: '',
                        hintText: "What's on your mind?",
                        hintStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.greyShade1,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                    ).paddingSymmetric(h: 16),
                    const SizedBox(height: 10),
                    _imageList.value.isNotEmpty
                        ? SizedBox(
                            height: getScreenHeight(200),
                            child: Center(
                              child: ListView.builder(
                                  itemCount: _imageList.value.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    if (_imageList.value.isEmpty) {
                                      return const SizedBox.shrink();
                                    }

                                    return Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        Container(
                                          width: getScreenWidth(200),
                                          height: getScreenHeight(200),
                                          clipBehavior: Clip.hardEdge,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              RouteNavigators.route(
                                                context,
                                                PhotoView(
                                                  imageProvider: FileImage(
                                                      _imageList.value[index]),
                                                ),
                                              );
                                            },
                                            child: Image.file(
                                              _imageList.value[index],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: getScreenWidth(4),
                                          top: getScreenWidth(5),
                                          child: GestureDetector(
                                            onTap: () {
                                              _imageList.value.removeAt(index);
                                              setState(() {});
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Container(
                                                height: getScreenHeight(26),
                                                width: getScreenWidth(26),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.close,
                                                    color: AppColors.grey,
                                                    size: getScreenHeight(14),
                                                  ),
                                                ),
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: AppColors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ).paddingOnly(r: 10);
                                  }),
                            )).paddingSymmetric(h: 16)
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                color: const Color(0xFFF5F5F5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                            ),
                            builder: (context) {
                              return ListView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 27,
                                    vertical: 10,
                                  ),
                                  children: [
                                    Container(
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: AppColors.greyShade5
                                            .withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ).paddingSymmetric(h: size.width / 2.7),
                                    SizedBox(height: getScreenHeight(21)),
                                    Center(
                                      child: Text(
                                        'Who can reply',
                                        style: TextStyle(
                                          fontSize: getScreenHeight(16),
                                          color: AppColors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: getScreenHeight(5)),
                                    Center(
                                      child: Text(
                                        'Identify who can reply to this reach.',
                                        style: TextStyle(
                                          fontSize: getScreenHeight(14),
                                          color: AppColors.greyShade3,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: getScreenHeight(20)),
                                    InkWell(
                                      onTap: () {},
                                      child: ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        minLeadingWidth: 14,
                                        leading: SvgPicture.asset(
                                            'assets/svgs/world.svg'),
                                        title: Text(
                                          'Everyone can reply',
                                          style: TextStyle(
                                            fontSize: getScreenHeight(16),
                                            color: AppColors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: getScreenHeight(10)),
                                    InkWell(
                                      onTap: () {},
                                      child: ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        minLeadingWidth: 14,
                                        leading: SvgPicture.asset(
                                            'assets/svgs/people-you-follow.svg'),
                                        title: Text(
                                          'People you follow',
                                          style: TextStyle(
                                            fontSize: getScreenHeight(16),
                                            color: AppColors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: getScreenHeight(10)),
                                    InkWell(
                                      onTap: () {},
                                      child: ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        minLeadingWidth: 14,
                                        leading: SvgPicture.asset(
                                            'assets/svgs/people-you-mention.svg'),
                                        title: Text(
                                          'Only people you mention',
                                          style: TextStyle(
                                            fontSize: getScreenHeight(16),
                                            color: AppColors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: getScreenHeight(10)),
                                    InkWell(
                                      onTap: () {},
                                      child: ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        minLeadingWidth: 14,
                                        leading: SvgPicture.asset(
                                            'assets/svgs/none.svg'),
                                        title: Text(
                                          'None',
                                          style: TextStyle(
                                            fontSize: getScreenHeight(16),
                                            color: AppColors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]);
                            });
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/svgs/world.svg', height: 30),
                          const SizedBox(width: 9),
                          const Text(
                            'Everyone can reply',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textColor2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        // IconButton(
                        //   onPressed: () {},
                        //   padding: EdgeInsets.zero,
                        //   icon: SvgPicture.asset('assets/svgs/emoji.svg'),
                        //   splashColor: Colors.transparent,
                        //   splashRadius: 20,
                        //   constraints: const BoxConstraints(),
                        // ),
                        // const SizedBox(width: 20),
                        IconButton(
                          onPressed: () async {
                            final image = await getImage(ImageSource.gallery);
                            if (image != null) {
                              _imageList.value.add(image);
                              setState(() {});
                            }
                          },
                          splashColor: Colors.transparent,
                          splashRadius: 20,
                          padding: EdgeInsets.zero,
                          icon: SvgPicture.asset('assets/svgs/gallery.svg'),
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 20),
                        IconButton(
                          onPressed: () {},
                          padding: EdgeInsets.zero,
                          splashColor: Colors.transparent,
                          splashRadius: 20,
                          icon: SvgPicture.asset('assets/svgs/mic.svg'),
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TagLocation extends StatelessWidget {
  const TagLocation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 17),
                    padding: EdgeInsets.zero,
                    splashColor: Colors.transparent,
                    splashRadius: 20,
                    constraints: const BoxConstraints(),
                    onPressed: () => RouteNavigators.pop(context),
                  ),
                  const Text(
                    'Tag Location',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: Container(
                      width: 36,
                      height: 26,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 17,
                        color: AppColors.white,
                      ),
                    ),
                    onPressed: () => RouteNavigators.pop(context),
                  ),
                ],
              ).paddingSymmetric(h: 16),
              const SizedBox(height: 22),
              const CustomRoundTextField(
                hintText: 'Search Location',
              ).paddingSymmetric(h: 16),
              const SizedBox(height: 15),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(33),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Nigeria',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Color(0xFFC4C4C4),
                        ),
                      ),
                    )
                  ],
                ),
              ).paddingSymmetric(h: 16),
              const SizedBox(height: 10),
              ListTile(
                title: const Text(
                  'Michael Okpara University of Agriculture',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textColor2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  'Owerri, Imo State, Nigeria',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textColor2.withOpacity(0.5),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ListTile(
                title: const Text(
                  'Michael Okpara University of Agriculture',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textColor2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  'Owerri, Imo State, Nigeria',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textColor2.withOpacity(0.5),
                    fontWeight: FontWeight.w500,
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

class EditReach extends HookWidget {
  const EditReach({Key? key, required this.post}) : super(key: key);
  final PostModel post;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final controller = useTextEditingController(text: post.content ?? '');
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.close, size: 17),
                              padding: EdgeInsets.zero,
                              splashColor: Colors.transparent,
                              splashRadius: 20,
                              constraints: const BoxConstraints(),
                              onPressed: () => RouteNavigators.pop(context),
                            ),
                            const SizedBox(width: 20),
                            const Text(
                              'Edit reach',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: SvgPicture.asset('assets/svgs/send.svg'),
                          onPressed: () {
                            if (controller.text.isNotEmpty) {
                              globals.socialServiceBloc!.add(EditContentEvent(
                                content: controller.text,
                                postId: post.postId,
                              ));
                              RouteNavigators.pop(context);
                            }
                          },
                        ),
                      ],
                    ).paddingSymmetric(h: 16),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const ImagePlaceholder(width: 33, height: 33),
                            const SizedBox(width: 12),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '@${globals.user!.username}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textColor2,
                                  ),
                                ),
                                const Text(
                                  'Nigeria',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.greyShade1),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Text(
                          '10/200',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textColor2,
                          ),
                        ),
                      ],
                    ).paddingSymmetric(h: 16),
                    const SizedBox(height: 20),
                    const Divider(color: Color(0xFFEBEBEB), thickness: 0.5),
                    TextField(
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      minLines: 1,
                      maxLines: 6,
                      controller: controller,
                      maxLength: 200,
                      decoration: const InputDecoration(
                        hintText: "What's on your mind?",
                        counterText: '',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.greyShade1,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                    ).paddingSymmetric(h: 16),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                color: const Color(0xFFF5F5F5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                            ),
                            builder: (context) {
                              return ListView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 27,
                                    vertical: 10,
                                  ),
                                  children: [
                                    Container(
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: AppColors.greyShade5
                                            .withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ).paddingSymmetric(h: size.width / 2.7),
                                    SizedBox(height: getScreenHeight(21)),
                                    Center(
                                      child: Text(
                                        'Who can reply',
                                        style: TextStyle(
                                          fontSize: getScreenHeight(16),
                                          color: AppColors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: getScreenHeight(5)),
                                    Center(
                                      child: Text(
                                        'Identify who can reply to this reach.',
                                        style: TextStyle(
                                          fontSize: getScreenHeight(14),
                                          color: AppColors.greyShade3,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: getScreenHeight(20)),
                                    InkWell(
                                      onTap: () {},
                                      child: ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        minLeadingWidth: 14,
                                        leading: SvgPicture.asset(
                                            'assets/svgs/world.svg'),
                                        title: Text(
                                          'Everyone can reply',
                                          style: TextStyle(
                                            fontSize: getScreenHeight(16),
                                            color: AppColors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: getScreenHeight(10)),
                                    InkWell(
                                      onTap: () {},
                                      child: ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        minLeadingWidth: 14,
                                        leading: SvgPicture.asset(
                                            'assets/svgs/people-you-follow.svg'),
                                        title: Text(
                                          'People you follow',
                                          style: TextStyle(
                                            fontSize: getScreenHeight(16),
                                            color: AppColors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: getScreenHeight(10)),
                                    InkWell(
                                      onTap: () {},
                                      child: ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        minLeadingWidth: 14,
                                        leading: SvgPicture.asset(
                                            'assets/svgs/people-you-mention.svg'),
                                        title: Text(
                                          'Only people you mention',
                                          style: TextStyle(
                                            fontSize: getScreenHeight(16),
                                            color: AppColors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: getScreenHeight(10)),
                                    InkWell(
                                      onTap: () {},
                                      child: ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        minLeadingWidth: 14,
                                        leading: SvgPicture.asset(
                                            'assets/svgs/none.svg'),
                                        title: Text(
                                          'None',
                                          style: TextStyle(
                                            fontSize: getScreenHeight(16),
                                            color: AppColors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]);
                            });
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/svgs/world.svg', height: 30),
                          const SizedBox(width: 9),
                          const Text(
                            'Everyone can reply',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textColor2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
