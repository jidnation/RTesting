import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';

class RMSpinner extends StatelessWidget {
  const RMSpinner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset('assets/gifs/spinner.json'),
    );
  }
}

class RMLoader {
  static show(BuildContext context) {
    return Loader.show(context,
        progressIndicator: const RMSpinner(), overlayColor: Colors.white30);
  }

  static hide() {
    return Loader.hide();
  }
}
