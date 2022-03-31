import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/features/account/presentation/views/scan_qr_code.dart';
import 'package:reach_me/core/utils/constants.dart';

class QRCodeScreen extends StatelessWidget {
  static const String id = 'qr_code_screen';
  const QRCodeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 50,
        leading: IconButton(
            icon: SvgPicture.asset('assets/svgs/arrow-back.svg',
                width: 19, height: 12, color: AppColors.black),
            onPressed: () => RouteNavigators.pop(context)),
        actions: [
          IconButton(
              icon: SvgPicture.asset('assets/svgs/share icon.svg',
                  width: 23, height: 23, color: AppColors.black),
              onPressed: () => {}),
        ],
      ),
      body: SafeArea(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(children: [
            Expanded(
              child: SizedBox(
                child: SvgPicture.asset('assets/svgs/QR Code.svg'),
              ),
            ),
            TextButton(
              onPressed: () {
                RouteNavigators.route(context, const ScanQRCodeScreen());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset('assets/svgs/scan-qr-code.svg'),
                  const SizedBox(width: 6),
                  const Text(
                    'Scan QR Code',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textColor2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ]),
        ),
      ),
    );
  }
}
