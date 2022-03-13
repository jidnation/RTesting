import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/screens/account/views/account.dart';
import 'package:reach_me/screens/home/widgets/app_drawer.dart';
import 'package:reach_me/screens/timeline/timeline.dart';
import 'package:reach_me/screens/home/video_moment.dart';
import 'package:reach_me/screens/activity/presentation/notification.dart';
import 'package:reach_me/screens/home/search.dart';
import 'package:reach_me/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:reach_me/utils/extensions.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "home_screen";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  setStateIfMounted(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: const AppDrawer(),
      body: IndexedStack(
        children: [
          TimelineScreen(),
          SearchScreen(),
          const VideoMomentScreen(),
          const NotificationsScreen(),
          const AccountScreen(),
        ],
        index: _currentIndex,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setStateIfMounted(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.blackShade3,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/svgs/home.svg',
                color: _currentIndex == 0
                    ? AppColors.primaryColor
                    : AppColors.blackShade3),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/svgs/search icon.svg',
                color: _currentIndex == 1
                    ? AppColors.primaryColor
                    : AppColors.blackShade3),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/svgs/media.svg',
                color: _currentIndex == 2
                    ? AppColors.primaryColor
                    : AppColors.blackShade3),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/svgs/notification icon.svg',
                color: _currentIndex == 3
                    ? AppColors.primaryColor
                    : AppColors.blackShade3),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/svgs/profile icon.svg',
                color: _currentIndex == 4
                    ? AppColors.primaryColor
                    : AppColors.blackShade3),
            label: '',
          ),
        ],
      ),
    );
  }
}
