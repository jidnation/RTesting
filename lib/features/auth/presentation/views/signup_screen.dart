import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reach_me/core/components/custom_button.dart';
import 'package:reach_me/core/components/custom_textfield.dart';
import 'package:reach_me/core/components/snackbar.dart';
import 'package:reach_me/core/helper/logger.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/loader.dart';
import 'package:reach_me/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:reach_me/features/auth/presentation/views/login_screen.dart';
import 'package:reach_me/features/home/home_screen.dart';
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
    final _fNameController = useTextEditingController();
    final _lNameController = useTextEditingController();
    //final _phoneController = useTextEditingController();
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        bloc: globals.authBloc,
        listener: (context, state) {
          if (state is AuthLoaded) {
            Console.log('AuthLoaded', state.message);
          } else if (state is AuthError) {
            Console.log('AuthError', state.error);
            RMSnackBar.showErrorSnackBar(context, message: state.error);
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
                          const Expanded(child: SizedBox()),
                          SvgPicture.asset(
                            'assets/svgs/logo-new.svg',
                            width: size.width * 0.15,
                          ),
                          const SizedBox(height: 40),
                          const Text(
                            'Create an Account',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 7),
                          const Text(
                            'Sign up and own an account',
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColors.textColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 40),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'First Name',
                              style: TextStyle(
                                fontSize: 15,
                                color: AppColors.textFieldLabelColor,
                              ),
                            ),
                          ),
                          CustomTextField(
                            hintText: 'Enter your first name',
                            keyboardType: TextInputType.name,
                            textCapitalization: TextCapitalization.sentences,
                            validator: (value) =>
                                Validator.validateName(value ?? ""),
                            controller: _fNameController,
                          ),
                          const SizedBox(height: 16),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Last Name',
                              style: TextStyle(
                                fontSize: 15,
                                color: AppColors.textFieldLabelColor,
                              ),
                            ),
                          ),
                          CustomTextField(
                            hintText: 'Enter your last name',
                            keyboardType: TextInputType.name,
                            textCapitalization: TextCapitalization.sentences,
                            validator: (value) =>
                                Validator.validateName(value ?? ""),
                            controller: _lNameController,
                          ),
                          const SizedBox(height: 16),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Email',
                              style: TextStyle(
                                fontSize: 15,
                                color: AppColors.textFieldLabelColor,
                              ),
                            ),
                          ),
                          CustomTextField(
                            hintText: 'Enter your email',
                            keyboardType: TextInputType.emailAddress,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) =>
                                Validator.validateEmail(value ?? ""),
                            controller: _emailController,
                          ),
                          const SizedBox(height: 16),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Password (6 or more characters)',
                              style: TextStyle(
                                fontSize: 15,
                                color: AppColors.textFieldLabelColor,
                              ),
                            ),
                          ),
                          CustomTextField(
                            hintText: '********',
                            obscureText: true,
                            keyboardType: TextInputType.text,
                            controller: _passwordController,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) =>
                                Validator.validatePassword(value ?? ""),
                            suffixIcon: const Icon(
                              Icons.visibility_off_outlined,
                              color: AppColors.textFieldLabelColor,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: RichText(
                              textScaleFactor: 0.75,
                              text: const TextSpan(
                                text: "By continuing, you agree to our ",
                                style: TextStyle(
                                  color: AppColors.textColor,
                                  fontSize: 15,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'User Agreement ',
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'and ',
                                    style: TextStyle(
                                      color: AppColors.textColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '.',
                                    style: TextStyle(
                                      color: AppColors.textColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          CustomButton(
                            label: 'Done',
                            color: AppColors.primaryColor,
                            onPressed: () {
                              if (_key.currentState!.validate()) {
                                globals.authBloc!.add(RegisterUserEvent(
                                  email:
                                      _emailController.text.replaceAll(' ', ''),
                                  password: _passwordController.text,
                                  firstName:
                                      _fNameController.text.replaceAll(' ', ''),
                                  lastName:
                                      _lNameController.text.replaceAll(' ', ''),
                                ));
                              } else {
                                return;
                              }
                            },
                            size: size,
                            textColor: AppColors.white,
                            borderSide: BorderSide.none,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Expanded(
                                  child: Divider(
                                      color: AppColors.black,
                                      thickness: 0.5,
                                      height: 0.5,
                                      endIndent: 18.0)),
                              Text('OR',
                                  style: TextStyle(
                                      color: AppColors.textColor,
                                      fontSize: 9.5)),
                              Expanded(
                                  child: Divider(
                                      color: AppColors.black,
                                      thickness: 0.5,
                                      height: 0.5,
                                      indent: 18.0)),
                            ],
                          ),
                          const SizedBox(height: 20),
                          CustomButton(
                              label: 'Continue with Google',
                              prefix: 'assets/svgs/google.svg',
                              color: AppColors.white,
                              onPressed: () {
                                NavigationService.navigateTo(HomeScreen.id);
                              },
                              size: size,
                              textColor: AppColors.primaryColor,
                              borderSide: const BorderSide(
                                  width: 1, color: AppColors.primaryColor)),
                          const Expanded(child: SizedBox()),
                          GestureDetector(
                            onTap: () {
                              NavigationService.navigateTo(LoginScreen.id);
                            },
                            child: RichText(
                              textScaleFactor: 0.8,
                              text: const TextSpan(
                                text: "Already have an acccount? ",
                                style: TextStyle(
                                  color: AppColors.textColor,
                                  fontFamily: 'Poppins',
                                  fontSize: 15,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Login',
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontFamily: 'Poppins',
                                      fontSize: 15,
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
