import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reach_me/core/components/snackbar.dart';
import 'package:scan/scan.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/features/account/presentation/views/account.dart';
import 'package:reach_me/features/account/presentation/views/qr_code.dart';
import 'package:reach_me/features/home/presentation/bloc/user-bloc/user_bloc.dart';

import '../../../profile/new_account.dart';
import '../../../profile/recipientNewAccountProfile.dart';

class ScanQRCodeScreen extends StatefulWidget {
  static const String id = 'scan_qr_code_screen';
  const ScanQRCodeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ScanQRCode();
}

class ScanQRCode extends State<ScanQRCodeScreen> {
  Barcode? result;
  late final String? id = result!.code.toString();
  late final String? imageUrl;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  String qrcode = 'Unknown';

  @override
  void initState() {
    super.initState();
    globals.userBloc!.add(GetUserProfileEvent(email: globals.userId!));
    controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: ProgressHUD(
        child: Builder(builder: (context) {
          return Stack(
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
                      icon: SvgPicture.asset('assets/svgs/gallery.svg',
                          width: 25, height: 25, color: AppColors.white),
                      onPressed: () async {
                        final ImagePicker _picker = ImagePicker();
                        final XFile? res = await _picker.pickImage(
                            source: ImageSource.gallery);
                        if (res != null) {
                          String? str = await Scan.parse(res.path);
                          if (str != null) {
                            setState(() {
                              qrcode = str;
                            });
                            controller!.dispose();
                            final progress = ProgressHUD.of(context);
                            progress?.showWithText('Viewing Reacher..');
                            Future.delayed(const Duration(seconds: 3), () {
                              globals.userBloc!
                                  .add(GetRecipientProfileEvent(email: str));
                              str == globals.user!.id
                                  ? RouteNavigators.route(
                                      context, const NewAccountScreen())
                                  : RouteNavigators.route(
                                      context,
                                      RecipientNewAccountScreen(
                                        recipientEmail: 'email',
                                        //recipientImageUrl: imageUrl,
                                        recipientId: str,
                                      ));
                              progress?.dismiss();
                            });
                          } else {
                            Snackbars.error(context,
                                message: "No QR Code Found");
                          }
                        }
                      },
                    ),
                  ],
                ),
                body: ProgressHUD(
                  child: Builder(builder: (context) {
                    return Stack(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: size.height,
                              width: size.width,
                              child: QRView(
                                key: qrKey,
                                onQRViewCreated: (QRViewController controller) {
                                  setState(() {
                                    this.controller = controller;
                                  });
                                  controller.scannedDataStream
                                      .listen((scanData) {
                                    setState(() {
                                      result = scanData;
                                    });
                                    if (result != null) {
                                      controller.dispose();
                                      final progress = ProgressHUD.of(context);
                                      progress
                                          ?.showWithText('Viewing Reacher..');
                                      Future.delayed(const Duration(seconds: 3),
                                          () {
                                        globals.userBloc!.add(
                                            GetRecipientProfileEvent(
                                                email: id));
                                        id == globals.user!.id
                                            ? RouteNavigators.route(context,
                                                const NewAccountScreen())
                                            : RouteNavigators.route(
                                                context,
                                                RecipientNewAccountScreen(
                                                  recipientEmail: 'email',
                                                  //recipientImageUrl: imageUrl,
                                                  recipientId: id,
                                                ));
                                        progress?.dismiss();
                                      });
                                    }
                                  });
                                  controller.pauseCamera();
                                  controller.resumeCamera();
                                },
                                overlay: QrScannerOverlayShape(
                                  borderColor: AppColors.white,
                                  borderRadius: 18,
                                  borderLength: 40,
                                  borderWidth: 7,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: getScreenHeight(100),
                        ),
                        SizedBox(
                          height: size.height,
                          width: size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => {
                                  RouteNavigators.route(
                                      context, const QRCodeScreen()),
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/svgs/qrcode.svg',
                                      color: AppColors.white,
                                    ),
                                    const SizedBox(width: 6),
                                    const Text(
                                      'Go to your QR Code',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
