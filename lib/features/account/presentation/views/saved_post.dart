import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/components/empty_state.dart';
import 'package:reach_me/core/components/media_card.dart';
import 'package:reach_me/core/components/rm_spinner.dart';
import 'package:reach_me/core/components/snackbar.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/core/utils/helpers.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/features/home/data/models/post_model.dart';
import 'package:reach_me/features/home/presentation/bloc/social-service-bloc/ss_bloc.dart';

class SavedPostScreen extends HookWidget {
  static const String id = "saved_post_screen";
  const SavedPostScreen({Key? key}) : super(key: key);
  TabBar get _tabBar => const TabBar(
        isScrollable: false,
        indicatorWeight: 1.5,
        indicator: UnderlineTabIndicator(
          insets: EdgeInsets.symmetric(horizontal: 20.0),
          borderSide: BorderSide(
            width: 2.0,
            color: AppColors.black,
          ),
        ),
        indicatorColor: AppColors.black,
        unselectedLabelColor: AppColors.greyShade4,
        labelColor: AppColors.black,
        labelStyle: TextStyle(
          fontSize: 15,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 15,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
        ),
        tabs: [
          Tab(child: Text('All Posts')),
          Tab(child: Text('Videos')),
          Tab(child: Text('Audios')),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final _savedPosts = useState<List<SavePostModel>>([]);
    useMemoized(() {
      globals.socialServiceBloc!
          .add(GetAllSavedPostsEvent(pageLimit: 50, pageNumber: 1));
    });
    return Scaffold(
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
        centerTitle: true,
        title: Text(
          'Saved Posts',
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
      body: DefaultTabController(
        length: 3,
        child: BlocConsumer<SocialServiceBloc, SocialServiceState>(
          bloc: globals.socialServiceBloc,
          listener: (context, state) {
            if (state is GetAllSavedPostsSuccess) {
              _savedPosts.value = state.data!;
            }
            if (state is GetAllSavedPostsError) {
              Snackbars.error(context, message: state.error);
            }
          },
          builder: (context, state) {
            bool _isLoading = state is GetAllSavedPostsLoading;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Stack(
                  fit: StackFit.passthrough,
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: AppColors.greyShade5, width: 1.0),
                        ),
                      ),
                    ),
                    _tabBar
                  ],
                ),
                Expanded(
                  child: TabBarView(children: [
                    if (_isLoading)
                      const CircularLoader()
                    else
                      _savedPosts.value.isEmpty
                          ? ListView(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              children: const [
                                EmptyTabWidget(
                                  title: "No saved posts",
                                  subtitle: "",
                                )
                              ],
                            )
                          : ListView.builder(
                              itemCount: _savedPosts.value.length,
                              itemBuilder: (context, index) {
                                return _SavedPostReacherCard(
                                    savedPostModel: _savedPosts.value[index]);
                              },
                            ),
                    ListView(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      children: const [
                        EmptyTabWidget(
                          title: "No video posts",
                          subtitle: "",
                        )
                      ],
                    ),
                    ListView(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      children: const [
                        EmptyTabWidget(
                          title: "No audio posts",
                          subtitle: "",
                        )
                      ],
                    ),
                  ]),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SavedPostReacherCard extends HookWidget {
  const _SavedPostReacherCard({
    Key? key,
    required this.savedPostModel,
    this.onDelete,
  }) : super(key: key);

  final SavePostModel? savedPostModel;
  final Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 7,
      ),
      child: Container(
        width: size.width,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: BlocConsumer<SocialServiceBloc, SocialServiceState>(
            bloc: globals.socialServiceBloc,
            listener: (context, state) {},
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Helper.renderProfilePicture(
                            savedPostModel!.profile!.profilePicture,
                            size: 33,
                          ).paddingOnly(l: 13, t: 10),
                          SizedBox(width: getScreenWidth(9)),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    (savedPostModel!.profile!.firstName! +
                                            ' ' +
                                            savedPostModel!.profile!.lastName!)
                                        .toTitleCase(),
                                    style: TextStyle(
                                      fontSize: getScreenHeight(15),
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textColor2,
                                    ),
                                  ),
                                  const SizedBox(width: 3),
                                  savedPostModel!.profile!.verified!
                                      ? SvgPicture.asset(
                                          'assets/svgs/verified.svg')
                                      : const SizedBox.shrink()
                                ],
                              ),
                              Text(
                                'Manchester, United Kingdom',
                                style: TextStyle(
                                  fontSize: getScreenHeight(11),
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textColor2,
                                ),
                              ),
                            ],
                          ).paddingOnly(t: 10),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset('assets/svgs/starred.svg'),
                          SizedBox(width: getScreenWidth(9)),
                          IconButton(
                            onPressed: () async {
                              // await showReacherCardBottomSheet(
                              //   context,
                              //   savedPostModel: savedPostModel!,
                              // );
                            },
                            iconSize: getScreenHeight(19),
                            padding: const EdgeInsets.all(0),
                            icon:
                                SvgPicture.asset('assets/svgs/kebab card.svg'),
                          ),
                        ],
                      )
                    ],
                  ),
                  Flexible(
                    child: Text(
                      savedPostModel!.content ?? '',
                      style: TextStyle(
                        fontSize: getScreenHeight(14),
                        fontWeight: FontWeight.w400,
                      ),
                    ).paddingSymmetric(v: 10, h: 16),
                  ),
                  if (savedPostModel!.imageMediaItems!.isNotEmpty &&
                      savedPostModel!.audioMediaItem!.isNotEmpty &&
                      savedPostModel!.videoMediaItem!.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Container(
                            height: getScreenHeight(152),
                            width: getScreenWidth(152),
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: const DecorationImage(
                                image: AssetImage('assets/images/post.png'),
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: getScreenWidth(8)),
                        Flexible(child: MediaCard(size: size)),
                      ],
                    ).paddingOnly(b: 32, r: 16, l: 16, t: 5),
                ],
              );
            }),
      ),
    );
  }
}
