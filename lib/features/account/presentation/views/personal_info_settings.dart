import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/components/custom_button.dart';
import 'package:reach_me/core/components/custom_textfield.dart';
import 'package:reach_me/core/components/snackbar.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/core/utils/loader.dart';
import 'package:reach_me/core/utils/validator.dart';
import 'package:reach_me/features/home/presentation/bloc/user_bloc.dart';
import 'package:reach_me/features/home/presentation/views/home_screen.dart';

class PersonalInfoSettings extends StatefulHookWidget {
  static const String id = 'personal_info_settings';
  const PersonalInfoSettings({Key? key}) : super(key: key);

  @override
  State<PersonalInfoSettings> createState() => _PersonalInfoSettingsState();
}

class _PersonalInfoSettingsState extends State<PersonalInfoSettings> {
  List<String> gender = ['Male', 'Female'];

  String selectedBirthday = '';
  String showBirthday = '';
  final _birthDayController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _birthDayController.text = showBirthday;
  }

  @override
  void dispose() {
    _birthDayController.dispose();
    super.dispose();
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
                // selectedBirthday = Helper.parseDate(value);
                selectedBirthday = value.toIso8601String();
                showBirthday = value.toIso8601String().substring(0, 10);
                _birthDayController.text = showBirthday;
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final _emailController =
        useTextEditingController(text: globals.user!.email);
    final _phoneController = useTextEditingController();
    final _genderController =
        useTextEditingController(text: globals.user!.gender ?? '');
    final currentSelectedGender = useState<String?>('Male');
    final tappedDropdown = useState<bool>(false);
    return Scaffold(
      body: BlocConsumer<UserBloc, UserState>(
          bloc: globals.userBloc,
          listener: (context, state) {
            if (state is UserData) {
              globals.user = state.user;
              RouteNavigators.routeNoWayHome(context, const HomeScreen());
            } else if (state is UserError) {
              RMSnackBar.showErrorSnackBar(context, message: state.error);
            }
          },
          builder: (context, state) {
            if (state is UserLoading) {
              return const RLoader('');
            }
            return SafeArea(
              child: Container(
                width: size.width,
                height: size.height,
                color: AppColors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          IconButton(
                              icon: SvgPicture.asset(
                                'assets/svgs/back.svg',
                                width: getScreenWidth(19),
                                height: getScreenHeight(12),
                                color: AppColors.black,
                              ),
                              onPressed: () => RouteNavigators.pop(context)),
                          SizedBox(width: getScreenWidth(15)),
                          Text(
                            'Personal Information',
                            style: TextStyle(
                              fontSize: getScreenHeight(16),
                              fontWeight: FontWeight.w600,
                              color: AppColors.textColor2,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: getScreenHeight(20)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "The information here won't be part of your public profile.",
                            style: TextStyle(
                              fontSize: getScreenHeight(15),
                              fontWeight: FontWeight.w400,
                              color: AppColors.greyShade2,
                            ),
                          ),
                          SizedBox(height: getScreenHeight(30)),
                          Text(
                            'Email',
                            style: TextStyle(
                              fontSize: getScreenHeight(15),
                              color: AppColors.textFieldLabelColor,
                            ),
                          ),
                          CustomTextField(
                            isDense: false,
                            keyboardType: TextInputType.emailAddress,
                            textCapitalization: TextCapitalization.none,
                            controller: _emailController,
                            readOnly: true,
                          ),
                          SizedBox(height: getScreenHeight(30)),
                          Text(
                            'Phone',
                            style: TextStyle(
                              fontSize: getScreenHeight(15),
                              color: AppColors.textFieldLabelColor,
                            ),
                          ),
                          CustomTextField(
                            maxLength: 11,
                            isDense: false,
                            hintText: '+234',
                            readOnly: true,
                            textCapitalization: TextCapitalization.none,
                            keyboardType: TextInputType.phone,
                            controller: _phoneController,
                            validator: (value) =>
                                Validator.validatePhoneNumber(value ?? ""),
                          ),
                          SizedBox(height: getScreenHeight(30)),
                          Text(
                            'Gender',
                            style: TextStyle(
                              fontSize: getScreenHeight(15),
                              color: AppColors.textFieldLabelColor,
                            ),
                          ),
                          if (globals.user!.gender == null)
                            FormField<String>(
                              builder: (FormFieldState<String> state) {
                                return InputDecorator(
                                  decoration: InputDecoration(
                                    hintStyle: const TextStyle(
                                        color: AppColors.textColor2),
                                    labelStyle: TextStyle(
                                      fontSize: getScreenHeight(15),
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.textColor2,
                                    ),
                                    errorStyle: TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: getScreenHeight(15),
                                    ),
                                    hintText: 'Select Gender',
                                    border: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColors.black,
                                            width: 0.5)),
                                    enabledBorder: const UnderlineInputBorder(
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
                                        style: TextStyle(
                                            color: AppColors.textColor2),
                                      ),
                                      style: TextStyle(
                                        color: AppColors.textColor2,
                                        fontSize: getScreenHeight(15),
                                      ),
                                      dropdownColor: AppColors.white,
                                      icon: const Icon(
                                        Icons.keyboard_arrow_down_outlined,
                                        color: AppColors.textColor2,
                                      ),
                                      onChanged: (String? newValue) {
                                        if (newValue != null) {
                                          currentSelectedGender.value =
                                              newValue;
                                          state.didChange(newValue);
                                          tappedDropdown.value = true;
                                        }
                                      },
                                      items: gender
                                          .map<DropdownMenuItem<String>>(
                                              (value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: TextStyle(
                                              fontSize: getScreenHeight(15),
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
                            )
                          else
                            CustomTextField(
                              isDense: true,
                              keyboardType: TextInputType.name,
                              textCapitalization: TextCapitalization.none,
                              controller: _genderController,
                              readOnly: true,
                            ),
                          SizedBox(height: getScreenHeight(30)),
                          Text(
                            'Birthday',
                            style: TextStyle(
                              fontSize: getScreenHeight(15),
                              color: AppColors.textFieldLabelColor,
                            ),
                          ),
                          SizedBox(height: getScreenHeight(4)),
                          GestureDetector(
                            onTap: () {
                              _showDatePicker();
                            },
                            child: AbsorbPointer(
                              child: CustomTextField(
                                isDense: false,
                                hintText: globals.user!.dateofBirth == null
                                    ? 'Select Birthday'
                                    : globals.user!.dateofBirth!
                                        .toIso8601String()
                                        .substring(0, 10),
                                textCapitalization: TextCapitalization.none,
                                controller: _birthDayController,
                              ),
                            ),
                          ),
                          SizedBox(height: getScreenHeight(40)),
                          CustomButton(
                            label: 'Save',
                            color: AppColors.primaryColor,
                            onPressed: () {
                              globals.userBloc!.add(UpdateUserProfileEvent(
                                dateOfBirth: selectedBirthday,
                                gender:
                                    currentSelectedGender.value!.toLowerCase(),
                              ));
                            },
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
            );
          }),
    );
  }
}
