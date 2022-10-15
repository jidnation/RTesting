import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:reach_me/core/components/custom_button.dart';
import 'package:reach_me/core/components/custom_textfield.dart';
import 'package:reach_me/core/components/snackbar.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:reach_me/features/auth/presentation/views/forgot_password.dart';
import 'package:reach_me/features/auth/presentation/views/signup_screen.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:reach_me/features/home/presentation/views/home_screen.dart';

class LoginScreen extends HookWidget {
  static const String id = 'login_screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _emailController = useTextEditingController();
    final _passwordController = useTextEditingController();
    final _key = useState<GlobalKey<FormState>>(GlobalKey());
    var size = MediaQuery.of(context).size;
    final _obscureText = useState(true);
    return Scaffold(
        backgroundColor: AppColors.white,
        body: BlocConsumer<AuthBloc, AuthState>(
            bloc: globals.authBloc,
            listener: (context, state) {
              if (state is Authenticated) {
                RouteNavigators.route(context, const HomeScreen());
              } else if (state is AuthError) {
                Snackbars.error(context, message: state.error);
              }
            },
            builder: (context, state) {
              bool _isLoading = state is AuthLoading;
              return SizedBox(
                width: size.width,
                height: size.height,
                child: CustomScrollView(slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 25.0, right: 25.0, top: 50.0, bottom: 30.0),
                      child: Form(
                        key: _key.value,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: getScreenHeight(35)),
                            SvgPicture.asset(
                              'assets/svgs/login.svg',
                              width: size.width * 0.60,
                            ),
                            SizedBox(height: getScreenHeight(35)),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Email',
                                style: TextStyle(
                                  fontSize: getScreenHeight(18),
                                  color: AppColors.textColor2,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(height: getScreenHeight(10)),
                            CustomRoundTextField(
                              hintText: 'linda@framcreative.com',
                              keyboardType: TextInputType.emailAddress,
                              textCapitalization: TextCapitalization.none,
                              hintStyle: TextStyle(
                                fontSize: getScreenHeight(18),
                                fontWeight: FontWeight.w400,
                              ),
                              validator: (value) =>
                                  Validator.validateEmail(value ?? ""),
                              controller: _emailController,
                            ),
                            SizedBox(height: getScreenHeight(15)),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    'Password',
                                    style: TextStyle(
                                      fontSize: getScreenHeight(18),
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
                                                      size: 23,
                                                      color: AppColors
                                                          .textFieldLabelColor,
                                                    )
                                                  : const Icon(
                                                      Icons.visibility,
                                                      size: 23,
                                                      color: AppColors
                                                          .primaryColor,
                                                    ),
                                            ),
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Show',
                                          style: TextStyle(
                                            fontSize: getScreenHeight(18),
                                            color: AppColors.textColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                            SizedBox(height: getScreenHeight(10)),
                            CustomRoundTextField(
                              maxLines: 1,
                              obscureText: _obscureText.value,
                              keyboardType: TextInputType.text,
                              controller: _passwordController,
                              textCapitalization: TextCapitalization.none,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () => RouteNavigators.route(
                                  context,
                                  const ForgotPasswordScreen(),
                                ),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4.0,
                                    vertical: 0.0,
                                  ),
                                ),
                                child: Text(
                                  'Forgot password',
                                  style: TextStyle(
                                    fontSize: getScreenHeight(17),
                                    color: AppColors.textColor2,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: getScreenHeight(20)),
                            CustomButton(
                              label: 'Login',
                              color: AppColors.buttonColor,
                              isLoading: _isLoading,
                              loaderColor: AppColors.white,
                              onPressed: !_isLoading
                                  ? () {
                                      if (_key.value.currentState!.validate()) {
                                        globals.authBloc!.add(LoginUserEvent(
                                          email: _emailController.text
                                              .replaceAll(' ', ''),
                                          password: _passwordController.text,
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
                            GestureDetector(
                              onTap: () => RouteNavigators.route(
                                context,
                                SignUpScreen(),
                              ),
                              child: RichText(
                                textScaleFactor: 0.8,
                                text: TextSpan(
                                  text: "Do not have an account? ",
                                  style: TextStyle(
                                    color: AppColors.textColor,
                                    fontFamily: 'Poppins',
                                    fontSize: getScreenHeight(18),
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Sign up',
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontSize: getScreenHeight(18),
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ).paddingOnly(t: 25),
                          ],
                        ),
                      ),
                    ),
                  ),
                ]),
              );
            }));
  }
}
