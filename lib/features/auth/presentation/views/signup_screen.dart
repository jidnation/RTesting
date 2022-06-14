import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reach_me/core/components/custom_button.dart';
import 'package:reach_me/core/components/custom_textfield.dart';
import 'package:reach_me/core/components/snackbar.dart';
import 'package:reach_me/core/helper/logger.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/core/utils/loader.dart';
import 'package:reach_me/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:reach_me/features/auth/presentation/views/login_screen.dart';
import 'package:reach_me/features/auth/presentation/views/otp_screen.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/validator.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends HookWidget {
  static const String id = 'signup_screen';
  SignUpScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final _emailController = useTextEditingController();
    final _passwordController = useTextEditingController();
    final _firstNameController = useTextEditingController();
    final _lastNameController = useTextEditingController();
    final _obscureText = useState(true);
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        bloc: globals.authBloc,
        listener: (context, state) {
          if (state is AuthRegisterLoaded) {
            RouteNavigators.route(context,
                OtpScreen(email: _emailController.text.replaceAll(' ', '')));
          } else if (state is AuthError) {
            Console.log('AuthError', state.error);
            Snackbars.error(context, message: state.error);
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const RLoader('');
          }
          return Container(
            width: size.width,
            height: size.height,
            color: AppColors.white,
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 25.0, right: 25.0, top: 40.0, bottom: 20.0),
                    child: Form(
                      key: _key,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: getScreenHeight(50)),
                          SvgPicture.asset(
                            'assets/svgs/logo-blue.svg',
                            width: 36,
                          ),
                          SizedBox(height: getScreenHeight(40)),
                          Text(
                            'Create an Account',
                            style: TextStyle(
                              fontSize: getScreenHeight(20),
                              fontWeight: FontWeight.w600,
                              color: AppColors.textColor2,
                            ),
                          ),
                          SizedBox(height: getScreenHeight(10)),
                          Align(
                            alignment: Alignment.center,
                            child: RichText(
                              textScaleFactor: 0.8,
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: "By continuing, you agree to our User\n ",
                                style: TextStyle(
                                  color: AppColors.textColor,
                                  fontSize: getScreenHeight(15),
                                  fontFamily: 'Poppins',
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Agreement ',
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: getScreenHeight(15),
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'and ',
                                    style: TextStyle(
                                      color: AppColors.textColor,
                                      fontSize: getScreenHeight(15),
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: getScreenHeight(15),
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  TextSpan(
                                    text: '.',
                                    style: TextStyle(
                                      color: AppColors.textColor,
                                      fontSize: getScreenHeight(15),
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: getScreenHeight(40)),
                          CustomRoundTextField(
                            hintText: 'First name',
                            keyboardType: TextInputType.name,
                            textCapitalization: TextCapitalization.words,
                            validator: (value) =>
                                Validator.fullNameValidate(value ?? ""),
                            controller: _firstNameController,
                          ),
                          SizedBox(height: getScreenHeight(16)),
                          CustomRoundTextField(
                            hintText: 'Last name',
                            keyboardType: TextInputType.name,
                            textCapitalization: TextCapitalization.words,
                            validator: (value) =>
                                Validator.fullNameValidate(value ?? ""),
                            controller: _lastNameController,
                          ),
                          SizedBox(height: getScreenHeight(16)),
                          CustomRoundTextField(
                            hintText: 'Email',
                            keyboardType: TextInputType.emailAddress,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) =>
                                Validator.validateEmail(value ?? ""),
                            controller: _emailController,
                          ),
                          SizedBox(height: getScreenHeight(16)),
                          CustomRoundTextField(
                            maxLines: 1,
                            hintText: 'Password',
                            obscureText: _obscureText.value,
                            keyboardType: TextInputType.text,
                            controller: _passwordController,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) =>
                                Validator.validatePassword(value ?? ""),
                            suffixIcon: GestureDetector(
                              onTap: () =>
                                  _obscureText.value = !_obscureText.value,
                              child: _obscureText.value
                                  ? const Icon(
                                      Icons.visibility_off_outlined,
                                      color: AppColors.textFieldLabelColor,
                                    )
                                  : const Icon(
                                      Icons.visibility,
                                      color: AppColors.primaryColor,
                                    ),
                            ),
                          ),
                          SizedBox(height: getScreenHeight(40)),
                          CustomButton(
                            label: 'Done',
                            color: AppColors.textColor2,
                            onPressed: () {
                              if (_key.currentState!.validate()) {
                                final firstName =
                                    _firstNameController.text.trim();
                                final lastName =
                                    _lastNameController.text.trim();
                                globals.authBloc!.add(RegisterUserEvent(
                                  email:
                                      _emailController.text.replaceAll(' ', ''),
                                  password: _passwordController.text,
                                  firstName: firstName,
                                  lastName: lastName,
                                ));
                              } else {
                                return;
                              }
                            },
                            size: size,
                            textColor: AppColors.white,
                            borderSide: BorderSide.none,
                          ),
                          SizedBox(height: getScreenHeight(20)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Expanded(
                                child: Divider(
                                  color: AppColors.black,
                                  thickness: 0.5,
                                  height: 0.5,
                                  endIndent: 18.0,
                                ),
                              ),
                              Text(
                                'OR',
                                style: TextStyle(
                                  color: AppColors.textColor,
                                  fontSize: 9.5,
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: AppColors.black,
                                  thickness: 0.5,
                                  height: 0.5,
                                  indent: 18.0,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: getScreenHeight(20)),
                          CustomButton(
                              label: 'Continue with Google',
                              prefix: 'assets/svgs/google.svg',
                              color: AppColors.white,
                              onPressed: () {
                                // RouteNavigators.route(
                                //     context, const HomeScreen());
                              },
                              size: size,
                              textColor: AppColors.textColor2,
                              borderSide: const BorderSide(
                                width: 1,
                                color: AppColors.textColor2,
                              )),
                          SizedBox(height: getScreenHeight(20)),
                          GestureDetector(
                            onTap: () {
                              RouteNavigators.route(context, LoginScreen());
                            },
                            child: RichText(
                              textScaleFactor: 0.8,
                              text: TextSpan(
                                text: "Already have an acccount? ",
                                style: TextStyle(
                                  color: AppColors.textColor,
                                  fontFamily: 'Poppins',
                                  fontSize: getScreenHeight(15),
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Login',
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontFamily: 'Poppins',
                                      fontSize: getScreenHeight(15),
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
