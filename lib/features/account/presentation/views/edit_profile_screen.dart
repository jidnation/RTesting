import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reach_me/core/components/custom_button.dart';
import 'package:reach_me/core/components/custom_textfield.dart';
import 'package:reach_me/core/components/list_tile_switch.dart';
import 'package:reach_me/core/components/profile_picture.dart';
import 'package:reach_me/core/components/snackbar.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/core/utils/validator.dart';
import 'package:reach_me/features/account/presentation/views/personal_info_settings.dart';
import 'package:reach_me/features/account/presentation/widgets/bottom_sheets.dart';
import 'package:reach_me/features/account/presentation/widgets/image_placeholder.dart';
import 'package:reach_me/features/home/presentation/bloc/user-bloc/user_bloc.dart';

class EditProfileScreen extends StatefulHookWidget {
  static const String id = "edit_profile_screen";
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  Future<File?> getImage(ImageSource source) async {
    final _picker = ImagePicker();
    final imageFile = await _picker.pickImage(
      source: source,
      imageQuality: 50,
      maxHeight: 900,
      maxWidth: 600,
    );

    File? result;

    if (imageFile != null) {
      print("::::::::::::: ");
      result = File(imageFile.path);
      try {
        result = await _cropImage(imageFile: result);
        File? image = result;
        return image;
        // }
      } catch (e) {
        // print(e);
      }
    }
    return null;
  }

  Future<File?> getCoverImage(ImageSource source) async {
    final _picker = ImagePicker();
    try {
      final imageFile = await _picker.pickImage(
        source: source,
        imageQuality: 50,
        maxHeight: 900,
        maxWidth: 600,
      );

      if (imageFile != null) {
        File img = File(imageFile.path);
        return img;
      }
    } catch (e) {
      // print(e);
    }
    return null;
  }

  Future<File?> _cropImage({required File imageFile}) async {
    // File croppedImage = await ImageCrop.sampleImage(
    //   file: imageFile,
    //   preferredSize: context.size?.longestSide.ceil(),
    // );
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      cropStyle: CropStyle.circle,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Edit Picture',
          toolbarColor: AppColors.primaryColor,
          toolbarWidgetColor: AppColors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Edit Picture',
        ),
        // WebUiSettings(
        //   context: context,
        // ),
      ],
    );

    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  @override
  Widget build(BuildContext context) {
    final _fullNameController = useTextEditingController(
        text: (globals.user!.firstName! + " " + globals.user!.lastName!)
            .toTitleCase());
    final _bioController =
        useTextEditingController(text: globals.user!.bio ?? '');
    final _usernameController =
        useTextEditingController(text: globals.user!.username ?? "");
    final _locationController =
        useTextEditingController(text: globals.user!.location ?? "");
    var showContactInfo = useState<bool>(globals.user!.showContact ?? false);
    var showLocation = useState<bool>(globals.user!.showLocation ?? false);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocConsumer<UserBloc, UserState>(
        bloc: globals.userBloc,
        listener: (context, state) {
          if (state is UserData) {
            globals.user = state.user;
          } else if (state is UsernameChangeSuccess) {
            globals.user = state.user;
          } else if (state is UserUploadProfilePictureSuccess) {
            globals.user = state.user;
          } else if (state is UserUploadError) {
            Snackbars.error(context, message: state.error);
          }
          if (state is UserError) {
            Snackbars.error(context, message: state.error);
          }
        },
        builder: (context, state) {
          bool _isLoading = state is UserLoading;
          return SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  fit: StackFit.passthrough,
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    /// Banner image
                    GestureDetector(
                      onTap: () async {
                        final image = await getCoverImage(ImageSource.gallery);
                        if (image != null) {
                          globals.userBloc!
                              .add(UploadUserCoverPhotoEvent(file: image));
                        }
                      },
                      child: SizedBox(
                          height: getScreenHeight(200),
                          width: size.width,
                          child: globals.user!.coverPicture != null
                              ? const CoverPicture()
                              : AbsorbPointer(
                                  child: state is UserUploadingCoverImage
                                      ? const Center(
                                          child: CircularProgressIndicator())
                                      : state is UserUploadCoverPictureSuccess
                                          ? const CoverPicture()
                                          : Image.asset(
                                              "assets/images/cover.png",
                                              fit: BoxFit.cover,
                                              gaplessPlayback: true,
                                            ),
                                )),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: SvgPicture.asset(
                                  'assets/svgs/back.svg',
                                  width: getScreenWidth(19),
                                  height: getScreenHeight(14),
                                  color: AppColors.white,
                                ),
                                onPressed: () => RouteNavigators.pop(context),
                              ),
                              IconButton(
                                icon: SvgPicture.asset(
                                  'assets/svgs/pop-vertical.svg',
                                  color: AppColors.white,
                                ),
                                onPressed: () async {
                                  await showEditProfileBottomSheet(context);
                                },
                                splashRadius: 20,
                              )
                            ]).paddingOnly(t: 40),
                        SizedBox(height: getScreenHeight(30)),
                        GestureDetector(
                          onTap: () async {
                            final image = await getImage(ImageSource.gallery);
                            if (image != null) {
                              globals.userBloc!.add(
                                  UploadUserProfilePictureEvent(file: image));
                            }
                          },
                          child: globals.user!.profilePicture != null
                              ? SizedBox(
                                  width: 80,
                                  height: 100,
                                  child: ProfilePicture(
                                      height: getScreenHeight(100),
                                      width: getScreenWidth(100),
                                      border: Border.all(
                                        color: Colors.grey.shade50,
                                        width: 3.0,
                                      )),
                                )
                              : AbsorbPointer(
                                  child: state is UserUploadingImage
                                      ? const Center(
                                          child: CircularProgressIndicator())
                                      : state is UserUploadProfilePictureSuccess
                                          ? ProfilePicture(
                                              height: getScreenHeight(100),
                                              width: getScreenWidth(100),
                                              border: Border.all(
                                                color: Colors.grey.shade50,
                                                width: 3.0,
                                              ))
                                          : ImagePlaceholder(
                                              width: getScreenWidth(100),
                                              height: getScreenHeight(100),
                                              border: Border.all(
                                                color: Colors.grey.shade50,
                                                width: 3.0,
                                              ),
                                            ),
                                ),
                        ),
                      ],
                    ),

                    //PROFILE PICTURE

                    //CHANGE COVER PHOTO
                    Positioned(
                      top: getScreenHeight(130),
                      right: size.width * 0.08,
                      child: GestureDetector(
                        onTap: () async {
                          final image =
                              await getCoverImage(ImageSource.gallery);
                          if (image != null) {
                            globals.userBloc!
                                .add(UploadUserCoverPhotoEvent(file: image));
                          }
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          child: const Icon(
                            Icons.camera_alt,
                            color: AppColors.white,
                            size: 19,
                          ),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ),

                    //CHANGE PROFILE PHOTO
                    Positioned(
                      top: size.height * 0.3 - 45,
                      right: getScreenWidth(170),
                      child: GestureDetector(
                        onTap: () async {
                          final image = await getImage(ImageSource.gallery);
                          if (image != null) {
                            globals.userBloc!.add(
                                UploadUserProfilePictureEvent(file: image));
                          }
                        },
                        child: Container(
                            width: getScreenWidth(25),
                            height: getScreenHeight(25),
                            child: const Icon(
                              Icons.camera_alt,
                              color: AppColors.white,
                              size: 16,
                            ),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryColor,
                            )),
                      ),
                    )
                  ],
                ),
                SizedBox(height: getScreenHeight(70)),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name',
                      style: TextStyle(
                        fontSize: getScreenHeight(15),
                        color: AppColors.textFieldLabelColor,
                      ),
                    ),
                    CustomTextField(
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.sentences,
                      controller: _fullNameController,
                      readOnly: true,
                      isDense: true,
                      validator: (value) => Validator.validateName(value ?? ""),
                      // controller: _emailController,
                    ),
                    SizedBox(height: getScreenHeight(30)),
                    Text(
                      'Username',
                      style: TextStyle(
                        fontSize: getScreenHeight(15),
                        color: AppColors.textFieldLabelColor,
                      ),
                    ),
                    CustomTextField(
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.none,
                      controller: _usernameController,
                      isDense: true,
                      validator: (value) => Validator.validateName(value ?? ""),
                    ),
                    SizedBox(height: getScreenHeight(30)),
                    Text(
                      'Bio',
                      style: TextStyle(
                        fontSize: getScreenHeight(15),
                        color: AppColors.textFieldLabelColor,
                      ),
                    ),
                    CustomTextField(
                      keyboardType: TextInputType.name,
                      maxLength: 200,
                      textCapitalization: TextCapitalization.sentences,
                      validator: (value) => Validator.validateName(value ?? ""),
                      controller: _bioController,
                    ),
                    SizedBox(height: getScreenHeight(30)),
                    Text(
                      'Profile Details',
                      style: TextStyle(
                        fontSize: getScreenHeight(16),
                        fontWeight: FontWeight.w500,
                        color: AppColors.textColor2,
                      ),
                    ),
                    // CupertinoSwitchListTile(
                    //     value: showContactInfo.value,
                    //     dense: true,
                    //     onChanged: (val) {
                    //       showContactInfo.value = !showContactInfo.value;
                    //     },
                    //     title: Text(
                    //       'Contact Info',
                    //       style: TextStyle(
                    //         color: AppColors.textColor2,
                    //         fontWeight: FontWeight.w400,
                    //         fontSize: getScreenHeight(15),
                    //       ),
                    //     ),
                    //     selected: showContactInfo.value,
                    //     trackColor: const Color(0xFFE9E8E8)),
                    CupertinoSwitchListTile(
                        value: showLocation.value,
                        dense: true,
                        onChanged: (val) {
                          showLocation.value = !showLocation.value;
                        },
                        title: Text(
                          'Show Location',
                          style: TextStyle(
                            color: AppColors.textColor2,
                            fontWeight: FontWeight.w400,
                            fontSize: getScreenHeight(15),
                          ),
                        ),
                        selected: showContactInfo.value,
                        trackColor: const Color(0xFFE9E8E8)),
                    TextButton(
                      onPressed: () {
                        RouteNavigators.route(
                            context, const PersonalInfoSettings());
                      },
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      child: Row(
                        children: [
                          Text(
                            'Personal Information Settings',
                            style: TextStyle(
                              fontSize: getScreenHeight(15),
                              fontWeight: FontWeight.w500,
                              color: AppColors.textColor2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: getScreenHeight(40)),
                    CustomButton(
                      label: _isLoading ? 'Saving...' : 'Save',
                      color:
                          _isLoading ? AppColors.grey : AppColors.primaryColor,
                      onPressed: () {
                        if (_bioController.text != globals.user!.bio ||
                            showContactInfo.value !=
                                globals.user!.showContact ||
                            showLocation.value != globals.user!.showLocation ||
                            _locationController.text !=
                                globals.user!.location) {
                          globals.userBloc!.add(UpdateUserProfileEvent(
                            bio: _bioController.text,
                            showContact: showContactInfo.value,
                            showLocation: showLocation.value,
                            location: _locationController.text,
                          ));
                        }
                        if (_usernameController.text !=
                            globals.user!.username) {
                          globals.userBloc!.add(SetUsernameEvent(
                            username:
                                _usernameController.text.replaceAll(' ', ''),
                          ));
                        }
                        _isLoading
                            ? null
                            : Snackbars.success(context,
                                message: "Changes Saved");
                      },
                      size: size,
                      textColor: AppColors.white,
                      borderSide: BorderSide.none,
                    )
                  ],
                ).paddingSymmetric(h: 22)
              ],
            ),
          );
        },
      ),
    );
  }
}
