import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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

class RecentlyAdded extends StatefulHookWidget {
  const RecentlyAdded({Key? key}) : super(key: key);

  @override
  State<RecentlyAdded> createState() => _RecentlyAddedState();
}

class _RecentlyAddedState extends State<RecentlyAdded> {
  @override
  Widget build(BuildContext context) {
    final _recentWords = useState<List<GetRecentlyAddedWord>>([]);
    useMemoized(() {
      globals.dictionaryBloc!
          .add(GetRecentAddedWordsEvent(pageLimit: 5, pageNumber: 1));
    });
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
          'Recently Added',
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
          if (state is GetRecentlyAddedWordsSuccess) {
            _recentWords.value = state.data!;
          }
          if (state is DisplayRecentlyAddedWordsError) {
            Snackbars.error(context, message: state.error);
          }
        },
        builder: (context, state) {
          bool _isLoading = state is LoadingRecentlyAddedWords;
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 15.0),
            child: _isLoading
                ? const CircularLoader()
                : _recentWords.value.isEmpty
                    ? const Center(child: Text('No Recent Words'))
                    : ListView.builder(
                        itemCount: _recentWords.value.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ContentContainer(
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
