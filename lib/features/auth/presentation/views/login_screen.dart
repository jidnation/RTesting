import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/components/custom_button.dart';
import 'package:reach_me/core/components/custom_textfield.dart';
import 'package:reach_me/core/components/snackbar.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/core/utils/loader.dart';
import 'package:reach_me/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:reach_me/features/auth/presentation/views/forgot_password.dart';
import 'package:reach_me/features/auth/presentation/views/signup_screen.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:reach_me/features/home/presentation/views/home_screen.dart';

class LoginScreen extends HookWidget {
  static const String id = 'login_screen';
  LoginScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final _emailController = useTextEditingController();
    final _passwordController = useTextEditingController();
    var size = MediaQuery.of(context).size;
    final _obscureText = useState(true);
    return Scaffold(
        backgroundColor: AppColors.white,
        body: BlocConsumer<AuthBloc, AuthState>(
            bloc: globals.authBloc,
            listener: (context, state) {
              if (state is Authenticated) {
                //TODO: CHANGE NAV TO HOME
                RouteNavigators.route(context, const HomeScreen());
              } else if (state is AuthError) {
                RMSnackBar.showErrorSnackBar(context, message: state.error);
              }
            },
            builder: (context, state) {
              if (state is AuthLoading) {
                return const RLoader('');
              }
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
                        key: _key,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 35),
                            SvgPicture.asset(
                              'assets/svgs/login.svg',
                              width: size.width * 0.35,
                            ),
                            const SizedBox(height: 30),
                            const Text(
                              'Welcome Back',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textColor2,
                              ),
                            ),
                            const SizedBox(height: 7),
                            const Text(
                              'Login to your account',
                              style: TextStyle(
                                fontSize: 15,
                                color: AppColors.textColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 40),
                            CustomRoundTextField(
                              hintText: 'Email',
                              keyboardType: TextInputType.emailAddress,
                              textCapitalization: TextCapitalization.none,
                              validator: (value) =>
                                  Validator.validateEmail(value ?? ""),
                              controller: _emailController,
                            ),
                            const SizedBox(height: 15),
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
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () => RouteNavigators.route(
                                    context, const ForgotPasswordScreen()),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0, vertical: 0.0),
                                ),
                                child: const Text(
                                  'Forgot password',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: AppColors.textColor2,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            CustomButton(
                              label: 'Done',
                              color: AppColors.textColor2,
                              onPressed: () {
                                if (_key.currentState!.validate()) {
                                  globals.authBloc!.add(LoginUserEvent(
                                    email: _emailController.text
                                        .replaceAll(' ', ''),
                                    password: _passwordController.text,
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
                                onPressed: () => RouteNavigators.route(
                                    context, const HomeScreen()),
                                size: size,
                                textColor: AppColors.textColor2,
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: AppColors.textColor2,
                                )),
                            GestureDetector(
                              onTap: () => RouteNavigators.route(
                                context,
                                SignUpScreen(),
                              ),
                              child: RichText(
                                textScaleFactor: 0.8,
                                text: const TextSpan(
                                  text: "Don't have an acccount? ",
                                  style: TextStyle(
                                    color: AppColors.textColor,
                                    fontFamily: 'Poppins',
                                    fontSize: 15,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Sign up',
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontSize: 15,
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
