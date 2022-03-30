import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reach_me/core/utils/loader.dart';
import 'package:reach_me/features/auth/data/models/user.dart';
import 'package:reach_me/features/auth/presentation/bloc/auth_bloc.dart';

final GetIt getIt = GetIt.instance;

class AppGlobals {
  factory AppGlobals() => instance;

  AppGlobals._();

  static final AppGlobals instance = AppGlobals._();

  AuthBloc? authBloc;

  User? user;

  void init() {
    user = User();
    authBloc = AuthBloc();
  }

  void dispose() {
    authBloc!.close();
  }

  void showLoader(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const RLoader('Loading...'),
    );
  }
}

AppGlobals globals = getIt.get<AppGlobals>();
