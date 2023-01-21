import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:reach_me/core/services/media_service.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/core/utils/extensions.dart';
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

  final imageUrl =
      'https://images.unsplash.com/photo-1622294891694-07a7ebbd9f37?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=928&q=80';
  final imageUrl2 =
      'https://reachme-09128734.s3.eu-west-2.amazonaws.com/27d328b1-956f-432f-8829-a103b6a17d11.jpg';
  final videoUrl =
      'https://reachme-09128734.s3.eu-west-2.amazonaws.com/5f403d6a-9fe5-424d-9c85-72230fad958c.mp4';

  @override
  Widget build(BuildContext context) {
    Widget child = Container();
    if (widget.preview.type == 'text') {
      child = Container(
        color: AppColors.greyShade8,
        alignment: Alignment.center,
        padding: EdgeInsets.all(8),
        child: Text(
          (widget.preview.statusData?.content ?? 'nil'),
          textAlign: TextAlign.center,
          maxLines: 3,
          style: const TextStyle(fontSize: 10, height: 1),
        ),
      );
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
    return Container(
      margin: EdgeInsets.only(right: 16),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomPaint(
              painter: StatusPainter(
                  statusCount: widget.statusCount, isMuted: widget.isMuted),
              child: Container(
                height: getScreenHeight(54),
                width: getScreenHeight(54),
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: AppColors.greyShade8),
                child: ClipOval(child: child),
              ),
            ),
            false
                ? SizedBox(height: getScreenHeight(7))
                : SizedBox(height: getScreenHeight(11)),
            Text(widget.username.appendOverflow(11),
                style: TextStyle(
                    fontSize: getScreenHeight(11),
                    fontWeight: FontWeight.w400,
                    color: false ?? false ? AppColors.greyShade3 : null,
                    overflow: TextOverflow.ellipsis))
          ],
        ),
      ),
    );
  }
}

class StatusPainter extends CustomPainter {
  final int statusCount;
  final bool? isMuted;
  StatusPainter({required this.statusCount, this.isMuted});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = 1.5
      ..color =
          isMuted ?? false ? AppColors.greyShade10 : AppColors.primaryColor
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
