import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:reach_me/core/utils/constants.dart';

class RLoader extends StatefulWidget {
  const RLoader(this.text, {Key? key, this.textStyle, this.isText = false})
      : super(key: key);
  final String text;
  final TextStyle? textStyle;
  final bool isText;

  @override
  _RLoaderState createState() => _RLoaderState();
}

class _RLoaderState extends State<RLoader> with TickerProviderStateMixin {
  AnimationController? animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )
      ..forward()
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return !widget.isText
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: AnimatedBuilder(
                  animation: animationController!,
                  builder: (context, child) {
                    return Container(
                      decoration: const ShapeDecoration(
                        color: AppColors.backgroundShade2,
                        shape: CircleBorder(),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.all(20.0 * animationController!.value),
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                      decoration: const ShapeDecoration(
                        shape: CircleBorder(),
                      ),
                      child: SvgPicture.asset('assets/svgs/logo-new.svg')
                      // )
                      ),
                ),
              ),
              const Gap(10),
              Text(
                widget.text,
                style:
                    widget.textStyle ?? Theme.of(context).textTheme.bodyText1!,
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.text,
                style: widget.textStyle,
              ),
              const Gap(10),
              const SizedBox(
                height: 15,
                width: 15,
                child: CircularProgressIndicator(
                  strokeWidth: 0.6,
                ),
              )
            ],
          );
  }
}
