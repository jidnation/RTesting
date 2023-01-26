import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:reach_me/core/utils/constants.dart';

class StatusIndicator extends StatelessWidget {
  final double percent;
  const StatusIndicator({Key? key, required this.percent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      child: LinearPercentIndicator(
        percent: percent,
        padding: EdgeInsets.zero,
        progressColor: AppColors.white,
        backgroundColor: Colors.white24,
        lineHeight: 2,
        // animation: true,
        barRadius: const Radius.circular(16),
      ),
    );
  }
}
