import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:reach_me/features/dictionary/data/repository/dictionary_repository.dart';

import 'dictionary_event.dart';
import 'dictionary_state.dart';

class DictionaryBloc extends Bloc<DictionaryEvent, DictionaryState> {
  final DictionaryRepository dictionaryRepository = DictionaryRepository();
  DictionaryBloc() : super(InitialState()) {
//* ADD WORD TO GLOSSARY EVENT

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
          language: event.language,
        );
        emit(
          AddedToDBState(),
        );
      } catch (e) {
        emit(
          ErrorState(
            e.toString(),
          ),
        );
      }
    });
    //* Edit GLOSSARY EVENT
    on<EditGlossaryEvent>((event, emit) async {
      emit(
        EditGlossaryLoadingState(),
      );
      await Future.delayed(
        const Duration(seconds: 2),
      );
      try {
        final result = await dictionaryRepository.editGlossary(
          abbr: event.abbr,
          meaning: event.meaning,
          word: event.word,
          language: event.language,
        );
        result.fold(
          (error) => emit(
            EditGlossaryErrorState(
              error: error,
            ),
          ),
          (edited) => emit(
            EditGlossarySuccessState(),
          ),
        );
      } catch (e) {
        emit(
          EditGlossaryErrorState(
            error: e.toString(),
          ),
        );
      }
    }); //*Recently Added Words EVENT
    on<GetRecentAddedWordsEvent>((event, emit) async {
      emit(
        LoadingRecentlyAddedWords(),
      );
      try {
        final response = await dictionaryRepository.getRecentAddedWords(
          pageLimit: event.pageLimit,
          pageNumber: event.pageNumber,
        );

        response.fold(
          (error) => emit(
            DisplayRecentlyAddedWordsError(
              error: error,
            ),
          ),
          (data) => emit(
            GetRecentlyAddedWordsSuccess(
              data: data,
            ),
          ),
        );
      } on GraphQLError catch (e) {
        emit(
          DisplayRecentlyAddedWordsError(
            error: e.message,
          ),
        );
      }
    });
    //* Get Library Event
    on<GetLibraryWordsEvent>((event, emit) async {
      emit(LoadingWordsLibrary());
      try {
        final response = await dictionaryRepository.getLibraryWords(
          pageLimit: event.pageLimit,
          pageNumber: event.pageNumber,
        );

        response.fold(
          (error) => emit(
            LoadingWordsLibraryError(
              error: error,
            ),
          ),
          (data) => emit(
            LoadingWordsLibrarySuccess(
              data: data,
            ),
          ),
        );
      } on GraphQLError catch (e) {
        emit(
          LoadingWordsLibraryError(
            error: e.message,
          ),
        );
      }
    });

    //* ADD WORD TO Mentions EVENT
    on<AddWordsToMentionsEvent>(
      (event, emit) async {
        emit(LoadingWordsToMentions());
        try {
          final response = await dictionaryRepository.addWordsToMentions(
            pageLimit: event.pageLimit,
            pageNumber: event.pageNumber,
          );

          response.fold(
            (error) => emit(
              GetWordToMentionsError(
                error: error,
              ),
            ),
            (data) => emit(
              GetWordToMentionsSuccess(
                mentionsData: data,
              ),
            ),
          );
        } on GraphQLError catch (e) {
          emit(
            GetWordToMentionsError(
              error: e.message,
            ),
          );
        }
      },
    );
    //* GET WORD FROM GLOSSARY EVENT
    on<GetWordEvent>(
      (event, emit) async {
        emit(LoadingSearchedWords());
        try {
          final response = await dictionaryRepository.searchWords(
              wordInput: event.wordInput);

          response.fold(
            (error) => emit(
              GetSearchedWordError(
                error: error,
              ),
            ),
            (data) => emit(
              DisplaySearchedWordSuccess(
                wordData: data,
              ),
            ),
          );
        } on GraphQLError catch (e) {
          emit(
            GetSearchedWordError(
              error: e.message,
            ),
          );
        }
      },
    );
    //*GET SEARCH HISTORY EVENT
    on<GetSearchHistoryEvent>(
      (event, emit) async {
        emit(LoadingSearchedHistory());
        try {
          final historyResponse = await dictionaryRepository.getWordHistory(
            pageLimit: event.pageLimit,
            pageNumber: event.pageNumber,
          );
          historyResponse.fold(
            (error) => emit(
              SearchHistoryErrorState(
                error: error,
              ),
            ),
            (historyData) => emit(
              SearchedHistorySuccess(
                data: historyData,
              ),
            ),
          );
        } on GraphQLError catch (e) {
          emit(
            SearchHistoryErrorState(
              error: e.message,
            ),
          );
        }
      },
    );

    //* DELETE WORD FROM GLOSSARY EVENT
    on<DeleteWordEvent>(
      (event, emit) async {
        emit(DeletingWordLoading());
        try {
          final deletingHistory = await dictionaryRepository.deleteWordHistory(
              historyId: event.historyId);
          deletingHistory.fold(
            (error) => emit(
              DeletingWordError(
                error: error,
                historyId: event.historyId,
              ),
            ),
            (deleteResponse) => emit(
              DeletingWordSuccess(
                isDeleted: deleteResponse,
                historyId: event.historyId,
              ),
            ),
          );
        } on GraphQLError catch (e) {
          emit(
            DeletingWordError(
              error: e.message,
              historyId: event.historyId,
            ),
          );
        }
      },
    );
    //* DELETE USERWORD FROM GLOSSARY EVENT
    on<DeleteUserWordEvent>(
      (event, emit) async {
        try {
          final deleteUserWord = await dictionaryRepository
              .deleteCurrentUserWord(wordId: event.wordId);
          deleteUserWord.fold(
            (error) => emit(
              DeleteUserWordFailure(
                error: error,
                wordId: event.wordId,
              ),
            ),
            (deleteResponse) => emit(
              DeleteUserWordSuccess(
                  historyId: event.wordId, isDeleted: deleteResponse),
            ),
          );
        } on GraphQLError catch (e) {
          emit(
            DeleteUserWordFailure(
              error: e.message,
              wordId: event.wordId,
            ),
          );
        }
      },
    );
    //* DELETE ALL HISTORY WORD EVENT
    on<DeleteAllHistoryEvent>(
      (event, emit) async {
        emit(DeleteAllHistoryLoading());
        try {
          final deletingAllHistory =
              await dictionaryRepository.deleteAllHistory();
          deletingAllHistory.fold(
            (error) => emit(
              DeleteAllHistoryError(
                error: error,
              ),
            ),
            (success) => emit(
              DeleteAllHistorySuccess(),
            ),
          );
        } on GraphQLError catch (e) {
          emit(
            DeleteAllHistoryError(
              error: e.message,
            ),
          );
        }
      },
    );
  }
}
