import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reach_me/core/utils/loader.dart';
import 'package:reach_me/core/models/user.dart';
import 'package:reach_me/features/auth/data/models/login_response.dart';
import 'package:reach_me/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:reach_me/features/chat/data/models/chat.dart';
import 'package:reach_me/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:reach_me/features/home/presentation/bloc/user-bloc/user_bloc.dart';

final GetIt getIt = GetIt.instance;

class AppGlobals {
  factory AppGlobals() => instance;

  AppGlobals._();

  static final AppGlobals instance = AppGlobals._();

  AuthBloc? authBloc;
  UserBloc? userBloc;
  ChatBloc? chatBloc;
  String? token;

  User? user;
  List<Chat>? userChat;
  User? recipientUser;
  List<User>? userList;
  List<ChatsThread>? userThreads;
  LoginResponse? loginResponse;

  void init() {
    user = User();
   recipientUser = User();
    userChat = [];
    userThreads = [];
    loginResponse = LoginResponse();
    authBloc = AuthBloc();
    userBloc = UserBloc();
    chatBloc = ChatBloc();
    token = '';
    userList = [];
  }

  void dispose() {
    authBloc!.close();
    userBloc!.close();
    chatBloc!.close();
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
