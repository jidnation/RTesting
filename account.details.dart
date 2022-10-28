import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reach_me/core/components/custom_button.dart';
import 'package:reach_me/core/components/custom_textfield.dart';
import 'package:reach_me/core/components/snackbar.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/core/utils/helpers.dart';
import 'package:reach_me/features/account/presentation/views/account.dart';
import 'package:reach_me/features/home/data/models/virtual_models.dart';
import 'package:reach_me/features/home/presentation/bloc/user-bloc/user_bloc.dart';

class AccountStatsInfo extends StatefulHookWidget {
  const AccountStatsInfo({Key? key, this.index}) : super(key: key);
  final int? index;

  @override
  State<AccountStatsInfo> createState() => _AccountStatsInfoState();
}

class _AccountStatsInfoState extends State<AccountStatsInfo>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 3, vsync: this, initialIndex: widget.index ?? 0);
    globals.userBloc!.add(FetchUserReachersEvent(pageLimit: 50, pageNumber: 1));
    globals.userBloc!
        .add(FetchUserReachingsEvent(pageLimit: 50, pageNumber: 1));
    globals.userBloc!.add(FetchUserStarredEvent(pageLimit: 50, pageNumber: 1));
  }

  TabBar get _tabBar => TabBar(
        isScrollable: true,
        controller: _tabController,
        indicatorWeight: 1.5,
        unselectedLabelColor: AppColors.greyShade4,
        indicatorColor: Colors.transparent,
        labelColor: AppColors.primaryColor,
        labelStyle: TextStyle(
          fontSize: getScreenHeight(15),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: getScreenHeight(15),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
        ),
        tabs: [
          Tab(
            child: GestureDetector(
              onTap: () => setState(() {
                _tabController?.animateTo(0);
              }),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: _tabController!.index == 0
                      ? AppColors.textColor2
                      : Colors.transparent,
                ),
                child: FittedBox(
                  child: Text(
                    '${globals.user!.nReachers} Reachers',
                    style: TextStyle(
                      fontSize: getScreenHeight(15),
                      fontWeight: FontWeight.w400,
                      color: _tabController!.index == 0
                          ? AppColors.white
                          : AppColors.textColor2,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Tab(
            child: GestureDetector(
              onTap: () => setState(() {
                _tabController?.animateTo(1);
              }),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: _tabController!.index == 1
                      ? AppColors.textColor2
                      : Colors.transparent,
                ),
                child: FittedBox(
                  child: Text(
                    '${globals.user!.nReaching} Reaching',
                    style: TextStyle(
                      fontSize: getScreenHeight(15),
                      fontWeight: FontWeight.w400,
                      color: _tabController!.index == 1
                          ? AppColors.white
                          : AppColors.textColor2,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Tab(
            child: GestureDetector(
              onTap: () => setState(() {
                _tabController?.animateTo(2);
              }),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: _tabController!.index == 2
                      ? AppColors.textColor2
                      : Colors.transparent,
                ),
                child: FittedBox(
                  child: Text(
                    '${globals.user!.nStaring} Star',
                    style: TextStyle(
                      fontSize: getScreenHeight(15),
                      fontWeight: FontWeight.w400,
                      color: _tabController!.index == 2
                          ? AppColors.white
                          : AppColors.textColor2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final _searchController = useTextEditingController();
    final _reachersList = useState<List<VirtualReach>>([]);
    final _reachingList = useState<List<VirtualReach>>([]);
    final _starsList = useState<List<VirtualStar>>([]);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 30, 25, 0),
          child: BlocConsumer<UserBloc, UserState>(
              bloc: globals.userBloc,
              listener: (context, state) {
                if (state is FetchUserReachersSuccess) {
                  _reachersList.value = state.reachers!;
                }
                if (state is FetchUserReachingsSuccess) {
                  _reachingList.value = state.reachings!;
                }
                if (state is FetchUserStarredSuccess) {
                  _starsList.value = state.starredUsers!;
                }
                if (state is UserError) {
                  Snackbars.error(context, message: state.error);
                }
              },
              builder: (context, state) {
                bool _isLoading = state is UserLoading;
                return Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => RouteNavigators.pop(context),
                          ),
                          Text(
                            (globals.user!.firstName! +
                                    ' ' +
                                    globals.user!.lastName!)
                                .toTitleCase(),
                            style: TextStyle(
                              fontSize: getScreenHeight(18),
                              color: AppColors.textColor2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Opacity(
                            opacity: 0,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              icon: Icon(Icons.arrow_back),
                              onPressed: null,
                            ),
                          ),
                        ]),
                    SizedBox(height: getScreenHeight(20)),
                    CustomRoundTextField(
                      hintText: 'Search',
                      fillColor: const Color(0XffF5F5F5),
                      controller: _searchController,
                      maxLines: 1,
                      onChanged: (val) {
                        if (val.isNotEmpty) {
                        } else {}
                      },
                    ).paddingSymmetric(h: 13),
                    SizedBox(height: getScreenHeight(20)),
                    _tabBar,
                    Expanded(
                      child: _isLoading
                          ? const Center(
                              child: SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator.adaptive(
                                backgroundColor: Colors.black26,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.black, //<-- SEE HERE
                                ),
                                strokeWidth: 3,
                              ),
                            ))
                          : TabBarView(
                              physics: const NeverScrollableScrollPhysics(),
                              controller: _tabController,
                              children: [
                                ListView.builder(
                                  itemCount: _reachersList.value.length,
                                  itemBuilder: (context, index) {
                                    return SeeMyReachersList(
                                        data: _reachersList.value[index]);
                                  },
                                ),
                                ListView.builder(
                                  itemCount: _reachingList.value.length,
                                  itemBuilder: (context, index) {
                                    return SeeMyReachingsList(
                                        data: _reachingList.value[index]);
                                  },
                                ),
                                const SeeMyStarsList(),
                              ],
                            ).paddingSymmetric(h: 13),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}

class SeeMyReachersList extends StatelessWidget {
  const SeeMyReachersList({Key? key, this.data}) : super(key: key);

  final VirtualReach? data;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(height: getScreenHeight(20)),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Helper.renderProfilePicture(
            data!.reacher!.profilePicture ?? '',
            size: 50,
          ),
          minLeadingWidth: getScreenWidth(20),
          title: InkWell(
              onTap: () {
                RouteNavigators.route(
                    context,
                    RecipientAccountProfile(
                      recipientEmail: data!.reacher!.email,
                      recipientImageUrl: data!.reacher!.profilePicture,
                      recipientId: data!.reacher!.id,
                    ));
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (data!.reacher!.firstName! + ' ' + data!.reacher!.lastName!)
                        .toTitleCase(),
                    style: TextStyle(
                      fontSize: getScreenHeight(16),
                      color: AppColors.textColor2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '@${data!.reacher!.username}',
                    style: TextStyle(
                      fontSize: getScreenHeight(13),
                      color: const Color(0xFF767474),
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              )),
          trailing: SizedBox(
            height: getScreenHeight(40),
            width: getScreenWidth(80),
            child: CustomButton(
              loaderColor: data!.reacher!.id == 'userBlocked'
                  ? AppColors.primaryColor
                  : AppColors.white,
              label: data!.reacher!.id == 'userBlocked' ? 'Unblock' : 'EX',
              labelFontSize: getScreenHeight(13),
              color: data!.reacher!.id == 'userBlocked'
                  ? AppColors.white
                  : AppColors.primaryColor,
              onPressed: () {
                // Block or Unblock user and render button according to userBlockRelationship //
              },
              size: size,
              padding: const EdgeInsets.symmetric(
                vertical: 9,
                horizontal: 21,
              ),
              textColor: data!.reacher!.id == 'userBlocked'
                  ? AppColors.black
                  : AppColors.white,
              borderSide: data!.reacher!.id == 'userBlocked'
                  ? const BorderSide(color: AppColors.greyShade5)
                  : BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

class SeeMyReachingsList extends StatelessWidget {
  const SeeMyReachingsList({Key? key, this.data}) : super(key: key);

  final VirtualReach? data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: getScreenHeight(20)),
        ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Helper.renderProfilePicture(
              data!.reaching!.profilePicture ?? '',
              size: 50,
            ),
            minLeadingWidth: getScreenWidth(20),
            title: InkWell(
              onTap: () => RouteNavigators.route(
                  context,
                  RecipientAccountProfile(
                    recipientEmail: data!.reaching!.email,
                    recipientImageUrl: data!.reaching!.profilePicture,
                    recipientId: data!.reaching!.id,
                  )),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (data!.reaching!.firstName! +
                            ' ' +
                            data!.reaching!.lastName!)
                        .toTitleCase(),
                    style: TextStyle(
                      fontSize: getScreenHeight(16),
                      color: AppColors.textColor2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '@${data!.reaching!.username}',
                    style: TextStyle(
                      fontSize: getScreenHeight(13),
                      color: const Color(0xFF767474),
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
            ),
            trailing: SizedBox(
              height: getScreenHeight(40),
              width: getScreenWidth(80),
              child: CustomButton(
                loaderColor: AppColors.primaryColor,
                label: 'Unreach',
                labelFontSize: getScreenHeight(13),
                color: AppColors.white,
                onPressed: () {
                  // Remove User from Reaching UI //
                },
                textColor: AppColors.black,
                borderSide: const BorderSide(color: AppColors.greyShade5),
              ),
            )),
      ],
    );
  }
}

class SeeMyStarsList extends StatelessWidget {
  const SeeMyStarsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class RecipientAccountStatsInfo extends StatefulHookWidget {
  const RecipientAccountStatsInfo({
    Key? key,
    this.index,
    required this.recipientId,
  }) : super(key: key);
  final int? index;
  final String? recipientId;

  @override
  State<RecipientAccountStatsInfo> createState() =>
      _RecipientAccountStatsInfoState();
}

class _RecipientAccountStatsInfoState extends State<RecipientAccountStatsInfo>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 3, vsync: this, initialIndex: widget.index ?? 0);
    globals.userBloc!.add(FetchUserReachersEvent(
        pageLimit: 50, pageNumber: 1, authId: widget.recipientId));
    globals.userBloc!.add(FetchUserReachingsEvent(
        pageLimit: 50, pageNumber: 1, authId: widget.recipientId));
    globals.userBloc!.add(FetchUserStarredEvent(
        pageLimit: 50, pageNumber: 1, authId: widget.recipientId));
  }

  TabBar get _tabBar => TabBar(
        isScrollable: true,
        controller: _tabController,
        indicatorWeight: 1.5,
        unselectedLabelColor: AppColors.greyShade4,
        indicatorColor: Colors.transparent,
        labelColor: AppColors.primaryColor,
        labelStyle: TextStyle(
          fontSize: getScreenHeight(15),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: getScreenHeight(15),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
        ),
        tabs: [
          Tab(
            child: GestureDetector(
              onTap: () => setState(() {
                _tabController?.animateTo(0);
              }),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: _tabController!.index == 0
                      ? AppColors.textColor2
                      : Colors.transparent,
                ),
                child: FittedBox(
                  child: Text(
                    '${globals.user!.nReachers} Reachers',
                    style: TextStyle(
                      fontSize: getScreenHeight(15),
                      fontWeight: FontWeight.w400,
                      color: _tabController!.index == 0
                          ? AppColors.white
                          : AppColors.textColor2,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Tab(
            child: GestureDetector(
              onTap: () => setState(() {
                _tabController?.animateTo(1);
              }),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: _tabController!.index == 1
                      ? AppColors.textColor2
                      : Colors.transparent,
                ),
                child: FittedBox(
                  child: Text(
                    '${globals.user!.nReaching} Reaching',
                    style: TextStyle(
                      fontSize: getScreenHeight(15),
                      fontWeight: FontWeight.w400,
                      color: _tabController!.index == 1
                          ? AppColors.white
                          : AppColors.textColor2,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Tab(
            child: GestureDetector(
              onTap: () => setState(() {
                _tabController?.animateTo(2);
              }),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: _tabController!.index == 2
                      ? AppColors.textColor2
                      : Colors.transparent,
                ),
                child: FittedBox(
                  child: Text(
                    '${globals.user!.nStaring} Star',
                    style: TextStyle(
                      fontSize: getScreenHeight(15),
                      fontWeight: FontWeight.w400,
                      color: _tabController!.index == 2
                          ? AppColors.white
                          : AppColors.textColor2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
  @override
  Widget build(BuildContext context) {
    final _searchController = useTextEditingController();
    final _reachersList = useState<List<VirtualReach>>([]);
    final _reachingList = useState<List<VirtualReach>>([]);
    final _starsList = useState<List<VirtualStar>>([]);
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 30, 25, 0),
          child: BlocConsumer<UserBloc, UserState>(
              bloc: globals.userBloc,
              listener: (context, state) {
                if (state is FetchUserReachersSuccess) {
                  _reachersList.value = state.reachers!;
                }
                if (state is FetchUserReachingsSuccess) {
                  _reachingList.value = state.reachings!;
                }
                if (state is FetchUserStarredSuccess) {
                  _starsList.value = state.starredUsers!;
                }
                if (state is UserError) {
                  Snackbars.error(context, message: state.error);
                }
              },
              builder: (context, state) {
                bool _isLoading = state is UserLoading;
                return Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => RouteNavigators.pop(context),
                          ),
                          Text(
                            (globals.user!.firstName! +
                                    ' ' +
                                    globals.user!.lastName!)
                                .toTitleCase(),
                            style: TextStyle(
                              fontSize: getScreenHeight(18),
                              color: AppColors.textColor2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Opacity(
                            opacity: 0,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              icon: Icon(Icons.arrow_back),
                              onPressed: null,
                            ),
                          ),
                        ]),
                    SizedBox(height: getScreenHeight(20)),
                    CustomRoundTextField(
                      hintText: 'Search',
                      fillColor: const Color(0XffF5F5F5),
                      controller: _searchController,
                      maxLines: 1,
                      onChanged: (val) {
                        if (val.isNotEmpty) {
                        } else {}
                      },
                    ).paddingSymmetric(h: 13),
                    SizedBox(height: getScreenHeight(20)),
                    _tabBar,
                    Expanded(
                      child: _isLoading
                          ? const Center(
                              child: SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator.adaptive(
                                backgroundColor: Colors.black26,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.black, //<-- SEE HERE
                                ),
                                strokeWidth: 3,
                              ),
                            ))
                          : TabBarView(
                              physics: const NeverScrollableScrollPhysics(),
                              controller: _tabController,
                              children: [
                                ListView.builder(
                                  itemCount: _reachersList.value.length,
                                  itemBuilder: (context, index) {
                                    return SeeMyReachersList(
                                        data: _reachersList.value[index]);
                                  },
                                ),
                                ListView.builder(
                                  itemCount: _reachingList.value.length,
                                  itemBuilder: (context, index) {
                                    return SeeMyReachingsList(
                                      data: _reachingList.value[index],
                                    );
                                  },
                                ),
                                const SeeMyStarsList(),
                              ],
                            ).paddingSymmetric(h: 13),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
