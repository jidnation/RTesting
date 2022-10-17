import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Refresher extends StatelessWidget {
  const Refresher({
    Key? key,
    required this.controller,
    required this.onRefresh,
    required this.child,
  }) : super(key: key);

  final RefreshController controller;
  final Function() onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      physics: const BouncingScrollPhysics(),
      controller: controller,
      onRefresh: onRefresh,
      child: child,
    );
  }
}
