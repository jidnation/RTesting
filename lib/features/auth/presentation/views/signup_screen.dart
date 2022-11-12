import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reach_me/core/components/custom_button.dart';
import 'package:reach_me/core/components/custom_textfield.dart';
import 'package:reach_me/core/components/snackbar.dart';
import 'package:reach_me/core/helper/logger.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/dimensions.dart';
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
    String _obscureString;
    final _obscureText = useState(true);
    if (_obscureText.value) {
      _obscureString = 'Show';
    } else {
      _obscureString = 'Hide';
    }
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        bloc: globals.authBloc,
        listener: (context, state) {
          if (state is AuthRegisterLoaded) {
            RouteNavigators.route(context,
                OtpScreen(email: _emailController.text.replaceAll(' ', '')));
          } else if (state is AuthError) {
            Console.log('AuthError', state.error);
            if (state.error!.contains('activate')) {
              RouteNavigators.route(context,
                  OtpScreen(email: _emailController.text.replaceAll(' ', '')));
              return;
            } else {
              Snackbars.error(context, message: state.error);
            }
          }
        },
        builder: (context, state) {
          bool _isLoading = state is AuthLoading;
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
                          SizedBox(height: getScreenHeight(40)),
                          // SvgPicture.asset(
                          //   'assets/svgs/logo-blue.svg',
                          //   width: getScreenWidth(50),
                          //   height: getScreenHeight(60),
                          // ),
                          // SizedBox(height: getScreenHeight(40)),
                          Text(
                            'Create an Account',
                            style: TextStyle(
                              fontSize: getScreenHeight(20),
                              fontWeight: FontWeight.w500,
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
                                  fontSize: getScreenHeight(16),
                                  fontFamily: 'Poppins',
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Agreement ',
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: getScreenHeight(16),
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'and ',
                                    style: TextStyle(
                                      color: AppColors.textColor,
                                      fontSize: getScreenHeight(16),
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: getScreenHeight(16),
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  TextSpan(
                                    text: '.',
                                    style: TextStyle(
                                      color: AppColors.textColor,
                                      fontSize: getScreenHeight(16),
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: getScreenHeight(40)),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'First Name',
                              style: TextStyle(
                                fontSize: getScreenHeight(15),
                                color: AppColors.textColor2,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          CustomRoundTextField(
                            focusedBorderSide: const BorderSide(
                                color: Colors.black12,
                                width: 1,
                                style: BorderStyle.solid),
                            enabledBorderSide: const BorderSide(
                                color: Colors.black12,
                                width: 1,
                                style: BorderStyle.solid),
                            isFilled: false,
                            hintText: '',
                            keyboardType: TextInputType.name,
                            textCapitalization: TextCapitalization.words,
                            validator: (value) =>
                                Validator.fullNameValidate(value ?? ""),
                            controller: _firstNameController,
                          ),
                          SizedBox(height: getScreenHeight(16)),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Last Name',
                              style: TextStyle(
                                fontSize: getScreenHeight(15),
                                color: AppColors.textColor2,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          CustomRoundTextField(
                            focusedBorderSide: const BorderSide(
                                color: Colors.black12,
                                width: 1,
                                style: BorderStyle.solid),
                            enabledBorderSide: const BorderSide(
                                color: Colors.black12,
                                width: 1,
                                style: BorderStyle.solid),
                            isFilled: false,
                            hintText: '',
                            keyboardType: TextInputType.name,
                            textCapitalization: TextCapitalization.words,
                            validator: (value) =>
                                Validator.fullNameValidate(value ?? ""),
                            controller: _lastNameController,
                          ),
                          SizedBox(height: getScreenHeight(16)),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Email',
                              style: TextStyle(
                                fontSize: getScreenHeight(15),
                                color: AppColors.textColor2,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          CustomRoundTextField(
                            focusedBorderSide: const BorderSide(
                                color: Colors.black12,
                                width: 1,
                                style: BorderStyle.solid),
                            enabledBorderSide: const BorderSide(
                                color: Colors.black12,
                                width: 1,
                                style: BorderStyle.solid),
                            isFilled: false,
                            hintText: 'linda@framcreative.com',
                            keyboardType: TextInputType.emailAddress,
                            textCapitalization: TextCapitalization.none,
                            hintStyle: TextStyle(
                              color: Colors.black26,
                              fontSize: getScreenHeight(15),
                              fontWeight: FontWeight.w400,
                            ),
                            validator: (value) =>
                                Validator.validateEmail(value ?? ""),
                            controller: _emailController,
                          ),
                          SizedBox(height: getScreenHeight(16)),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  'Password',
                                  style: TextStyle(
                                    fontSize: getScreenHeight(15),
                                    color: AppColors.textColor2,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: <InlineSpan>[
                                      WidgetSpan(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5.0, right: 5.0),
                                          child: GestureDetector(
                                            onTap: () => _obscureText.value =
                                                !_obscureText.value,
                                            child: _obscureText.value
                                                ? const Icon(
                                                    Icons
                                                        .visibility_off_outlined,
                                                    size: 15,
                                                    color: AppColors
                                                        .textFieldLabelColor,
                                                  )
                                                : const Icon(
                                                    Icons.visibility,
                                                    size: 15,
                                                    color:
                                                        AppColors.primaryColor,
                                                  ),
                                          ),
                                        ),
                                      ),
                                      TextSpan(
                                        text: _obscureString,
                                        style: TextStyle(
                                          fontSize: getScreenHeight(13),
                                          color: AppColors.textColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                          SizedBox(height: getScreenHeight(5)),
                          CustomRoundTextField(
                            focusedBorderSide: const BorderSide(
                                color: Colors.black12,
                                width: 1,
                                style: BorderStyle.solid),
                            enabledBorderSide: const BorderSide(
                                color: Colors.black12,
                                width: 1,
                                style: BorderStyle.solid),
                            isFilled: false,
                            maxLines: 1,
                            obscureText: _obscureText.value,
                            keyboardType: TextInputType.text,
                            controller: _passwordController,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) =>
                                Validator.validatePassword(value ?? ""),
                          ),
                          SizedBox(height: getScreenHeight(8)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      children: <InlineSpan>[
                                        TextSpan(
                                          text: '• minimum 8 characters',
                                          style: TextStyle(
                                            fontSize: getScreenHeight(12),
                                            color: AppColors.textColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      children: <InlineSpan>[
                                        TextSpan(
                                          text: '• one special character',
                                          style: TextStyle(
                                            fontSize: getScreenHeight(12),
                                            color: AppColors.textColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      children: <InlineSpan>[
                                        TextSpan(
                                          text: '• one number',
                                          style: TextStyle(
                                            fontSize: getScreenHeight(12),
                                            color: AppColors.textColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      children: <InlineSpan>[
                                        TextSpan(
                                          text: '• one uppercase character',
                                          style: TextStyle(
                                            fontSize: getScreenHeight(12),
                                            color: AppColors.textColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      children: <InlineSpan>[
                                        TextSpan(
                                          text: '• one lowercase character',
                                          style: TextStyle(
                                            fontSize: getScreenHeight(12),
                                            color: AppColors.textColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: getScreenHeight(40)),
                          CustomButton(
                            label: 'Done',
                            color: AppColors.buttonColor,
                            loaderColor: AppColors.white,
                            isLoading: _isLoading,
                            onPressed: !_isLoading
                                ? () {
                                    if (_key.currentState!.validate()) {
                                      final firstName =
                                          _firstNameController.text.trim();
                                      final lastName =
                                          _lastNameController.text.trim();
                                      globals.authBloc!.add(RegisterUserEvent(
                                        email: _emailController.text
                                            .replaceAll(' ', ''),
                                        password: _passwordController.text,
                                        firstName: firstName,
                                        lastName: lastName,
                                      ));
                                    } else {
                                      return;
                                    }
                                  }
                                : () {},
                            size: size,
                            textColor: AppColors.white,
                            borderSide: BorderSide.none,
                          ),
                          SizedBox(height: getScreenHeight(20)),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: const [
                          //     Text('Or',
                          //         style: TextStyle(
                          //             color: AppColors.textColor,
                          //             fontSize: 15)),
                          //   ],
                          // ),
                          // SizedBox(height: getScreenHeight(20)),
                          // CustomButton(
                          //     label: 'Sign in with Google',
                          //     prefix: 'assets/svgs/google.svg',
                          //     color: AppColors.white,
                          //     onPressed: () {
                          //       toast('Coming soon');
                          //     },
                          //     size: size,
                          //     textColor: AppColors.textColor2,
                          //     borderSide: const BorderSide(
                          //       width: 1,
                          //       color: AppColors.greyShade1,
                          //     )),
                          // SizedBox(height: getScreenHeight(20)),
                          // CustomButton(
                          //     label: 'Sign in with Apple',
                          //     prefix: 'assets/svgs/apple.svg',
                          //     color: AppColors.white,
                          //     onPressed: () {
                          //       toast('Coming soon');
                          //     },
                          //     size: size,
                          //     textColor: AppColors.textColor2,
                          //     borderSide: const BorderSide(
                          //       width: 1,
                          //       color: AppColors.greyShade1,
                          //     )),
                          // SizedBox(height: getScreenHeight(30)),
                          GestureDetector(
                            onTap: () {
                              RouteNavigators.route(
                                  context, const LoginScreen());
                            },
                            child: RichText(
                              textScaleFactor: 0.8,
                              text: TextSpan(
                                text: "Already have an acccount? ",
                                style: TextStyle(
                                  color: AppColors.textColor,
                                  fontFamily: 'Poppins',
                                  fontSize: getScreenHeight(17),
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Login',
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontFamily: 'Poppins',
                                      fontSize: getScreenHeight(18),
                                      fontWeight: FontWeight.w500,
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
