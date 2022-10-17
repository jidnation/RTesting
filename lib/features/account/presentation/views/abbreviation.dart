// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:reach_me/core/components/custom_button.dart';
// import 'package:reach_me/core/components/custom_textfield.dart';
// import 'package:reach_me/core/services/navigation/navigation_service.dart';
// import 'package:reach_me/core/utils/constants.dart';
// import 'package:reach_me/core/utils/extensions.dart';

// class Abbreviation extends StatelessWidget {
//   static const String id = "abbreviation";
//   const Abbreviation({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//               icon: SvgPicture.asset(
//                 'assets/svgs/arrow-back.svg',
//                 width: 19,
//                 height: 12,
//                 color: AppColors.black,
//               ),
//               onPressed: () => RouteNavigators.pop(context)),
//           backgroundColor: Colors.grey.shade50,
//           centerTitle: true,
//           elevation: 0,
//           toolbarHeight: 50,
//           title: const Text(
//             'Abbreviation',
//             style: TextStyle(
//                 fontSize: 23,
//                 fontWeight: FontWeight.w400,
//                 color: AppColors.textColor2),
//           ),
//         ),
//         body: SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Divider(thickness: 0.5, color: AppColors.textColor2),
//               TextButton(
//                 onPressed: () => Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const SearchAbbreviation())),
//                 style: TextButton.styleFrom(padding: EdgeInsets.zero),
//                 child: const ListTile(
//                     dense: true,
//                     title: Text('Search Abbreviation',
//                         style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w400,
//                             color: AppColors.textColor2))),
//               ),
//               TextButton(
//                 onPressed: () => Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) =>
//                             const RecentlyAddedAbbreviation())),
//                 style: TextButton.styleFrom(padding: EdgeInsets.zero),
//                 child: const ListTile(
//                     dense: true,
//                     title: Text('Recently added',
//                         style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w400,
//                             color: AppColors.textColor2))),
//               ),
//               TextButton(
//                 onPressed: () => Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const HistoryAbbreviation())),
//                 style: TextButton.styleFrom(padding: EdgeInsets.zero),
//                 child: const ListTile(
//                     dense: true,
//                     title: Text('History',
//                         style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w400,
//                             color: AppColors.textColor2))),
//               ),
//               TextButton(
//                 onPressed: () => Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const AbbreviationLibrary())),
//                 style: TextButton.styleFrom(padding: EdgeInsets.zero),
//                 child: const ListTile(
//                     dense: true,
//                     title: Text('Abbreviation library',
//                         style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w400,
//                             color: AppColors.textColor2))),
//               ),
//             ],
//           ),
//         ));
//   }
// }

// class SearchAbbreviation extends StatelessWidget {
//   const SearchAbbreviation({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.grey.shade50,
//           elevation: 0,
//           leading: IconButton(
//               icon: SvgPicture.asset('assets/svgs/arrow-back.svg',
//                   color: AppColors.black, width: 19, height: 12),
//               onPressed: () => RouteNavigators.pop(context)).paddingOnly(t: 10),
//           title: const CustomRoundTextField(
//             hintText: 'Search Abbreviation',
//           ).paddingOnly(t: 10),
//           actions: [
//             IconButton(
//               icon: SvgPicture.asset('assets/svgs/search.svg'),
//               onPressed: () {},
//             ).paddingOnly(t: 10, r: 10),
//           ],
//         ),
//         body: Column(
//           children: [
//             const Spacer(),
//             CustomButton(
//               label: 'Add to Dictionary',
//               color: AppColors.primaryColor,
//               onPressed: () {},
//               size: size,
//               textColor: AppColors.white,
//               borderSide: BorderSide.none,
//             ).paddingOnly(b: 20, r: 50, l: 50)
//           ],
//         ));
//   }
// }

// class RecentlyAddedAbbreviation extends StatelessWidget {
//   const RecentlyAddedAbbreviation({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//               icon: SvgPicture.asset('assets/svgs/arrow-back.svg',
//                   width: 19, height: 12, color: AppColors.black),
//               onPressed: () => RouteNavigators.pop(context)),
//           backgroundColor: Colors.grey.shade50,
//           centerTitle: true,
//           elevation: 0,
//           toolbarHeight: 50,
//           title: const Text(
//             'Recently added',
//             style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.w400,
//                 color: AppColors.textColor2),
//           ),
//         ),
//         body: SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               const Divider(thickness: 0.5, color: AppColors.textColor2),
//               ListTile(
//                 title: RichText(
//                     text: const TextSpan(children: [
//                   TextSpan(
//                       text: 'Assn: ',
//                       style: TextStyle(
//                           fontSize: 13,
//                           fontFamily: 'Poppins',
//                           fontWeight: FontWeight.w400,
//                           color: AppColors.primaryColor)),
//                   TextSpan(
//                       text:
//                           'Association; a connection or cooperative link between people or organizations.',
//                       style: TextStyle(
//                           fontSize: 13,
//                           fontFamily: 'Poppins',
//                           fontWeight: FontWeight.w400,
//                           color: AppColors.textColor2)),
//                 ])),
//                 subtitle: const Text('2021-06-13'),
//                 trailing: const Icon(Icons.close,
//                     color: AppColors.textColor2, size: 19),
//               ),
//               ListTile(
//                 title: RichText(
//                     text: const TextSpan(children: [
//                   TextSpan(
//                       text: 'Assn: ',
//                       style: TextStyle(
//                           fontSize: 13,
//                           fontFamily: 'Poppins',
//                           fontWeight: FontWeight.w400,
//                           color: AppColors.primaryColor)),
//                   TextSpan(
//                       text:
//                           'Association; a connection or cooperative link between people or organizations.',
//                       style: TextStyle(
//                           fontSize: 13,
//                           fontFamily: 'Poppins',
//                           fontWeight: FontWeight.w400,
//                           color: AppColors.textColor2)),
//                 ])),
//                 subtitle: const Text('2021-06-13'),
//                 trailing: const Icon(Icons.close,
//                     color: AppColors.textColor2, size: 19),
//               ),
//             ],
//           ),
//         ));
//   }
// }

// class HistoryAbbreviation extends StatelessWidget {
//   const HistoryAbbreviation({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

// class AbbreviationLibrary extends StatelessWidget {
//   const AbbreviationLibrary({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//               icon: SvgPicture.asset('assets/svgs/arrow-back.svg',
//                   width: 19, height: 12, color: AppColors.black),
//               onPressed: () => RouteNavigators.pop(context)),
//           backgroundColor: Colors.grey.shade50,
//           centerTitle: true,
//           elevation: 0,
//           toolbarHeight: 50,
//           title: const Text(
//             'Abbreviation Library',
//             style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.w400,
//                 color: AppColors.textColor2),
//           ),
//         ),
//         body: SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               const Divider(thickness: 0.5, color: AppColors.textColor2),
//               ListTile(
//                 title: RichText(
//                     text: const TextSpan(children: [
//                   TextSpan(
//                       text: 'Assn: ',
//                       style: TextStyle(
//                           fontSize: 13,
//                           fontFamily: 'Poppins',
//                           fontWeight: FontWeight.w400,
//                           color: AppColors.primaryColor)),
//                   TextSpan(
//                       text:
//                           'Association; a connection or cooperative link between people or organizations.',
//                       style: TextStyle(
//                           fontSize: 13,
//                           fontFamily: 'Poppins',
//                           fontWeight: FontWeight.w400,
//                           color: AppColors.textColor2)),
//                 ])),
//                 subtitle: const Text('2021-06-13'),
//                 trailing: const Icon(Icons.close,
//                     color: AppColors.textColor2, size: 19),
//               ),
//               ListTile(
//                 title: RichText(
//                     text: const TextSpan(children: [
//                   TextSpan(
//                       text: 'Assn: ',
//                       style: TextStyle(
//                           fontSize: 13,
//                           fontFamily: 'Poppins',
//                           fontWeight: FontWeight.w400,
//                           color: AppColors.primaryColor)),
//                   TextSpan(
//                       text:
//                           'Association; a connection or cooperative link between people or organizations.',
//                       style: TextStyle(
//                           fontSize: 13,
//                           fontFamily: 'Poppins',
//                           fontWeight: FontWeight.w400,
//                           color: AppColors.textColor2)),
//                 ])),
//                 subtitle: const Text('2021-06-13'),
//                 trailing: const Icon(Icons.close,
//                     color: AppColors.textColor2, size: 19),
//               ),
//             ],
//           ),
//         ));
//   }
// }
