import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/features/account/presentation/views/account.dart';
import 'package:reach_me/features/home/presentation/views/search.dart';
import 'package:reach_me/features/home/presentation/views/timeline.dart';
import 'package:reach_me/features/home/presentation/views/video_moment.dart';
import 'package:reach_me/features/home/presentation/widgets/app_drawer.dart';
import 'package:reach_me/features/home/presentation/views/notification.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulHookWidget {
  static const String id = "home_screen";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final scaffoldKey =
        useState<GlobalKey<ScaffoldState>>(GlobalKey<ScaffoldState>());
    final pages = [
      TimelineScreen(scaffoldKey: scaffoldKey.value),
      SearchScreen(scaffoldKey: scaffoldKey.value),
      const VideoMomentScreen(),
      const NotificationsScreen(),
      const AccountScreen(),
    ];
    final _currentIndex = useState<int>(0);
    final _pageController = usePageController(initialPage: _currentIndex.value);
    return Scaffold(
      drawer: const AppDrawer(),
      key: scaffoldKey.value,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: pages,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        pageController: _pageController,
      ),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    Key? key,
    required ValueNotifier<int> currentIndex,
    required this.pageController,
  })  : _currentIndex = currentIndex,
        super(key: key);

  final ValueNotifier<int> _currentIndex;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex.value,
      onTap: (index) {
        _currentIndex.value = index;
        pageController.jumpToPage(_currentIndex.value);
        //if (index != 2) {}
        //TODO: DECLARE THE VIDEO CONTROLLER HERE
      },
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: AppColors.blackShade3,
      showUnselectedLabels: false,
      showSelectedLabels: false,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: _currentIndex.value == 0
              ? SvgPicture.asset('assets/svgs/home-active.svg')
              : SvgPicture.asset('assets/svgs/home-a.svg',
                  color: AppColors.blackShade3),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: _currentIndex.value == 1
              ? SvgPicture.asset('assets/svgs/search-active.svg')
              : SvgPicture.asset('assets/svgs/search.svg'),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: _currentIndex.value == 2
              ? SvgPicture.asset('assets/svgs/moments-active.svg')
              : SvgPicture.asset('assets/svgs/moments.svg'),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: _currentIndex.value == 3
              ? SvgPicture.asset('assets/svgs/notification-active.svg')
              : SvgPicture.asset('assets/svgs/notification.svg'),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: _currentIndex.value == 4
              ? SvgPicture.asset('assets/svgs/profile-active.svg')
              : SvgPicture.asset('assets/svgs/profile.svg'),
          label: '',
        ),
      ],
    );
  }
}
