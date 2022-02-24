import 'package:reach_me/components/custom_button.dart';
import 'package:reach_me/components/snackbar.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/providers/auth.dart';
import 'package:reach_me/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class VerifyAccountScreen extends HookConsumerWidget {
  final String? token;
  final String? uid;
  static const String id = 'verify_account';
  
  late final String? altPin;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      color: const Color(0xFFF2EFEF),
      borderRadius: BorderRadius.circular(4.0),
    );
  }

  VerifyAccountScreen({Key? key, this.token, this.uid, this.altPin})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        color: AppColors.white,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 50.0, bottom: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => NavigationService.goBack(),
                child: const Icon(Icons.close),
              ),
              const SizedBox(height: 70),
              const Text(
                "Verify Account",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 24),
              RichText(
                textScaleFactor: 0.8,
                text: TextSpan(
                  text: "Please enter the ",
                  style: const TextStyle(
                    color: AppColors.textColor,
                    fontSize: 15,
                  ),
                  children: [
                    TextSpan(
                      text: 'CODE $token ',
                      style: const TextStyle(
                        color: AppColors.textColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(
                      text: 'sent to your email in the boxes below.',
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 70),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20.0),
                child: PinPut(
                    fieldsCount: 6,
                    onSubmit: (String pin) => {
                          altPin = pin,
                          if (token == pin)
                            {
                              ref
                                  .read(authNotifierProvider.notifier)
                                  .verifyEmail(context, uid: uid, token: token),
                            }
                          else
                            {
                              EWSnackBar.showErrorSnackBar(context,
                                  message: 'Incorrect code',
                                  milliseconds: 1000,
                                  snackBarBehavior: SnackBarBehavior.fixed)
                            }
                        },
                    focusNode: _pinPutFocusNode,
                    controller: _pinPutController,
                    submittedFieldDecoration: _pinPutDecoration.copyWith(
                        borderRadius: BorderRadius.circular(20.0)),
                    selectedFieldDecoration: _pinPutDecoration,
                    followingFieldDecoration: _pinPutDecoration.copyWith(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(color: const Color(0xFFF2EFEF)),
                    ),
                    cursor: const Text('|'),
                    withCursor: true,
                    initialValue: '*',
                    preFilledWidget: const Text('*')),
              ),
              const SizedBox(height: 16),
              const Expanded(child: SizedBox()),
              CustomButton(
                label: 'VERIFY ACCOUNT',
                color: AppColors.primaryColor,
                onPressed: () {
                  if (token == altPin) {
                    ref
                        .read(authNotifierProvider.notifier)
                        .verifyEmail(context, uid: uid, token: token);
                  } else {
                    EWSnackBar.showErrorSnackBar(context,
                        message: 'Incorrect code',
                        milliseconds: 1000,
                        snackBarBehavior: SnackBarBehavior.fixed);
                  }
                  // NavigationService.navigateTo(ResetPasswordScreen.id);
                },
                size: size,
                textColor: AppColors.white,
                borderSide: BorderSide.none,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}