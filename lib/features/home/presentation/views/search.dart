import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/components/custom_textfield.dart';
import 'package:reach_me/core/components/profile_picture.dart';
import 'package:reach_me/core/components/snackbar.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/features/account/presentation/views/account.dart';
import 'package:reach_me/features/account/presentation/widgets/image_placeholder.dart';
import 'package:reach_me/features/home/presentation/bloc/social-service-bloc/ss_bloc.dart';
import 'package:reach_me/features/home/presentation/bloc/user-bloc/user_bloc.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:carousel_slider/carousel_slider.dart';

class SearchScreen extends StatefulHookWidget {
  static const String id = "search_screen";
  final GlobalKey<ScaffoldState>? scaffoldKey;
  const SearchScreen({Key? key, this.scaffoldKey}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin<SearchScreen> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final _searchString = useState<String>('');
    final _hasText = useState<bool>(false);
    final _searchController = useTextEditingController();
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey.shade50,
          elevation: 0,
          leading: IconButton(
            padding: const EdgeInsets.all(0),
            onPressed: () => widget.scaffoldKey!.currentState!.openDrawer(),
            icon: globals.user!.profilePicture == null
                ? ImagePlaceholder(
                    width: getScreenWidth(40),
                    height: getScreenHeight(40),
                  )
                : ProfilePicture(
                    width: getScreenWidth(40),
                    height: getScreenHeight(40),
                  ),
          ).paddingOnly(t: 10, l: 10),
          title: CustomRoundTextField(
            hintText: 'Search ReachMe',
            fillColor: AppColors.white,
            controller: _searchController,
            maxLines: 1,
            onChanged: (val) {
              if (val.isNotEmpty) {
                _hasText.value = true;
                _searchString.value = val;
                globals.socialServiceBloc!.add(SearchProfileEvent(
                  pageLimit: 20,
                  pageNumber: 1,
                  name: val,
                ));
              } else {
                _hasText.value = false;
              }
            },
          ).paddingOnly(t: 10),
          actions: [
            IconButton(
              padding: const EdgeInsets.all(0),
              icon: SvgPicture.asset(
                'assets/svgs/Setting.svg',
                width: 25,
                height: 25,
              ),
              onPressed: () {},
            ).paddingOnly(t: 10, r: 10),
          ],
        ),
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: !_hasText.value
              ? const SearchStories()
              : BlocConsumer<SocialServiceBloc, SocialServiceState>(
                  bloc: globals.socialServiceBloc,
                  listener: (context, state) {
                    if (state is SearchProfileSuccess) {
                      globals.userList = state.users!;
                    } else if (state is SearchProfileError) {
                      Snackbars.error(context, message: state.error);
                    }
                  },
                  builder: (context, state) {
                    if (state is UserLoading) {
                      return const Center(child: CupertinoActivityIndicator());
                    }
                    if (globals.userList!.isEmpty) {
                      return SearchNoResultFound(size: size)
                          .paddingSymmetric(h: 16);
                    }
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: globals.userList!.length,
                      itemBuilder: (context, index) {
                        return SearchResultCard(
                          displayName: (globals.userList![index].firstName! +
                                  ' ' +
                                  globals.userList![index].lastName!)
                              .toTitleCase(),
                          //: globals.userList![index].,
                          username: globals.userList![index].username,
                          imageUrl: globals.userList![index].profilePicture,
                          id: globals.userList![index].authId,
                        );
                      },
                    );
                  },
                ),
        ),
      ),
    );
  }
}

class SearchNoResultFound extends StatelessWidget {
  const SearchNoResultFound({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 50,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(children: [
        const Icon(
          Icons.info,
          color: AppColors.grey,
        ),
        SizedBox(height: getScreenHeight(9)),
        Text(
          'No result found',
          style: TextStyle(
            fontSize: getScreenHeight(15),
            color: AppColors.greyShade4,
          ),
        )
      ]),
    );
  }
}

class SearchResultCard extends StatelessWidget {
  const SearchResultCard({
    Key? key,
    required this.username,
    required this.displayName,
    required this.imageUrl,
    // required this.email,
    required this.id,
  }) : super(key: key);

  final String? imageUrl;
  final String? username;
  final String? displayName;
  // final String? email;
  final String? id;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      bloc: globals.userBloc,
      listener: (context, state) {
        if (state is RecipientUserData) {
          globals.recipientUser = state.user;
          //  email == globals.user!.email
          //       ? RouteNavigators.route(context, const AccountScreen())
          //       : RouteNavigators.route(
          //           context, RecipientAccountProfile(email: email));
        } else if (state is UserError) {
          Snackbars.error(context, message: state.error);
        }
      },
      builder: (context, state) {
        if (state is UserLoading) {
          return Center(
              child: Platform.isIOS
                  ? const CupertinoActivityIndicator()
                  : const CircularProgressIndicator());
        }
        return InkWell(
          onTap: () {
            globals.userBloc!.add(GetRecipientProfileEvent(email: id));
            id == globals.user!.id
                ? RouteNavigators.route(context, const AccountScreen())
                : RouteNavigators.route(
                    context,
                    RecipientAccountProfile(
                      recipientEmail: 'email',
                      recipientImageUrl: imageUrl,
                      recipientId: id,
                    ));
          },
          child: ListTile(
            leading: imageUrl == null
                ? ImagePlaceholder(
                    height: getScreenHeight(40),
                    width: getScreenWidth(40),
                  )
                : RecipientProfilePicture(
                    height: getScreenHeight(40),
                    width: getScreenWidth(40),
                    imageUrl: imageUrl,
                  ),
            title: Text(
              username ?? '',
              style: TextStyle(
                fontSize: getScreenHeight(15),
                color: AppColors.textColor2,
                fontWeight: FontWeight.w600,
              ),
            ),
            // subtitle: Text(
            //   displayName ?? '',
            //   style: TextStyle(
            //     fontSize: getScreenHeight(15),
            //     color: AppColors.textColor2.withOpacity(0.7),
            //     fontWeight: FontWeight.w400,
            //   ),
            // ),
          ),
        );
      },
    );
  }
}

class SearchStories extends HookWidget {
  const SearchStories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imgList = [
      'assets/images/frame.png',
      'assets/images/frame.png',
      'assets/images/frame.png',
    ];
    final List<Widget> imageSliders = imgList
        .map((item) => Container(
              margin: const EdgeInsets.all(5.0),
              child: Image.asset(item),
            ))
        .toList();
    final _currentIndex = useState<int>(0);
    final _showLeadingContent = useState<bool>(true);
    final _showHappeningContent = useState<bool>(true);
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(height: getScreenHeight(26)),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SizedBox(
                width: size.width,
                height: getScreenHeight(200),
                child: CarouselSlider.builder(
                  itemCount: imgList.length,
                  options: CarouselOptions(
                    height: getScreenHeight(200),
                    viewportFraction: 1,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 5),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                    disableCenter: true,
                    onPageChanged: (index, reason) {
                      _currentIndex.value = index;
                    },
                  ),
                  itemBuilder:
                      (BuildContext context, int itemIndex, int pageViewIndex) {
                    return imageSliders[itemIndex];
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: imgList.map((url) {
                  int index = imgList.indexOf(url);
                  return Container(
                    width: 7.0,
                    height: 7.0,
                    margin: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 3.0,
                    ),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentIndex.value == index
                            ? AppColors.primaryColor
                            : AppColors.greyShade4),
                  );
                }).toList(),
              ),
            ],
          ),
          SizedBox(height: getScreenHeight(26)),
          GestureDetector(
            onTap: () => _showLeadingContent.value = !_showLeadingContent.value,
            child: Container(
              width: size.width,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
              decoration: const BoxDecoration(color: AppColors.white),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Leading content',
                        style: TextStyle(
                          fontSize: getScreenHeight(17),
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor2,
                        ),
                      ),
                      SizedBox(width: getScreenWidth(8)),
                      SvgPicture.asset('assets/svgs/fire.svg')
                    ],
                  ),
                  _showLeadingContent.value
                      ? SvgPicture.asset('assets/svgs/chevron-down.svg')
                      : SvgPicture.asset('assets/svgs/chevron-up.svg'),
                ],
              ),
            ),
          ),
          SizedBox(height: getScreenHeight(10)),
          Visibility(
            visible: _showLeadingContent.value,
            child: Container(
              width: size.width,
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 25,
              ),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(children: [
                const Icon(
                  Icons.info,
                  color: AppColors.grey,
                ),
                SizedBox(height: getScreenHeight(9)),
                Text(
                  'No leading content available',
                  style: TextStyle(
                    fontSize: getScreenHeight(20),
                    color: AppColors.greyShade4,
                  ),
                )
              ]),
            ).paddingSymmetric(h: 16),
          ),
          SizedBox(height: getScreenHeight(26)),
          GestureDetector(
            onTap: () =>
                _showHappeningContent.value = !_showHappeningContent.value,
            child: Container(
              width: size.width,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
              decoration: const BoxDecoration(color: AppColors.white),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Happenings around',
                    style: TextStyle(
                      fontSize: getScreenHeight(17),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor2,
                    ),
                  ),
                  _showHappeningContent.value
                      ? SvgPicture.asset('assets/svgs/chevron-down.svg')
                      : SvgPicture.asset('assets/svgs/chevron-up.svg'),
                ],
              ),
            ),
          ),
          SizedBox(height: getScreenHeight(10)),
          Visibility(
            visible: _showHappeningContent.value,
            child: Container(
              width: size.width,
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 25,
              ),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(children: [
                const Icon(
                  Icons.info,
                  color: AppColors.grey,
                ),
                SizedBox(height: getScreenHeight(9)),
                Text(
                  'No stories available',
                  style: TextStyle(
                    fontSize: getScreenHeight(20),
                    color: AppColors.greyShade4,
                  ),
                )
              ]),
            ).paddingSymmetric(h: 16),
          ),
        ],
      ),
    );
  }
}
