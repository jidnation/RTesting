import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:neon_circular_timer/neon_circular_timer.dart';

import 'constants.dart';

class CountDownTimer extends StatelessWidget {
  final int time;
  final CameraController? controller;
  final Function()? onFinish;
  final CountDownController timeController;
  const CountDownTimer({
    Key? key,
    required this.time,
    this.controller,
    required this.timeController,
    this.onFinish,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // stopWatchTimer.secondTime.listen((value) => displayTime = value);
    // stopWatchTimer.onStartTimer();
    return Column(children: [
      NeonCircularTimer(
        onComplete: onFinish,
        width: 44,
        controller: timeController,
        duration: time,
        strokeWidth: 2,
        isReverse: true,
        isTimerTextShown: true,
        neumorphicEffect: true,
        outerStrokeColor: AppColors.black.withOpacity(0.8),
        innerFillGradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomLeft,
            colors: [
              AppColors.primaryColor,
              AppColors.primaryColor,
            ]),
        neonGradient: LinearGradient(
            colors: [Colors.greenAccent.shade200, Colors.blueAccent.shade400]),
        strokeCap: StrokeCap.round,
        innerFillColor: Colors.black12,
        backgroudColor: Colors.transparent,
        textStyle: const TextStyle(
          fontSize: 12.44,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        neonColor: Colors.blue.shade900,
      ),
    ]);
  }
}
