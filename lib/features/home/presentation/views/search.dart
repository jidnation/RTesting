import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/components/custom_textfield.dart';
import 'package:reach_me/features/home/presentation/widgets/app_drawer.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/extensions.dart';

class SearchScreen extends HookWidget {
  static const String id = "search_screen";
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = useState(GlobalKey<ScaffoldState>());
    return Scaffold(
        key: _scaffoldKey.value,
        drawer: const AppDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.grey.shade50,
          elevation: 0,
          leading: IconButton(
            onPressed: () => _scaffoldKey.value.currentState!.openDrawer(),
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
          title: const CustomRoundTextField(
            hintText: 'Search Reach',
          ).paddingOnly(t: 10),
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
