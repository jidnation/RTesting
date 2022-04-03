import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/features/account/presentation/views/account.dart';
import 'package:reach_me/features/home/presentation/bloc/user_bloc.dart';
import 'package:reach_me/features/home/presentation/views/search.dart';
import 'package:reach_me/features/home/presentation/views/timeline.dart';
import 'package:reach_me/features/home/presentation/views/video_moment.dart';
import 'package:reach_me/features/home/presentation/widgets/app_drawer.dart';
import 'package:reach_me/features/home/presentation/views/notification.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:flutter/material.dart';

class HomeScreen extends HookWidget {
  static const String id = "home_screen";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _currentIndex = useState<int>(0);
    useMemoized(() {
      globals.userBloc!.add(GetUserProfileEvent(email: globals.user!.email));
    });
    return Scaffold(
      drawer: const AppDrawer(),
      body: IndexedStack(
        children: const [
          TimelineScreen(),
          SearchScreen(),
          VideoMomentScreen(),
          NotificationsScreen(),
          AccountScreen(),
        ],
        index: _currentIndex.value,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex.value,
        onTap: (index) => _currentIndex.value = index,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.blackShade3,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/svgs/home.svg',
                color: _currentIndex.value == 0
                    ? AppColors.primaryColor
                    : AppColors.blackShade3),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/svgs/search icon.svg',
                color: _currentIndex.value == 1
                    ? AppColors.primaryColor
                    : AppColors.blackShade3),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/svgs/media.svg',
                color: _currentIndex.value == 2
                    ? AppColors.primaryColor
                    : AppColors.blackShade3),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/svgs/notification icon.svg',
                color: _currentIndex.value == 3
                    ? AppColors.primaryColor
                    : AppColors.blackShade3),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/svgs/profile icon.svg',
                color: _currentIndex.value == 4
                    ? AppColors.primaryColor
                    : AppColors.blackShade3),
            label: '',
          ),
        ],
      ),
    );
  }
}
