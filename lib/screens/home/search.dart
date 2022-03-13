import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/components/custom_textfield.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/screens/home/widgets/app_drawer.dart';
import 'package:reach_me/utils/constants.dart';
import 'package:reach_me/utils/extensions.dart';

class SearchScreen extends StatelessWidget {
  static const String id = "search_screen";
  SearchScreen({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: const AppDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.grey.shade50,
          elevation: 0,
          leading: IconButton(
            onPressed: () => _scaffoldKey.currentState!.openDrawer(),
            icon: Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryColor,
                image: DecorationImage(
                  image: AssetImage("assets/images/user.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ).paddingOnly(t: 10),
          title: CustomRoundTextField(hintText: 'Search Reach',).paddingOnly(t: 10),
          actions: [
            IconButton(
              icon: SvgPicture.asset('assets/svgs/Vector.svg',
                  width: 25, height: 25),
              onPressed: () {},
            ).paddingOnly(t: 10),
          ],
        ),
        body: Container());
  }
}
