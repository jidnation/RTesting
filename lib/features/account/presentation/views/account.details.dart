import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
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

import '../../../../core/components/refresher.dart';

class AccountStatsInfo extends StatefulHookWidget {
  const AccountStatsInfo({Key? key, this.index}) : super(key: key);
  final int? index;

  @override
  State<AccountStatsInfo> createState() => _AccountStatsInfoState();
}

class _AccountStatsInfoState extends State<AccountStatsInfo>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<AccountStatsInfo> {
  @override
  bool get wantKeepAlive => true;

  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 4, vsync: this, initialIndex: widget.index ?? 0);
  }

  TabBar get _tabBar => TabBar(
        isScrollable: true,
        controller: _tabController,
        indicatorWeight: 1.5,
        unselectedLabelColor: AppColors.textColor2,
        indicatorColor: Colors.transparent,
        labelColor: AppColors.white,
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
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.textColor2,
        ),
        tabs: [
          Tab(
            child: GestureDetector(
              onTap: () => setState(() {
                _tabController?.animateTo(0);
              }),
              child: FittedBox(
                child: Text(
                  '${globals.user!.nReachers} Reachers',
                  style: TextStyle(
                    fontSize: getScreenHeight(15),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              //  ),
            ),
          ),
          Tab(
            child: GestureDetector(
              onTap: () => setState(() {
                _tabController?.animateTo(1);
              }),

              child: FittedBox(
                child: Text(
                  '${globals.user!.nReaching} Reaching',
                  style: TextStyle(
                    fontSize: getScreenHeight(15),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              //  ),
            ),
          ),
          Tab(
            child: GestureDetector(
              onTap: () => setState(() {
                _tabController?.animateTo(2);
              }),

              child: FittedBox(
                child: Text(
                  '${globals.user!.nStaring} Star',
                  style: TextStyle(
                    fontSize: getScreenHeight(15),
                    fontWeight: FontWeight.w400,
                    /*color: _tabController!.index == 2
                        ? AppColors.white
                        : AppColors.textColor2,*/
                  ),
                ),
              ),
              //  ),
            ),
          ),
          Tab(
            child: GestureDetector(
              onTap: () => setState(() {
                _tabController?.animateTo(3);
              }),
              child: FittedBox(
                child: Text(
                  '${globals.user!.nBlocked} Blocked',
                  style: TextStyle(
                    fontSize: getScreenHeight(15),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            //  ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final _searchController = useTextEditingController();
    final _reachersList = useState<List<VirtualReach>>([]);
    final _reachingList = useState<List<VirtualReach>>([]);
    final _starsList = useState<List<VirtualStar>>([]);
    final _blockedList = useState<List<Block>>([]);

    useEffect(() {
      globals.userBloc!
          .add(FetchUserReachersEvent(pageLimit: 50, pageNumber: 1));
      globals.userBloc!
          .add(FetchUserReachingsEvent(pageLimit: 50, pageNumber: 1));
      globals.userBloc!
          .add(FetchUserStarredEvent(pageLimit: 50, pageNumber: 1));
      globals.userBloc!.add(GetBlockedListEvent());
      return null;
    }, []);

    print('This is the Blcoked List: ${_blockedList.value}');

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
                if (state is GetBlockedListSuccess) {
                  _blockedList.value = state.blockedList!;
                }
                if (state is DelStarRelationshipSuccess) {
                  Snackbars.success(context,
                      message: 'User unstarred Successfully');
                  globals.userBloc!
                      .add(FetchUserStarredEvent(pageLimit: 50, pageNumber: 1));
                  globals.userBloc!
                      .add(GetUserProfileEvent(email: globals.user!.email!));
                }

                if (state is StarUserSuccess) {
                  globals.userBloc!
                      .add(FetchUserStarredEvent(pageLimit: 50, pageNumber: 1));
                  globals.userBloc!
                      .add(GetUserProfileEvent(email: globals.user!.email!));
                }
                if (state is UnBlockUserSuccess) {
                  Snackbars.success(context,
                      message: 'User Unblocked Successfully');
                  globals.userBloc!.add(GetBlockedListEvent());
                  globals.userBloc!
                      .add(GetUserProfileEvent(email: globals.user!.email!));
                }
                if (state is BlockUserSuccess) {
                  Snackbars.success(context,
                      message: 'User Blocked Successfully');
                  globals.userBloc!.add(GetBlockedListEvent());
                  globals.userBloc!
                      .add(GetUserProfileEvent(email: globals.user!.email!));
                  globals.userBloc!.add(
                      FetchUserReachersEvent(pageLimit: 50, pageNumber: 1));
                }
                if (state is DelReachRelationshipSuccess) {
                  Snackbars.success(context,
                      message: 'User Unreached Successfully');
                  globals.userBloc!.add(
                      FetchUserReachersEvent(pageLimit: 50, pageNumber: 1));
                  globals.userBloc!.add(
                      FetchUserReachingsEvent(pageLimit: 50, pageNumber: 1));
                  globals.userBloc!
                      .add(GetUserProfileEvent(email: globals.user!.email!));
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
                    Stack(
                      fit: StackFit.passthrough,
                      alignment: Alignment.bottomCenter,
                      children: [
                        _tabBar,
                      ],
                    ),
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
                              //physics: const NeverScrollableScrollPhysics(),
                              controller: _tabController,
                              children: [
                                ListView.builder(
                                  itemCount: _reachersList.value.length,
                                  itemBuilder: (context, index) {
                                    return SeeMyReachersList(
                                      data: _reachersList.value[index],
                                      isRecipientAccount: false,
                                      isReaching: false,
                                    );
                                  },
                                ),
                                // ),

                                ListView.builder(
                                  itemCount: _reachingList.value.length,
                                  itemBuilder: (context, index) {
                                    return SeeMyReachingsList(
                                      data: _reachingList.value[index],
                                      isRecipientAccount: false,
                                      isReaching: false,
                                    );
                                  },
                                ),
                                ListView.builder(
                                  itemCount: _starsList.value.length,
                                  itemBuilder: (context, index) {
                                    return SeeMyStarsList(
                                        data: _starsList.value[index]);
                                  },
                                ),
                                ListView.builder(
                                  itemCount: _blockedList.value.length,
                                  itemBuilder: (context, index) {
                                    return SeeMyBlockList(
                                      data: _blockedList.value[index],
                                    );
                                  },
                                ),
                                // ),
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
  const SeeMyReachersList(
      {Key? key, this.data, this.isRecipientAccount, this.isReaching})
      : super(key: key);

  final VirtualReach? data;
  final bool? isReaching;
  final bool? isRecipientAccount;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(height: getScreenHeight(20)),
        BlocConsumer<UserBloc, UserState>(
          bloc: globals.userBloc,
          listener: (context, state) {
            if (state is BlockUserSuccess) {
              print("User Blocked");
            }
          },
          builder: (context, state) {
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Helper.renderProfilePicture(
                data!.reacher!.profilePicture ?? '',
                size: 50,
              ),
              minLeadingWidth: getScreenWidth(20),
              title: InkWell(
                onTap: () {
                  globals.userBloc!
                      .add(GetRecipientProfileEvent(email: data!.reacher!.id));
                  data!.reacher!.id == globals.user!.id
                      ? RouteNavigators.route(context, const AccountScreen())
                      : RouteNavigators.route(
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
                      (data!.reacher!.firstName! +
                              ' ' +
                              data!.reacher!.lastName!)
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
                ),
              ),
              trailing: SizedBox(
                height: getScreenHeight(40),
                width: getScreenWidth(80),
                child: CustomButton(
                  loaderColor: !isRecipientAccount!
                      ? AppColors.primaryColor
                      : AppColors.white,
                  label: !isRecipientAccount!
                      ? "Ex"
                      : isReaching!
                          ? "Unreach"
                          : "Reach",
                  //data!.reacher!.id == 'userBlocked' ? 'Unblock' : 'EX',
                  labelFontSize: getScreenHeight(13),
                  color: !isRecipientAccount!
                      ? AppColors.primaryColor
                      // data!.reacher!.id == 'userBlocked'
                      : isReaching!
                          ? AppColors.white
                          : AppColors.primaryColor,
                  onPressed: () {
                    // Block or Unblock user and render button according to userBlockRelationship //
                    isRecipientAccount!
                        ? isReaching!
                            ? globals.userBloc!.add(DelReachRelationshipEvent(
                                userIdToDelete: data!.reacher!.id!))
                            : globals.userBloc!.add(ReachUserEvent(
                                userIdToReach: data!.reacher!.id))
                        : globals.userBloc!
                            .add(BlockUserEvent(idToBlock: data!.reacher!.id!));
                  },
                  size: size,
                  padding: const EdgeInsets.symmetric(
                    vertical: 9,
                    horizontal: 21,
                  ),
                  textColor: !isRecipientAccount!
                      ? AppColors.white
                      : isReaching!
                          ? AppColors.black
                          : AppColors.white,
                  //data!.reacher!.id == 'userBlocked'
                  borderSide: !isRecipientAccount!
                      ? BorderSide.none
                      : isReaching!
                          ? const BorderSide(color: AppColors.greyShade5)
                          : BorderSide.none,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class SeeMyReachingsList extends StatelessWidget {
  const SeeMyReachingsList(
      {Key? key, this.data, this.isRecipientAccount, this.isReaching})
      : super(key: key);

  final VirtualReach? data;
  final bool? isRecipientAccount;
  final bool? isReaching;

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
              onTap: () {
                globals.userBloc!
                    .add(GetRecipientProfileEvent(email: data!.reaching!.id));
                data!.reaching!.id == globals.user!.id
                    ? RouteNavigators.route(context, const AccountScreen())
                    : RouteNavigators.route(
                        context,
                        RecipientAccountProfile(
                          recipientEmail: data!.reaching!.email,
                          recipientImageUrl: data!.reaching!.profilePicture,
                          recipientId: data!.reaching!.id,
                        ));
              },
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
                label: isRecipientAccount!
                    ? isReaching!
                        ? 'Unreach'
                        : 'Reach'
                    : 'Unreach',
                labelFontSize: getScreenHeight(13),
                color: !isRecipientAccount!
                    ? AppColors.white
                    : isReaching!
                        ? AppColors.white
                        : AppColors.primaryColor,
                onPressed: () {
                  // Remove User from Reaching UI //
                  if (isRecipientAccount!) {
                    if (isReaching!) {
                      globals.userBloc!.add(DelReachRelationshipEvent(
                          userIdToDelete: data!.reaching!.id));
                      globals.userBloc!.add(DelStarRelationshipEvent(
                          starIdToDelete: data!.reaching!.id));
                    } else {
                      globals.userBloc!.add(
                          ReachUserEvent(userIdToReach: data!.reaching!.id));
                    }
                  } else {
                    globals.userBloc!.add(DelReachRelationshipEvent(
                        userIdToDelete: data!.reaching!.id));
                  }
                },
                textColor: !isRecipientAccount!
                    ? AppColors.black
                    : isReaching!
                        ? AppColors.black
                        : AppColors.white,
                borderSide: !isRecipientAccount!
                    ? const BorderSide(color: AppColors.greyShade5)
                    : isReaching!
                        ? const BorderSide(color: AppColors.greyShade5)
                        : BorderSide.none,
              ),
            )),
      ],
    );
  }
}

class SeeMyStarsList extends StatelessWidget {
  const SeeMyStarsList({Key? key, this.data}) : super(key: key);

  final VirtualStar? data;

  @override
  Widget build(BuildContext context) {
    print('This is the star_laist ${data.toString()}');
    return Column(
      children: [
        SizedBox(height: getScreenHeight(20)),
        ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Helper.renderProfilePicture(
              data!.starred!.profilePicture ?? '',
              size: 50,
            ),
            minLeadingWidth: getScreenWidth(20),
            title: InkWell(
              onTap: () => RouteNavigators.route(
                  context,
                  RecipientAccountProfile(
                    recipientImageUrl: data!.starred!.profilePicture,
                    recipientId: data!.starredId,
                  )),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (data!.starred!.firstName! + ' ' + data!.starred!.lastName!)
                        .toTitleCase(),
                    style: TextStyle(
                      fontSize: getScreenHeight(16),
                      color: AppColors.textColor2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '@${data!.starred!.username}',
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
                label: 'Unstar',
                labelFontSize: getScreenHeight(13),
                color: AppColors.white,
                onPressed: () {
                  // Remove User from Reaching UI //
                  globals.userBloc!.add(DelStarRelationshipEvent(
                      starIdToDelete: data!.starredId));
                },
                textColor: AppColors.black,
                borderSide: const BorderSide(color: AppColors.greyShade5),
              ),
            )),
      ],
    );
  }
}

class SeeMyBlockList extends StatelessWidget {
  const SeeMyBlockList({Key? key, this.data}) : super(key: key);

  final Block? data;

  @override
  Widget build(BuildContext context) {
    print('This is the block List ${data.toString()}');
    return Column(
      children: [
        SizedBox(height: getScreenHeight(20)),
        BlocConsumer<UserBloc, UserState>(
          bloc: globals.userBloc,
          listener: (context, state) {
            if (state is UnBlockUserSuccess) {
              print('User Unblocked Successfully');
            }
          },
          builder: (context, state) {
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Helper.renderProfilePicture(
                data!.blockedProfile!.profilePicture ?? '',
                size: 50,
              ),
              minLeadingWidth: getScreenWidth(20),
              title: InkWell(
                onTap: () => RouteNavigators.route(
                    context,
                    RecipientAccountProfile(
                      recipientImageUrl: data!.blockedProfile!.profilePicture,
                      recipientId: data!.blockedAuthId,
                    )),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (data!.blockedProfile!.firstName! +
                              ' ' +
                              data!.blockedProfile!.lastName!)
                          .toTitleCase(),
                      style: TextStyle(
                        fontSize: getScreenHeight(16),
                        color: AppColors.textColor2,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '@${data!.blockedProfile!.username}',
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
                  label: 'UnEX',
                  labelFontSize: getScreenHeight(13),
                  color: AppColors.white,
                  onPressed: () {
                    globals.userBloc!.add(
                        UnBlockUserEvent(idToUnblock: data!.blockedAuthId!));
                  },
                  textColor: AppColors.black,
                  borderSide: const BorderSide(color: AppColors.greyShade5),
                ),
              ),
            );
          },
        )
      ],
    );
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
        TabController(length: 2, vsync: this, initialIndex: widget.index ?? 0);
    /* globals.userBloc!.add(FetchUserReachersEvent(
        pageLimit: 50, pageNumber: 1, authId: widget.recipientId));
    globals.userBloc!.add(FetchUserReachingsEvent(
        pageLimit: 50, pageNumber: 1, authId: widget.recipientId));
    globals.userBloc!.add(FetchUserStarredEvent(
        pageLimit: 50, pageNumber: 1, authId: widget.recipientId));*/
  }

  TabBar get _tabBar => TabBar(
        isScrollable: true,
        controller: _tabController,
        indicatorWeight: 1.5,
        unselectedLabelColor: AppColors.textColor2,
        indicatorColor: Colors.transparent,
        labelColor: AppColors.white,
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
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.textColor2,
        ),
        tabs: [
          Tab(
            child: GestureDetector(
              onTap: () => setState(() {
                _tabController?.animateTo(0);
              }),
              child: FittedBox(
                child: Text(
                  '${globals.recipientUser!.nReachers} Reachers',
                  style: TextStyle(
                    fontSize: getScreenHeight(15),
                    fontWeight: FontWeight.w400,
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
              child: FittedBox(
                child: Text(
                  '${globals.recipientUser!.nReaching} Reaching',
                  style: TextStyle(
                    fontSize: getScreenHeight(15),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
          /*Tab(
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
                    '${globals.recipientUser!.nStaring} Star',
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
          ),*/
        ],
      );
  @override
  Widget build(BuildContext context) {
    final _searchController = useTextEditingController();
    final _reachersList = useState<List<VirtualReach>>([]);
    final _reachingList = useState<List<VirtualReach>>([]);
    final _starsList = useState<List<VirtualStar>>([]);

    useEffect(() {
      globals.userBloc!.add(FetchUserReachersEvent(
          pageLimit: 50, pageNumber: 1, authId: widget.recipientId));
      globals.userBloc!.add(FetchUserReachingsEvent(
          pageLimit: 50, pageNumber: 1, authId: widget.recipientId));
      //globals.userBloc!
      // .add(FetchUserStarredEvent(pageLimit: 50, pageNumber: 1, authId: widget.recipientId));
      globals.userBloc!.add(GetBlockedListEvent());
      return null;
    }, []);

    print('This is the star_laist ${_starsList.value}');

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 30, 25, 0),
          child: BlocConsumer<UserBloc, UserState>(
              bloc: globals.userBloc,
              listener: (context, state) {
                if (state is DelReachRelationshipSuccess ||
                    state is UserLoaded) {
                  globals.userBloc!.add(FetchUserReachersEvent(
                      pageLimit: 50,
                      pageNumber: 1,
                      authId: widget.recipientId));
                  globals.userBloc!.add(FetchUserReachingsEvent(
                      pageLimit: 50,
                      pageNumber: 1,
                      authId: widget.recipientId));
                }

                if (state is FetchUserReachersSuccess) {
                  _reachersList.value = state.reachers!;
                }
                if (state is FetchUserReachingsSuccess) {
                  _reachingList.value = state.reachings!;
                }
                /*if (state is FetchUserStarredSuccess) {
                  _starsList.value = state.starredUsers!;
                }*/
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
                            (globals.recipientUser!.firstName! +
                                    ' ' +
                                    globals.recipientUser!.lastName!)
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
                    Stack(
                      fit: StackFit.passthrough,
                      alignment: Alignment.bottomCenter,
                      children: [
                        _tabBar,
                      ],
                    ),
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
                              //physics: const NeverScrollableScrollPhysics(),
                              controller: _tabController,
                              children: [
                                ListView.builder(
                                  itemCount: _reachersList.value.length,
                                  itemBuilder: (context, index) {
                                    return SeeMyReachersList(
                                      data: _reachersList.value[index],
                                      isRecipientAccount: true,
                                      isReaching:
                                          _reachersList.value[index].isReaching,
                                    );
                                  },
                                ),
                                ListView.builder(
                                  itemCount: _reachingList.value.length,
                                  itemBuilder: (context, index) {
                                    return SeeMyReachingsList(
                                      data: _reachingList.value[index],
                                      isRecipientAccount: true,
                                      isReaching:
                                          _reachingList.value[index].isReaching,
                                    );
                                  },
                                ),
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
