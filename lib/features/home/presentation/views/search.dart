import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/components/custom_textfield.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/features/account/presentation/widgets/image_placeholder.dart';
import 'package:reach_me/features/home/presentation/widgets/app_drawer.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:carousel_slider/carousel_slider.dart';

class SearchScreen extends HookWidget {
  static const String id = "search_screen";
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = useState(GlobalKey<ScaffoldState>());
    final _searchController = useTextEditingController();
    var size = MediaQuery.of(context).size;
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
    return Scaffold(
      key: _scaffoldKey.value,
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        elevation: 0,
        leading: IconButton(
          padding: const EdgeInsets.all(0),
          onPressed: () => _scaffoldKey.value.currentState!.openDrawer(),
          icon: ImagePlaceholder(
            width: getScreenWidth(40),
            height: getScreenHeight(40),
          ),
        ).paddingOnly(t: 10, l: 10),
        title: CustomRoundTextField(
          hintText: 'Search ReachMe',
          fillColor: AppColors.white,
          controller: _searchController,
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
        child: SingleChildScrollView(
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
                      itemBuilder: (BuildContext context, int itemIndex,
                          int pageViewIndex) {
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
                onTap: () =>
                    _showLeadingContent.value = !_showLeadingContent.value,
                child: Container(
                  width: size.width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
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
        ),
      ),
    );
  }
}
