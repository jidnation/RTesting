import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/components/custom_button.dart';
import 'package:reach_me/core/components/custom_textfield.dart';
import 'package:reach_me/core/components/snackbar.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/core/utils/loader.dart';
import 'package:reach_me/core/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:reach_me/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:reach_me/features/auth/presentation/views/login_screen.dart';

class ResetPasswordScreen extends HookWidget {
  static const String id = 'reset_password';
  final String? token;
  const ResetPasswordScreen({Key? key, this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = useState<GlobalKey<FormState>>(GlobalKey());
    final _passwordController = useTextEditingController();
    final _confirmPasswordController = useTextEditingController();
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        bloc: globals.authBloc,
        listener: (context, state) {
          if (state is AuthLoaded) {
            SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
              RMSnackBar.showSuccessSnackBar(context, message: state.message!);
            });
            RouteNavigators.routeNoWayHome(context, LoginScreen());
          } else if (state is AuthError) {
            RMSnackBar.showErrorSnackBar(context, message: state.error);
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const RLoader('');
          }
          return SafeArea(
            child: SizedBox(
              height: size.height,
              width: size.width,
              child: Form(
                key: _formKey.value,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Center(
                      child: SvgPicture.asset(
                        'assets/svgs/illustration 8-new.svg',
                        height: 186,
                        width: 290,
                      ),
                    ),
                    const SizedBox(height: 60.0),
                    const Text(
                      'Reset Password',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(height: 40),
                    CustomTextField(
                      hintText: 'Enter new password',
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      controller: _passwordController,
                      textCapitalization: TextCapitalization.none,
                      validator: (value) =>
                          Validator.validatePassword(value ?? ""),
                    ).paddingSymmetric(h: 45.0),
                    const SizedBox(height: 30),
                    CustomTextField(
                      hintText: 'Confirm new password',
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      controller: _confirmPasswordController,
                      textCapitalization: TextCapitalization.none,
                      validator: (value) =>
                          Validator.validatePassword(value ?? ""),
                    ).paddingSymmetric(h: 45.0),
                    const SizedBox(height: 40),
                    CustomButton(
                      label: 'Reset',
                      color: AppColors.primaryColor,
                      onPressed: () {
                        if (_formKey.value.currentState!.validate()) {
                          if (_passwordController.text ==
                              _confirmPasswordController.text) {
                            globals.authBloc!.add(
                              ResetPasswordEvent(
                                token: token,
                                password: _passwordController.text,
                              ),
                            );
                          } else {
                            RMSnackBar.showErrorSnackBar(
                              context,
                              message: 'Passwords do not match',
                            );
                          }
                        }
                      },
                      size: size,
                      textColor: AppColors.white,
                      borderSide: BorderSide.none,
                    ).paddingSymmetric(h: 45.0),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
