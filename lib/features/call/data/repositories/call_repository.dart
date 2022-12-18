import 'package:dartz/dartz.dart';
import 'package:get/get_connect/http/src/exceptions/exceptions.dart';
import 'package:reach_me/core/helper/logger.dart';

import '../../presentation/bloc/call_bloc.dart';
import '../datasources/call_remote_datasource.dart';
import '../models/initiate_call_response.dart';

class CallRepository {
  CallRepository({CallRemoteDataSource? callRemoteDataSource})
      : _callRemoteDataSource = callRemoteDataSource ?? CallRemoteDataSource();

  final CallRemoteDataSource _callRemoteDataSource;

  Future<Either<String, InitiateCallResponse>> initiatePrivateCall(
      InitiatePrivateCall privateCall) async {
    try {
      final InitiateCallResponse response =
          await _callRemoteDataSource.initiatePrivateCall(privateCall);
      Console.log('call response', response);
      return Right(response);
    } on GraphQLError catch (e) {
      Console.log('call response', e);

      return Left(e.message!);
    }
  }

  answerPrivateCall(AnswerPrivateCall privateCall) {
    try {
      _callRemoteDataSource.answerPrivateCall(privateCall);
    } catch (e) {
      rethrow;
    }
  }

  completePrivateCall() {
   
  }

  rejectPrivateCall(RejectPrivateCall privateCall) {
     try {
      _callRemoteDataSource.rejectPrivateCall(privateCall);
    } catch (e) {
      rethrow;
    }
  }

  updatePrivateCall() {}
}
