import 'package:equatable/equatable.dart';

abstract class DictionaryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SaveDataToGlossaryEvent extends DictionaryEvent {
  final String abbr;
  final String word;
  final String language;
  final String meaning;

  SaveDataToGlossaryEvent(
      {required this.abbr,
      required this.word,
      required this.language,
      required this.meaning});
}

class EditGlossaryEvent extends DictionaryEvent {
  final String abbr;
  final String word;
  final String language;
  final String meaning;
  final String wordId;

  EditGlossaryEvent({
    required this.abbr,
    required this.word,
    required this.wordId,
    required this.language,
    required this.meaning,
  });
}

class GetRecentAddedWordsEvent extends DictionaryEvent {
  final num pageLimit;
  final num pageNumber;

  GetRecentAddedWordsEvent({required this.pageLimit, required this.pageNumber});
}

class GetLibraryWordsEvent extends DictionaryEvent {
  final num pageLimit;
  final num pageNumber;

  GetLibraryWordsEvent({required this.pageLimit, required this.pageNumber});
}

class AddWordsToMentionsEvent extends DictionaryEvent {
  final num pageLimit;
  final num pageNumber;

  AddWordsToMentionsEvent({required this.pageLimit, required this.pageNumber});
}

class GetWordEvent extends DictionaryEvent {
  final String wordInput;

  GetWordEvent(this.wordInput);
}

class DeleteUserWordEvent extends DictionaryEvent {
  final String wordId;

  DeleteUserWordEvent({required this.wordId});
}

class GetSearchHistoryEvent extends DictionaryEvent {
  final num pageLimit;
  final num pageNumber;

  GetSearchHistoryEvent({required this.pageLimit, required this.pageNumber});
}

class DeleteWordEvent extends DictionaryEvent {
  final String historyId;
  DeleteWordEvent({
    required this.historyId,
  });
}

class DeleteAllHistoryEvent extends DictionaryEvent {}
