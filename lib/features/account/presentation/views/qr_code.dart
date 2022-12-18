import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:share_files_and_screenshot_widgets/share_files_and_screenshot_widgets.dart';

class QRCodeScreen extends StatefulWidget {
  static const String id = 'qr_code_screen';
  const QRCodeScreen({Key? key}) : super(key: key);

  @override
  State<QRCodeScreen> createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  GlobalKey reachMeID = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Scaffold(
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              elevation: 0,
              toolbarHeight: 50,
              leading: IconButton(
                  icon: SvgPicture.asset('assets/svgs/back.svg',
                      width: 19, height: 12, color: AppColors.white),
                  onPressed: () => RouteNavigators.pop(context)),
              actions: [
                IconButton(
                    icon: SvgPicture.asset('assets/svgs/share.svg',
                        width: 25, height: 25, color: AppColors.white),

                    onPressed: () {
                      ShareFilesAndScreenshotWidgets().shareScreenshot(
                          reachMeID,
                          800,
                          "Share your reach ID using:",
                          "${globals.user!.username ?? 'username'}-ReachMeID.png",
                          "image/png",
                          text:
                              "Hi, this is my reach ID\nScan with Reachme to reach me");
                    }),
              ],
            ),
            body: RepaintBoundary(
              key: reachMeID,
              child: Container(
                height: size.height,
                width: size.width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/qrcode-bg.jpg"),
                      fit: BoxFit.cover),
                ),
                child: Column(children: [
                  SizedBox(height: getScreenHeight(350)),
                  SizedBox(
                    child: QrImage(
                      data: globals.user!.id.toString(),
                      version: QrVersions.auto,
                      size: 200.0,
                      foregroundColor: AppColors.primaryColor,
                      backgroundColor: AppColors.whiteBackground,
                    ),
                  ),
                  SizedBox(height: getScreenHeight(200)),
                  TextButton(
                    onPressed: () => RouteNavigators.pop(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/svgs/scan.svg',
                          color: AppColors.white,
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Scan QR Code',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: AppColors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
