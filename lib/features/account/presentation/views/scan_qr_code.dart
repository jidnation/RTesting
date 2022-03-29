import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/constants.dart';

class ScanQRCodeScreen extends StatelessWidget {
  static const String id = 'scan_qr_code_screen';
  const ScanQRCodeScreen({Key? key}) : super(key: key);

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
            onPressed: () => NavigationService.goBack()),
        actions: [
          IconButton(
              icon: SvgPicture.asset('assets/svgs/image.svg',
                  width: 25, height: 25, color: AppColors.black),
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
                child: SvgPicture.asset('assets/svgs/scanning-qr-code.svg'),
              ),
            ),
            TextButton(
              onPressed: () => NavigationService.goBack(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset('assets/svgs/scan-qr-code.svg'),
                  const SizedBox(width: 6),
                  const Text(
                    'Go to your QR Code',
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
