import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:reach_me/features/dictionary/data/models/get_word_model.dart';
import 'package:reach_me/features/dictionary/data/models/gethistory_model.dart';
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

//*GET USER WORDS STATES
class LoadingWordsLibrary extends DictionaryState {}

class LoadingWordsLibrarySuccess extends DictionaryState {
  final List<GetRecentlyAddedWord>? data;

  LoadingWordsLibrarySuccess({required this.data});
}

class LoadingWordsLibraryError extends DictionaryState {
  final String error;

  LoadingWordsLibraryError({required this.error});
}

//*Recently Added States
class LoadingRecentlyAddedWords extends DictionaryState {}

class GetRecentlyAddedWordsSuccess extends DictionaryState {
  final List<GetRecentlyAddedWord>? data;
  GetRecentlyAddedWordsSuccess({required this.data});
}

class DisplayRecentlyAddedWordsError extends DictionaryState {
  final String error;
  DisplayRecentlyAddedWordsError({required this.error});
}

//*Mentions
class LoadingWordsToMentions extends DictionaryState {}

class GetWordToMentionsSuccess extends DictionaryState {
  final List<Map<String, dynamic>> mentionsData;

  GetWordToMentionsSuccess({required this.mentionsData});
}

class GetWordToMentionsError extends DictionaryState {
  final String error;
  GetWordToMentionsError({required this.error});
}

//*Searching Word States

class LoadingSearchedWords extends DictionaryState {}

class DisplaySearchedWordSuccess extends DictionaryState {
  final GetWordClass wordData;

  DisplaySearchedWordSuccess({required this.wordData});
}

class GetSearchedWordError extends DictionaryState {
  final String error;

  GetSearchedWordError({required this.error});
}

///* GeT SEARCHED HISTORY
class LoadingSearchedHistory extends DictionaryState {}

class SearchedHistorySuccess extends DictionaryState {
  final List<GetSearchedWordsHistory>? data;

  SearchedHistorySuccess({required this.data});
}

class SearchHistoryErrorState extends DictionaryState {
  final String error;
  SearchHistoryErrorState({required this.error});
}

//*DELETING WORDS
class DeletingWordLoading extends DictionaryState {}

class DeletingWordSuccess extends DictionaryState {
  final String historyId;
  final bool isDeleted;

  DeletingWordSuccess({
    required this.historyId,
    required this.isDeleted,
  });
}

class DeletingWordError extends DictionaryState {
  final String error;
  final String historyId;

  DeletingWordError({required this.historyId, required this.error});
}

//*DELETING WORD HISTORY

class DeleteAllHistoryLoading extends DictionaryState {}

class DeleteAllHistorySuccess extends DictionaryState {}

class DeleteAllHistoryError extends DictionaryState {
  final String error;
  DeleteAllHistoryError({required this.error});
}
//* DELETE USER WORD

class DeleteUserWordLoading extends DictionaryState {}

class DeleteUserWordSuccess extends DictionaryState {
  final String historyId;
  final bool isDeleted;

  DeleteUserWordSuccess({required this.historyId, required this.isDeleted});
}

class DeleteUserWordFailure extends DictionaryState {
  final String error;
  final String wordId;

  DeleteUserWordFailure({
    required this.error,
    required this.wordId,
  });
}
