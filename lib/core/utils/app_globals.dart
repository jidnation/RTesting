import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reach_me/core/models/user.dart';
import 'package:reach_me/core/services/dialog_and_sheet_service.dart/dialog_and_sheet_service.dart';
import 'package:reach_me/core/utils/loader.dart';
import 'package:reach_me/features/auth/data/models/login_response.dart';
import 'package:reach_me/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:reach_me/features/chat/data/models/chat.dart';
import 'package:reach_me/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:reach_me/features/home/data/models/post_model.dart';
import 'package:reach_me/features/home/presentation/bloc/social-service-bloc/ss_bloc.dart';
import 'package:reach_me/features/home/presentation/bloc/user-bloc/user_bloc.dart';

final GetIt getIt = GetIt.instance;

class AppGlobals {
  factory AppGlobals() => instance;

  AppGlobals._();

  static final AppGlobals instance = AppGlobals._();

  AuthBloc? authBloc;
  UserBloc? userBloc;
  ChatBloc? chatBloc;
  SocialServiceBloc? socialServiceBloc;
  String? token;
  String? email;
  String? fname;
  String? userId;
  String? location;
  String? postContent;
  String? postCommentOption;

  User? user;
  List<Chat>? userChat;
  User? recipientUser;
  List<ProfileIndexModel>? userList;
  List<ChatsThread>? userThreads;
  LoginResponse? loginResponse;
  DialogAndSheetService? dialogAndSheetService;

  void init() {
    user = User();
    recipientUser = User();
    userChat = [];
    userThreads = [];
    loginResponse = LoginResponse();
    authBloc = AuthBloc();
    userBloc = UserBloc();
    chatBloc = ChatBloc();
    socialServiceBloc = SocialServiceBloc();
    token = '';
    email = '';
    postCommentOption = '';
    postContent = '';
    fname = '';
    userId = '';
    location = 'NIL';
    userList = [];
    dialogAndSheetService = DialogAndSheetService();
  }

  void dispose() {
    authBloc!.close();
    userBloc!.close();
    chatBloc!.close();
    socialServiceBloc!.close();
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
