import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../core/utils/constants.dart';

class LoadingEffect extends StatelessWidget {
  const LoadingEffect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 30,
        width: 30,
        child: LoadingIndicator(
            indicatorType: Indicator.ballScaleMultiple,
            // indicatorType: Indicator.lineSpinFadeLoader,

            /// Required, The loading type of the widget
            colors: [
              AppColors.primaryColor.withOpacity(0.3),
              AppColors.primaryColor.withOpacity(0.5),
              Colors.grey,
              AppColors.primaryColor.withOpacity(0.7),
              AppColors.primaryColor.withOpacity(0.9),
            ],

            /// Optional, The color collections
            strokeWidth: 50,

            /// Optional, The stroke of the line, only applicable to widget which contains line
            backgroundColor: Colors.transparent,

            /// Optional, Background of the widget
            pathBackgroundColor: Colors.transparent

            /// Optional, the stroke backgroundColor
            ),
      ),
    );
  }
}

SizedBox loadingEffect2({double? width, double? height, Color? color}) {
  return SizedBox(
    height: height ?? 120,
    width: width ?? 120,
    child: LoadingIndicator(
        indicatorType: Indicator.orbit,
        colors: [
          AppColors.primaryColor.withOpacity(0.9),
          AppColors.primaryColor.withOpacity(0.6),
          AppColors.primaryColor.withOpacity(0.8),
          AppColors.primaryColor.withOpacity(0.5),
          AppColors.primaryColor.withOpacity(0.4),
        ],
        // strokeWidth: 29,
        backgroundColor: Colors.transparent,
        pathBackgroundColor: Colors.transparent),
  );
}

SizedBox loadingEffect3({double? width, double? height, Color? color}) {
  return SizedBox(
    height: 20,
    width: 20,
    child: LoadingIndicator(
        indicatorType: Indicator.audioEqualizer,
        colors: [
          AppColors.black.withOpacity(0.9),
          AppColors.black.withOpacity(0.6),
          AppColors.black.withOpacity(0.8),
          AppColors.black.withOpacity(0.5),
          AppColors.black.withOpacity(0.4),
        ],
        // strokeWidth: 29,
        backgroundColor: Colors.transparent,
        pathBackgroundColor: Colors.transparent),
  );
}
