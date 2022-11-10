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

class GetRecentAddedWordsEvent extends DictionaryEvent {
  final num pageLimit;
  final num pageNumber;

  GetRecentAddedWordsEvent({required this.pageLimit, required this.pageNumber});
}
class AddWordsToMentionsEvent extends DictionaryEvent {
  final num pageLimit;
  final num pageNumber;

 AddWordsToMentionsEvent({required this.pageLimit, required this.pageNumber});
}

