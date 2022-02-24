import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/screens/onboarding/rm_onboarding_model.dart';
import 'package:flutter/material.dart';
import 'package:reach_me/utils/constants.dart';
import 'package:reach_me/utils/extensions.dart';

class RMOnboardingScreen extends StatefulWidget {
  final List<RMOnboardingModel>? pages;
  final Color? bgColor;
  final Color? themeColor;
  final ValueChanged<String>? skipClicked;
  final ValueChanged<String>? getStartedClicked;

  const RMOnboardingScreen({
    Key? key,
    this.pages,
    this.bgColor,
    this.themeColor,
    this.skipClicked,
    this.getStartedClicked,
  }) : super(key: key);

  @override
  RMOnboardingScreenState createState() => RMOnboardingScreenState();
}

class RMOnboardingScreenState extends State<RMOnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < widget.pages!.length; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  List<Widget> buildOnboardingPages() {
    final children = <Widget>[];

    for (int i = 0; i < widget.pages!.length; i++) {
      children.add(_showPageData(widget.pages![i]));
    }
    return children;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      alignment: Alignment.center,
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 4.9),
      height: 3.4,
      width: 20.0,
      decoration: BoxDecoration(
        color: isActive ? widget.themeColor : const Color(0xFFC4C4C4),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: widget.bgColor,
      body: SafeArea(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 20),
                SizedBox(
                  height: size.height * 0.6,
                  width: size.width,
                  child: Container(
                    color: Colors.transparent,
                    child: PageView(
                        physics: const ClampingScrollPhysics(),
                        controller: _pageController,
                        onPageChanged: (int page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        children: buildOnboardingPages()),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Align(
                    alignment: FractionalOffset.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildPageIndicator(),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: FractionalOffset.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          bottom: 10,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            widget.skipClicked!("Skip Tapped");
                          },
                          child: const Text(
                            'Skip',
                            style: TextStyle(
                                color: AppColors.greyShade3,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600),
                          ).paddingAll(10),
                        ),
                      ),
                    ),
                    Align(
                      alignment: FractionalOffset.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20, bottom: 10),
                        child: GestureDetector(
                          onTap: () {
                            _currentPage != widget.pages!.length - 1
                                ? _pageController.nextPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.ease,
                                  )
                                : _getStartedTapped();
                          },
                          child: const Text(
                            'Next',
                            style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600),
                          ).paddingAll(10),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _showPageData(RMOnboardingModel page) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Center(
          child: SvgPicture.asset(
            page.imagePath,
            height: page.imagePath == 'assets/svgs/illustration 3-new.svg'
                ? 190
                : 220,
            width: 220,
          ),
        ),
        const SizedBox(height: 96.0),
        page.title != ''
            ? Text(
                page.title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: page.titleColor,
                  fontSize: 25,
                ),
              )
            : const SizedBox(height: 5.0),
        const SizedBox(height: 6.0),
        Text(
          page.description,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: page.descripColor,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  void _getStartedTapped() {
    widget.getStartedClicked!("Get Started Tapped");
  }
}
