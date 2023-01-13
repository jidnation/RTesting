import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reach_me/features/moment/user_posting.dart';

import '../../../../../../core/utils/custom_text.dart';

class CountDown extends ValueNotifier<int> {
  late StreamSubscription sub;

  CountDown({required int from}) : super(from) {
    sub = Stream.periodic(
      const Duration(seconds: 1),
      (v) => from - v,
    ).takeWhile((value) => value >= 0).listen((value) {
      this.value = value;
    });
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }
}

class CountDownTimer extends HookWidget {
  final int from;
  final CameraController vController;
  const CountDownTimer({
    required this.vController,
    required this.from,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final countDown = useMemoized(() => CountDown(from: from));
    final notifier = useListenable(countDown);
    // momentCtrl.momentCounter(1);
    if (notifier.value == 0) {
      startRecording();
    }
    return CustomText(
      text: notifier.value.toString(),
      weight: FontWeight.w500,
      color: notifier.value < 5
          ? Colors.red
          : notifier.value < 10
              ? Colors.yellow
              : Colors.green,
      size: 90,
    );

    //   Button2(
    //   text: notifier.value == 0 ? actionText : notifier.value.toString(),
    //   isBorder: true,
    //   width: 120,
    //   color: notifier.value == 0 ? null : Colors.grey,
    //   event: notifier.value == 0 ? onClick : null,
    // );
  }

  startRecording() async {
    stopTimer();
    await momentVideoControl.startVideoRecording(
      videoController: vController,
    );
  }

  stopTimer() async {
    await Future.delayed(const Duration(seconds: 1));
    momentCtrl.momentCounter(0);
  }
}
