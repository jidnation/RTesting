import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:reach_me/features/dictionary/data/models/recently_added_model.dart';

@immutable
abstract class DictionaryState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialState extends DictionaryState {}

class AddingToDBState extends DictionaryState {}

class AddedToDBState extends DictionaryState {}

class ErrorState extends DictionaryState {
  final String error;
  ErrorState(this.error);
}

class LoadingRecentlyAddedWords extends DictionaryState {}

class GetRecentlyAddedWordsSuccess extends DictionaryState {
  final List<GetRecentlyAddedWord>? data;
  GetRecentlyAddedWordsSuccess({required this.data});
}

class DisplayRecentlyAddedWordsError extends DictionaryState {
  final String error;
  DisplayRecentlyAddedWordsError({required this.error});
}
