import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:reach_me/core/utils/dimensions.dart';

class QRCodeScreen extends StatelessWidget {
  static const String id = 'qr_code_screen';
  const QRCodeScreen({Key? key}) : super(key: key);

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
                    onPressed: () => {}),
              ],
            ),
            body: Container(
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
        ],
      ),
    );
  }
}
