import 'package:flutter_bloc/flutter_bloc.dart';
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

class HomeScreen extends StatefulHookWidget {
  static const String id = "home_screen";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    globals.userBloc!
        .add(GetUserProfileEvent(email: globals.loginResponse!.email));
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _currentIndex = useState<int>(0);
    // useMemoized(() {
    //   globals.userBloc!
    //       .add(GetUserProfileEvent(email: globals.loginResponse!.email));
    //   // globals.userBloc!
    //   //     .add(FetchAllUsersByNameEvent(limit: 100, pageNumber: 1, query: ''));
    // }, [globals.user!]);
    print(globals.loginResponse!.toJson());
    return BlocConsumer<UserBloc, UserState>(
        bloc: globals.userBloc,
        listener: (context, state) {
          if (state is UserData) {
            globals.user = state.user;
          }
          // if (state is FetchUsersSuccess) {
          //   globals.userList = state.user;
          // }
        },
        builder: (context, state) {
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
            bottomNavigationBar: BottomNavBar(currentIndex: _currentIndex),
          );
        });
  }
}

// class CustomBottomNav extends StatelessWidget {
//   const CustomBottomNav({
//     Key? key,
//     required this.selectedMenu,
//     required this.onChanged,
//   }) : super(key: key);
//   final Menu selectedMenu;
//   final ValueChanged<int> onChanged;

//   @override
//   Widget build(BuildContext context) {
//     //for when the menu option is not clicked
//     const inActiveIconColor = LGTTEXT;
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     return Container(
//       height: getScreenHeight(99),
//       padding: const EdgeInsets.symmetric(horizontal: 17),
//       decoration: BoxDecoration(
//         color: isDark ? Colors.grey.shade100 : const Color(0x80F7F7F7),
//         boxShadow: [
//           BoxShadow(
//             offset: const Offset(0, -15),
//             blurRadius: 20,
//             color: isDark
//                 ? const Color(0xFFDADADA).withOpacity(0.3)
//                 : const Color(0xFFDADADA).withOpacity(0.15),
//           ),
//         ],
//       ),
//       child: SafeArea(
//         top: false,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             //home options
//             Expanded(
//               child: Column(
//                 children: [
//                   IconButton(
//                     icon: SvgPicture.asset(
//                       'assets/svgs/home.svg',
//                       color: Menu.home == selectedMenu
//                           ? PRYCOLOUR
//                           : inActiveIconColor,
//                     ),
//                     onPressed: () => onChanged(0),
//                   ),
//                   Text(
//                     'Home',
//                     style: GoogleFonts.rubik(
//                       fontSize: getScreenWidth(12),
//                       color: Menu.home == selectedMenu ? PRYCOLOUR : LGTTEXT,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             //escrow option
//             Expanded(
//               child: Column(
//                 children: [
//                   IconButton(
//                     icon: SvgPicture.asset(
//                       'assets/svgs/escrow.svg',
//                       color: Menu.escrow == selectedMenu
//                           ? PRYCOLOUR
//                           : inActiveIconColor,
//                     ),
//                     onPressed: () => onChanged(1),
//                   ),
//                   Text(
//                     'Escrow',
//                     style: GoogleFonts.rubik(
//                       fontSize: getScreenWidth(12),
//                       color: Menu.escrow == selectedMenu ? PRYCOLOUR : LGTTEXT,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             //wallet option
//             Expanded(
//               child: Column(
//                 children: [
//                   IconButton(
//                     icon: SvgPicture.asset(
//                       'assets/svgs/wallet.svg',
//                       color: Menu.wallet == selectedMenu
//                           ? PRYCOLOUR
//                           : inActiveIconColor,
//                     ),
//                     onPressed: () => onChanged(2),
//                   ),
//                   Text(
//                     'Wallet',
//                     style: GoogleFonts.rubik(
//                       fontSize: getScreenWidth(12),
//                       color: Menu.wallet == selectedMenu ? PRYCOLOUR : LGTTEXT,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             //more option
//             Expanded(
//               child: Column(
//                 children: [
//                   IconButton(
//                     icon: Icon(
//                       Icons.more_horiz,
//                       size: 20,
//                       color: Menu.more == selectedMenu
//                           ? PRYCOLOUR
//                           : inActiveIconColor,
//                     ),
//                     onPressed: () => onChanged(3),
//                   ),
//                   Text(
//                     'More',
//                     style: GoogleFonts.rubik(
//                       fontSize: getScreenWidth(12),
//                       color: Menu.more == selectedMenu ? PRYCOLOUR : LGTTEXT,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    Key? key,
    required ValueNotifier<int> currentIndex,
  })  : _currentIndex = currentIndex,
        super(key: key);

  final ValueNotifier<int> _currentIndex;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex.value,
      onTap: (index) {
        _currentIndex.value = index;
        if (index != 2) {}
        //TODO: DECLARE THE VIDEO CONTROLLER HERE
      },
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: AppColors.blackShade3,
      showUnselectedLabels: false,
      showSelectedLabels: false,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/svgs/home-a.svg',
              color: _currentIndex.value == 0
                  ? AppColors.primaryColor
                  : AppColors.blackShade3),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/svgs/search.svg',
              color: _currentIndex.value == 1
                  ? AppColors.primaryColor
                  : AppColors.blackShade3),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/svgs/play.svg',
              color: _currentIndex.value == 2
                  ? AppColors.primaryColor
                  : AppColors.blackShade3),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/svgs/notification.svg',
              color: _currentIndex.value == 3
                  ? AppColors.primaryColor
                  : AppColors.blackShade3),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/svgs/profile.svg',
              color: _currentIndex.value == 4
                  ? AppColors.primaryColor
                  : AppColors.blackShade3),
          label: '',
        ),
      ],
    );
  }
}
