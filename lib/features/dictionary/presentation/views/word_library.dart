import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/components/rm_spinner.dart';
import 'package:reach_me/core/components/snackbar.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/features/dictionary/data/models/recently_added_model.dart';
import 'package:reach_me/features/dictionary/dictionary_bloc/bloc/dictionary_bloc.dart';
import 'package:reach_me/features/dictionary/dictionary_bloc/bloc/dictionary_event.dart';
import 'package:reach_me/features/dictionary/dictionary_bloc/bloc/dictionary_state.dart';
import 'package:reach_me/features/dictionary/presentation/widgets/content_container.dart';

class WordLibrary extends StatefulWidget {
  const WordLibrary({Key? key}) : super(key: key);

  @override
  State<WordLibrary> createState() => _WordLibraryState();
}

class _WordLibraryState extends State<WordLibrary> {
  final _recentWords = ValueNotifier<List<GetRecentlyAddedWord>>([]);
  @override
  void initState() {
    super.initState();
    globals.dictionaryBloc!
        .add(GetLibraryWordsEvent(pageLimit: 10000, pageNumber: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        leading: IconButton(
            icon: SvgPicture.asset(
              'assets/svgs/back.svg',
              width: 19,
              height: 12,
              color: AppColors.black,
            ),
            onPressed: () => RouteNavigators.pop(context)),
        backgroundColor: Colors.grey.shade50,
        centerTitle: false,
        title: Text(
          'Word Library',
          style: TextStyle(
            fontSize: getScreenHeight(16),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        elevation: 0,
        toolbarHeight: 50,
      ),
      body: BlocConsumer<DictionaryBloc, DictionaryState>(
        bloc: globals.dictionaryBloc,
        listener: (context, state) {
          if (state is LoadingWordsLibrarySuccess) {
            _recentWords.value = state.data!;
          }
          if (state is LoadingWordsLibraryError) {
            Snackbars.error(context, message: state.error);
          }
        },
        builder: (context, state) {
          bool _isLoading = state is LoadingWordsLibrary;
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 15.0),
            child: _isLoading
                ? const CircularLoader()
                : _recentWords.value.isEmpty
                    ? const Center(child: Text('No Words in Library'))
                    : ListView.builder(
                        itemCount: _recentWords.value.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ContentContainer(
                            showButtons: false,
                            getRecentlyAddedWord: _recentWords.value[index],
                          );
                        },
                      ),
          );
        },
      ),
    );
  }
}
