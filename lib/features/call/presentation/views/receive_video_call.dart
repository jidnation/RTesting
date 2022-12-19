import 'package:flutter/material.dart';

class ReceiveVideoCall extends StatelessWidget {
  const ReceiveVideoCall({
    super.key,
    required this.channelName,
    required this.token,
  });

  final String channelName;
  final String token;

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
