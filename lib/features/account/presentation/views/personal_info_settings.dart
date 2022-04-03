import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/components/custom_button.dart';
import 'package:reach_me/core/components/custom_textfield.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/core/utils/helpers.dart';
import 'package:reach_me/core/utils/validator.dart';

class PersonalInfoSettings extends StatefulHookWidget {
  static const String id = 'personal_info_settings';
  const PersonalInfoSettings({Key? key}) : super(key: key);

  @override
  State<PersonalInfoSettings> createState() => _PersonalInfoSettingsState();
}

class _PersonalInfoSettingsState extends State<PersonalInfoSettings> {
  List<String> gender = ['Male', 'Female', 'Prefer not say'];

  String selectedBirthday = '';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final _emailController =
        useTextEditingController(text: globals.user!.email);
    final _phoneController = useTextEditingController();
    final _birthDayController =
        useTextEditingController(text: selectedBirthday);
    final currentSelectedGender = useState<String?>('Male');
    final tappedDropdown = useState<bool>(false);
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          color: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    IconButton(
                        icon: SvgPicture.asset(
                          'assets/svgs/arrow-back.svg',
                          width: 19,
                          height: 12,
                          color: AppColors.black,
                        ),
                        onPressed: () => RouteNavigators.pop(context)),
                    const SizedBox(width: 15),
                    const Text('Personal Information',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor2,
                        )),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "The information here won't be part of your public profile.",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: AppColors.greyShade2,
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textFieldLabelColor,
                      ),
                    ),
                    CustomTextField(
                      isDense: false,
                      keyboardType: TextInputType.emailAddress,
                      textCapitalization: TextCapitalization.none,
                      validator: (value) =>
                          Validator.validateEmail(value ?? ""),
                      controller: _emailController,
                      readOnly: true,
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Phone',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textFieldLabelColor,
                      ),
                    ),
                    CustomTextField(
                      maxLength: 11,
                      isDense: false,
                      hintText: '+234',
                      textCapitalization: TextCapitalization.none,
                      keyboardType: TextInputType.phone,
                      controller: _phoneController,
                      validator: (value) =>
                          Validator.validatePhoneNumber(value ?? ""),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Gender',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textFieldLabelColor,
                      ),
                    ),
                    FormField<String>(
                      builder: (FormFieldState<String> state) {
                        return InputDecorator(
                          decoration: const InputDecoration(
                            hintStyle: TextStyle(color: AppColors.textColor2),
                            labelStyle: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textColor2,
                            ),
                            errorStyle: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 15,
                            ),
                            hintText: 'Select Gender',
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.black, width: 0.5)),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors.black, width: 0.5),
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: !tappedDropdown.value
                                  ? null
                                  : currentSelectedGender.value,
                              isDense: true,
                              isExpanded: true,
                              elevation: 1,
                              hint: const Text(
                                'Select Gender',
                                style: TextStyle(color: AppColors.textColor2),
                              ),
                              style: const TextStyle(
                                color: AppColors.textColor2,
                                fontSize: 15,
                              ),
                              dropdownColor: AppColors.white,
                              icon: const Icon(
                                Icons.keyboard_arrow_down_outlined,
                                color: AppColors.textColor2,
                              ),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  currentSelectedGender.value = newValue;
                                  state.didChange(newValue);
                                  tappedDropdown.value = true;
                                }
                              },
                              items:
                                  gender.map<DropdownMenuItem<String>>((value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.textColor2,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Birthday',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textFieldLabelColor,
                      ),
                    ),
                    const SizedBox(height: 3),
                    GestureDetector(
                      onTap: () {
                        _showDatePicker();
                      },
                      child: AbsorbPointer(
                        child: CustomTextField(
                          isDense: false,
                          hintText: 'Select Birthday',
                          textCapitalization: TextCapitalization.none,
                          controller: _birthDayController,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    CustomButton(
                      label: 'Save',
                      color: AppColors.primaryColor,
                      onPressed: () {},
                      size: size,
                      textColor: AppColors.white,
                      borderSide: BorderSide.none,
                    )
                  ],
                ).paddingSymmetric(h: 13),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDatePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: MediaQuery.of(context).copyWith().size.height * 0.25,
          color: Colors.white,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged: (value) {
              setState(() {
                selectedBirthday = Helper.parseDate(value);
              });
            },
            initialDateTime: DateTime.now(),
            minimumYear: 1930,
            maximumYear: DateTime.now().year,
          ),
        );
      },
    );
  }
}
