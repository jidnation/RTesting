import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/components/custom_textfield.dart';
import 'package:reach_me/core/components/list_tile_switch.dart';
import 'package:reach_me/core/components/profile_picture.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/features/account/presentation/views/personal_info_settings.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/core/utils/validator.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class EditProfileScreen extends HookWidget {
  static const String id = "edit_profile_screen";
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var showContactInfo = useState<bool>(false);
    var showLocation = useState<bool>(false);
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            fit: StackFit.passthrough,
            clipBehavior: Clip.none,
            children: <Widget>[
              /// Banner image
              Container(
                height: 150,
                width: size.width,
                padding: const EdgeInsets.only(top: 28),
                child: Image.network(
                  'https://i.pinimg.com/originals/5a/6f/fa/5a6ffa53e1874276e8f042e58510f7c5.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                IconButton(
                    icon: SvgPicture.asset(
                      'assets/svgs/arrow-back.svg',
                      width: 19,
                      height: 12,
                      color: AppColors.white,
                    ),
                    onPressed: () => RouteNavigators.pop(context)),
                IconButton(
                  icon: SvgPicture.asset('assets/svgs/more-vertical.svg',
                      color: AppColors.white),
                  onPressed: () async {
                    //   await showKebabBottomSheet(context);
                  },
                  splashRadius: 20,
                )
              ]).paddingOnly(t: 25),

              //PROFILE PICTURE
              Positioned(
                top: size.height * 0.11,
                child: ProfilePicture(
                  width: 100,
                  height: 100,
                  border: Border.all(color: AppColors.white, width: 3.0),
                ),
              ),

              //CHANGE COVER PHOTO
              Positioned(
                top: size.height * 0.155,
                right: size.width * 0.08,
                child: GestureDetector(
                  onTap: () {
                    debugPrint('tapped on change cover photo ');
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
                      )),
                ),
              ),

              //CHANGE PROFILE PHOTO
              Positioned(
                top: size.height * 0.19,
                right: size.width * 0.37,
                child: GestureDetector(
                  onTap: () {
                    debugPrint('tapped on change profile photo ');
                  },
                  child: Container(
                      width: 25,
                      height: 25,
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
          const SizedBox(height: 70),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Name',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textFieldLabelColor,
                ),
              ),
              CustomTextField(
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.sentences,
                hintText:
                    (globals.user!.firstName! + ' ' + globals.user!.lastName!)
                        .toTitleCase(),
                validator: (value) => Validator.validateName(value ?? ""),
                // controller: _emailController,
              ),
              const SizedBox(height: 30),
              const Text(
                'Username',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textFieldLabelColor,
                ),
              ),
              CustomTextField(
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.none,
                hintText:  globals.user!.username ?? 'no username',
                validator: (value) => Validator.validateName(value ?? ""),
                // controller: _emailController,
              ),
              const SizedBox(height: 30),
              const Text(
                'Bio',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textFieldLabelColor,
                ),
              ),
              CustomTextField(
                keyboardType: TextInputType.name,
                maxLength: 250,
                textCapitalization: TextCapitalization.none,
                validator: (value) => Validator.validateName(value ?? ""),
                // controller: _emailController,
              ),
              const SizedBox(height: 30),
             
              const Text(
                'Profile Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor2,
                ),
              ),
              CupertinoSwitchListTile(
                  value: showContactInfo.value,
                  dense: true,
                  onChanged: (val) {
                    showContactInfo.value = !showContactInfo.value;
                  },
                  title: const Text(
                    'Contact Info',
                    style: TextStyle(
                      color: AppColors.textColor2,
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ),
                  ),
                  selected: showContactInfo.value,
                  trackColor: const Color(0xFFE9E8E8)),
              CupertinoSwitchListTile(
                  value: showLocation.value,
                  dense: true,
                  onChanged: (val) {
                    showLocation.value = !showLocation.value;
                  },
                  title: const Text(
                    'Show Location',
                    style: TextStyle(
                      color: AppColors.textColor2,
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ),
                  ),
                  selected: showContactInfo.value,
                  trackColor: const Color(0xFFE9E8E8)),
              TextButton(
                onPressed: () {
                  RouteNavigators.route(context, const PersonalInfoSettings());
                },
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Row(
                  children: const [
                    Text(
                      'Personal Information Settings',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textColor2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ).paddingSymmetric(h: 22)
        ],
      ),
    ));
  }
}
