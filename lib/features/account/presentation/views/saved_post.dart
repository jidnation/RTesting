import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/components/media_card.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/features/account/presentation/widgets/saved_post_reacher_card.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/extensions.dart';

class SavedPostScreen extends StatelessWidget {
  static const String id = "saved_post_screen";
  const SavedPostScreen({Key? key}) : super(key: key);
  TabBar get _tabBar => const TabBar(
        isScrollable: false,
        indicatorWeight: 1.5,
        indicator: UnderlineTabIndicator(
          insets: EdgeInsets.symmetric(horizontal: 20.0),
          borderSide: BorderSide(
            width: 2.0,
            color: AppColors.primaryColor,
          ),
        ),
        indicatorColor: AppColors.primaryColor,
        unselectedLabelColor: AppColors.greyShade4,
        labelColor: AppColors.primaryColor,
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
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                icon: SvgPicture.asset(
                  'assets/svgs/arrow-back.svg',
                  width: 19,
                  height: 12,
                  color: AppColors.black,
                ),
                onPressed: () => NavigationService.goBack()),
            backgroundColor: Colors.grey.shade50,
            centerTitle: true,
            elevation: 0,
            toolbarHeight: 50),
        body: DefaultTabController(
          length: 3,
          child: Column(
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
                        bottom:
                            BorderSide(color: AppColors.greyShade5, width: 1.0),
                      ),
                    ),
                  ),
                  _tabBar
                ],
              ),
              Expanded(
                child: TabBarView(children: [
                  ListView(
                    children: [
                      SavedPostReacherCard(size: size),
                      SavedPostReacherCard(size: size, isVideo: true),
                    ],
                  ),
                  Center(
                    child: Wrap(
                      runSpacing: 20,
                      spacing: 20,
                      children: [
                        MediaCard(size: size, height: 160, width: 160),
                        MediaCard(size: size, height: 160, width: 160),
                        MediaCard(size: size, height: 160, width: 160),
                        MediaCard(size: size, height: 160, width: 160),
                        MediaCard(size: size, height: 160, width: 160),
                        MediaCard(size: size, height: 160, width: 160),
                        MediaCard(size: size, height: 160, width: 160),
                      ],
                    ).paddingOnly(r: 20, l: 20, t: 20),
                  ),
                  ListView(
                    children: [
                      SavedPostReacherCard(size: size),
                      SavedPostReacherCard(size: size, isVideo: true),
                    ],
                  ),
                ]),
              ),
            ],
          ),
        ));
  }
}
