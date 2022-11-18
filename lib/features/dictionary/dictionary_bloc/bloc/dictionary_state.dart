import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:reach_me/features/dictionary/data/models/get_word_model.dart';
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
  final GetWordClass  wordData;

  DisplaySearchedWordSuccess({required this.wordData});
}

class GetSearchedWordError extends DictionaryState {
  final String error;

  GetSearchedWordError({required this.error});
}
