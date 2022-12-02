import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:reach_me/features/dictionary/data/repository/dictionary_repository.dart';

import 'dictionary_event.dart';
import 'dictionary_state.dart';

class DictionaryBloc extends Bloc<DictionaryEvent, DictionaryState> {
  final DictionaryRepository dictionaryRepository = DictionaryRepository();
  DictionaryBloc() : super(InitialState()) {
    on<SaveDataToGlossaryEvent>((event, emit) async {
      emit(AddingToDBState());
      await Future.delayed(
        const Duration(seconds: 2),
      );
      try {
        await dictionaryRepository.addToGlossary(
            abbr: event.abbr,
            meaning: event.meaning,
            word: event.word,
            language: event.language);
        emit(AddedToDBState());
      } catch (e) {
        emit(ErrorState(e.toString()));
      }
    });
    on<GetRecentAddedWordsEvent>((event, emit) async {
      emit(LoadingRecentlyAddedWords());
      try {
        final response = await dictionaryRepository.getRecentAddedWords(
            pageLimit: event.pageLimit, pageNumber: event.pageNumber);

        response.fold(
            (error) => emit(DisplayRecentlyAddedWordsError(error: error)),
            (data) => emit(GetRecentlyAddedWordsSuccess(data: data)));
      } on GraphQLError catch (e) {
        emit(DisplayRecentlyAddedWordsError(error: e.message));
      }
    });
    on<AddWordsToMentionsEvent>((event, emit) async {
      emit(LoadingWordsToMentions());
      try {
        final response = await dictionaryRepository.addWordsToMentions(
            pageLimit: event.pageLimit, pageNumber: event.pageNumber);

        response.fold((error) => emit(GetWordToMentionsError(error: error)),
            (data) => emit(GetWordToMentionsSuccess(mentionsData: data)));
      } on GraphQLError catch (e) {
        emit(GetWordToMentionsError(error: e.message));
      }
    });
    on<GetWordEvent>((event, emit) async {
      emit(LoadingSearchedWords());
      try {
        final response =
            await dictionaryRepository.searchWords(wordInput: event.wordInput);

        response.fold((error) => emit(GetSearchedWordError(error: error)),
            (data) => emit(DisplaySearchedWordSuccess(wordData: data)));
      } on GraphQLError catch (e) {
        emit(GetSearchedWordError(error: e.message));
      }
    });
    on<GetSearchHistoryEvent>((event, emit) async {
      emit(LoadingSearchedHistory());
      try {
        final historyResponse = await dictionaryRepository.getWordHistory(
            pageLimit: event.pageLimit, pageNumber: event.pageNumber);
        historyResponse.fold(
            (error) => emit(SearchHistoryErrorState(error: error)),
            (historyData) => emit(SearchedHistorySuccess(data: historyData)));
      } on GraphQLError catch (e) {
        emit(SearchHistoryErrorState(error: e.message));
      }
    });
    on<DeleteWordEvent>((event, emit) async {
      emit(DeletingWordLoading());
      try {
        final deletingHistory = await dictionaryRepository.deleteWordHistory(
            historyId: event.historyId);
        deletingHistory.fold(
            (error) => emit(
                DeletingWordError(error: error, historyId: event.historyId)),
            (deleteResponse) => emit(DeletingWordSuccess(
                isDeleted: deleteResponse, historyId: event.historyId)));
      } on GraphQLError catch (e) {
        emit(DeletingWordError(error: e.message, historyId: event.historyId));
      }
    });
    on<DeleteAllWordsEvent>((event, emit) async {
      emit(DeleteAllHistoryLoading());
      try {
        final deletingAllHistory =
            await dictionaryRepository.deleteAllHistory();
        deletingAllHistory.fold(
            (error) => emit(DeleteAllHistoryError(error: error)),
            (success) => emit(DeleteAllHistorySuccess()));
      } on GraphQLError catch (e) {
        emit(DeleteAllHistoryError(error: e.message));
      }
    });
  }
}
