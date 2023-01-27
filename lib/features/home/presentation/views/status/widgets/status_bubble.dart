import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:reach_me/core/services/media_service.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/core/utils/helpers.dart';
import 'package:reach_me/features/home/data/models/status.model.dart';

class StatusBubble extends StatefulWidget {
  final StatusModel preview;
  final int statusCount;
  final bool? isMe;
  final bool? isLive;
  final bool? isMuted;
  final String username;
  final Function()? isMeOnTap;
  final Function()? onTap;
  const StatusBubble(
      {Key? key,
      required this.preview,
      required this.statusCount,
      this.isMe,
      this.isLive,
      this.isMuted,
      required this.username,
      this.isMeOnTap,
      this.onTap})
      : super(key: key);

  @override
  State<StatusBubble> createState() => _StatusBubbleState();
}

class _StatusBubbleState extends State<StatusBubble> {
  File? thumbnail;
  final _mediaService = MediaService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.preview.type == 'video') initVideo();
  }

  Future<void> initVideo() async {
    final res = await _mediaService.getVideoThumbnail(
        videoPath: widget.preview.statusData?.videoMedia ?? '');
    if (res == null) return;
    thumbnail = res.file;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child = Container();
    if (widget.preview.type == 'text') {
      child = Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: (widget.preview.statusData?.background ?? '').contains('0x')
              ? Helper.getStatusBgColour(widget.preview.statusData!.background!)
              : null,
          image: widget.preview.statusData?.background != null
              ? DecorationImage(
                  image:
                      AssetImage(widget.preview.statusData?.background ?? ''),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: Center(
          child: Text(
            widget.preview.statusData?.content ?? '',
            // textAlign: Helper.getAlignment(
            //     widget.preview.statusData?.alignment ??
            //         '')['align'],
            maxLines: 3,
            textAlign: TextAlign.center,
            style: Helper.getFont(widget.preview.statusData?.font ?? '',
                size: 12, height: 1),
          ),
        ),
      );
      // child = Container(
      //   color: AppColors.greyShade8,
      //   alignment: Alignment.center,
      //   padding: EdgeInsets.all(8),
      //   child: Text(
      //     (widget.preview.statusData?.content ?? 'nil'),
      //     textAlign: TextAlign.center,
      //     maxLines: 3,
      //     style: const TextStyle(fontSize: 10, height: 1),
      //   ),
      // );
    } else if (widget.preview.type == 'image') {
      child = Image.network(
        widget.preview.statusData?.imageMedia ?? '',
        fit: BoxFit.cover,
      );
    } else if (widget.preview.type == 'audio') {
      child = Center(
          child: Icon(
        Icons.audiotrack_outlined,
        color:
            (widget.isMuted ?? false) ? AppColors.grey : AppColors.primaryColor,
      ));
    } else if (widget.preview.type == 'video') {
      child = thumbnail == null
          ? Center(
              child: Icon(
              Icons.local_movies_outlined,
              color: (widget.isMuted ?? false)
                  ? AppColors.grey
                  : AppColors.primaryColor,
            ))
          : Image.file(
              thumbnail!,
              fit: BoxFit.cover,
            );
    }
    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            fit: StackFit.loose,
            children: [
              CustomPaint(
                painter: StatusPainter(
                    statusCount:
                        (widget.isLive ?? false) ? 1 : widget.statusCount,
                    isMuted: widget.isMuted,
                    isLive: widget.isLive),
                child: Container(
                  height: getScreenHeight(54),
                  width: getScreenHeight(54),
                  margin: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: AppColors.greyShade8),
                  child: ClipOval(child: child),
                ),
              ),
              if (widget.isLive ?? false)
                const Positioned(bottom: -6, left: 16, child: LiveTag())
            ],
          ),
          SizedBox(height: getScreenHeight(12)),
          Text(widget.username.appendOverflow(11),
              style: TextStyle(
                  fontSize: getScreenHeight(11),
                  fontWeight: FontWeight.w400,
                  color: false ?? false ? AppColors.greyShade3 : null,
                  overflow: TextOverflow.ellipsis))
        ],
      ),
    );
  }
}

class StatusPainter extends CustomPainter {
  final int statusCount;
  final bool? isMuted, isLive;
  StatusPainter({required this.statusCount, this.isMuted, this.isLive});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = 1.5
      ..color = (isMuted ?? false)
          ? AppColors.greyShade10
          : (isLive ?? false)
              ? const Color(0xFFDE0606)
              : AppColors.primaryColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    drawArc(canvas, paint, size);
  }

  void drawArc(Canvas canvas, Paint paint, Size size) {
    if (statusCount == 1) {
      canvas.drawArc(Rect.fromLTWH(0.0, 0.0, size.width, size.height),
          degreeToAngle(0.0), degreeToAngle(360.0), false, paint);
    } else {
      double deg = -90;
      double arc = 360 / statusCount;
      for (int i = 0; i < statusCount; i++) {
        canvas.drawArc(Rect.fromLTWH(0.0, 0.0, size.width, size.height),
            degreeToAngle(deg + 8), degreeToAngle(arc - 12), false, paint);
        deg += arc;
      }
    }
  }

  double degreeToAngle(double degree) {
    return degree * (pi / 180);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class LiveTag extends StatelessWidget {
  const LiveTag({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      child: Text('LIVE',
          style: TextStyle(
            fontSize: getScreenHeight(10),
            letterSpacing: 1,
            fontWeight: FontWeight.w400,
            color: AppColors.white,
          )),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: const Color(0xFFDE0606),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
