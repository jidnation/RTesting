import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/features/onboarding/rm_onboarding_model.dart';
import 'package:flutter/material.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/extensions.dart';

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
      height: 9,
      width: isActive ? 15 : 9,
      decoration: BoxDecoration(
        color: isActive && _currentPage == 0
            ? const Color(0xFF86D5FF)
            : isActive && _currentPage == 1
                ? const Color(0xFFFFCD4B)
                : isActive && _currentPage == 2
                    ? const Color(0xFFFF7676)
                    : const Color(0xFFC4C4C4),
        borderRadius: const BorderRadius.all(Radius.circular(100)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          const SizedBox(height: 20),
          SizedBox(
            height: size.height * 0.7,
            width: size.width,
            child: Container(
              color: Colors.transparent,
              child: PageView(
                  physics: const BouncingScrollPhysics(),
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
          SizedBox(height: getScreenHeight(100)),
          Row(
            mainAxisAlignment: _currentPage == widget.pages!.length - 1
                ? MainAxisAlignment.center
                : MainAxisAlignment.spaceBetween,
            children: [
              _currentPage == widget.pages!.length - 1
                  ? const SizedBox.shrink()
                  : Align(
                      alignment: FractionalOffset.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          bottom: 10,
                        ),
                        child: GestureDetector(
                          onTap: () => widget.skipClicked!("Skip Tapped"),
                          child: const Text(
                            'Skip',
                            style: TextStyle(
                                color: AppColors.greyShade3,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600),
                          ).paddingAll(14),
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
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.textColor2,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _currentPage != widget.pages!.length - 1
                            ? "Next"
                            : "Let's get started",
                        style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600),
                      ).paddingSymmetric(
                          h: _currentPage == widget.pages!.length - 1
                              ? getScreenWidth(100)
                              : getScreenWidth(25),
                          v: getScreenHeight(10)),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
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
          ),
        ),
        SizedBox(height: getScreenHeight(30)),
        Text(
          page.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: page.titleColor,
            fontSize: 20,
          ),
        ),
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
    ).paddingSymmetric(h: 20);
  }

  void _getStartedTapped() {
    widget.getStartedClicked!("Get Started Tapped");
  }
}
