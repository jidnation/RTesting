import 'package:reach_me/components/rm_spinner.dart';
import 'package:reach_me/components/snackbar.dart';
import 'package:reach_me/core/services/exceptions/network_exceptions.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/screens/auth/verify_account.dart';
import 'package:reach_me/screens/auth/verify_account_success.dart';
import 'package:reach_me/screens/home/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reach_me/core/result_state.dart';
import 'package:reach_me/core/services/api/api_result.dart';
import 'package:reach_me/core/repositories/auth.dart';

final authRepositoryProvider =
    Provider<AuthServiceRepository>((ref) => AuthServiceRepository());

final authNotifierProvider = StateNotifierProvider(
    (ref) => AuthServiceNotifier(ref.watch(authRepositoryProvider)));

class AuthServiceNotifier extends StateNotifier<ResultState> {
  AuthServiceNotifier(this.authServiceRepository)
      : super(const ResultState.idle());
  final AuthServiceRepository authServiceRepository;

  late String token;
  late String uid;

  //REGISTER NEW USERS
  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    RMLoader.show(context);

    Map<String, dynamic> params = {
      'firstName': firstName,
      "lastName": lastName,
      "email": email,
      "password": password,
    };

    state = const ResultState.loading();

    ApiResult apiResult = await authServiceRepository.register(params);

    apiResult.when(
      success: (data) {
        state = ResultState.data(data: data);
        uid = data["body"]["id"];
        token = data["body"]["verifyToken"];
        RMLoader.hide();
        NavigationService.navigateTo(VerifyAccountScreen.id,
            arguments: {"token": token, "uid": uid});
      },
      failure: (failure) {
        RMLoader.hide();
        state = ResultState.error(error: failure);
        EWSnackBar.showErrorSnackBar(context,
            message: NetworkExceptions.getErrorMessage(failure),
            milliseconds: 2000,
            snackBarBehavior: SnackBarBehavior.fixed);
      },
    );
  }

  //VERIFY EMAIL VIA TOKEN
  Future<void> verifyEmail(BuildContext context,
      {required String? token, required String? uid}) async {
    RMLoader.show(context);

    Map<String, dynamic> params = {
      "id": uid,
      "emailToken": token,
    };

    state = const ResultState.loading();

    ApiResult apiResult = await authServiceRepository.verifyEmail(params);

    apiResult.when(
      success: (data) {
        state = ResultState.data(data: data);
        RMLoader.hide();
        NavigationService.navigateTo(VerifyAccountSuccess.id);
      },
      failure: (failure) {
        RMLoader.hide();
        state = ResultState.error(error: failure);

        EWSnackBar.showErrorSnackBar(context,
            message: NetworkExceptions.getErrorMessage(failure),
            milliseconds: 1000,
            snackBarBehavior: SnackBarBehavior.fixed);
      },
    );
  }

  //RESEND MAIL VERIFICATION LINK
  Future<void> resendMailToken(BuildContext context,
      {required String? email, required String? uid}) async {
    RMLoader.show(context);

    Map<String, dynamic> params = {
      "id": uid,
      "email": email,
    };

    state = const ResultState.loading();

    ApiResult apiResult = await authServiceRepository.resendEmailToken(params);

    apiResult.when(
      success: (data) {
        state = ResultState.data(data: data);

        RMLoader.hide();
        // NavigationService.navigateTo(VerifyAccountSuccess.id);
      },
      failure: (failure) {
        RMLoader.hide();
        state = ResultState.error(error: failure);

        EWSnackBar.showErrorSnackBar(context,
            message: NetworkExceptions.getErrorMessage(failure),
            milliseconds: 1000,
            snackBarBehavior: SnackBarBehavior.fixed);
      },
    );
  }

  //LOGIN EXISTING USERS
  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    RMLoader.show(context);

    Map<String, dynamic> params = {
      "email": email,
      "password": password,
    };

    state = const ResultState.loading();

    ApiResult apiResult = await authServiceRepository.login(params);

  

    apiResult.when(
      success: (data) {
        state = ResultState.data(data: data);
        String uid = data["body"]["id"];
        String accessToken = data["body"]["accessToken"];
        String email = data["body"]["email"];
        String refreshToken = data["body"]["refreshToken"];

        RMLoader.hide();
        NavigationService.navigateTo(HomeScreen.id, arguments: {
          "uid": uid,
          "accessToken": accessToken,
          "email": email,
          "refreshToken": refreshToken
        });
      },
      failure: (failure) {
        RMLoader.hide();
        state = ResultState.error(error: failure);
        EWSnackBar.showErrorSnackBar(context,
            message: NetworkExceptions.getErrorMessage(failure),
            milliseconds: 2000,
            snackBarBehavior: SnackBarBehavior.fixed);
      },
    );
  }

  //FORGOT PASSWORD
  Future<void> forgotPassword(BuildContext context,
      {required String email}) async {
    RMLoader.show(context);

    Map<String, dynamic> params = {"email": email};

    state = const ResultState.loading();

    ApiResult apiResult = await authServiceRepository.forgotPassword(params);

  

    apiResult.when(
      success: (data) {
        state = ResultState.data(data: data);
       //String message = data["message"];
        String email = data["body"]["email"];
        String resetToken = data["body"]["resetToken"];

        RMLoader.hide();
        NavigationService.navigateTo(HomeScreen.id,
            arguments: {"email": email, "resetToken": resetToken});
      },
      failure: (failure) {
        RMLoader.hide();
        state = ResultState.error(error: failure);
        EWSnackBar.showErrorSnackBar(context,
            message: NetworkExceptions.getErrorMessage(failure),
            milliseconds: 2000,
            snackBarBehavior: SnackBarBehavior.fixed);
      },
    );
  }
}
