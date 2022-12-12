import 'package:flutter/material.dart';

import '../../../../../../core/utils/custom_text.dart';

class MomentPreviewEditor extends StatelessWidget {
  final String label;
  final IconData icon;
  const MomentPreviewEditor({
    Key? key,
    required this.label,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Icon(
        icon,
        color: Colors.white,
        size: 27.26,
      ),
      const SizedBox(height: 3),
      CustomText(
        text: label,
        color: Colors.white,
        weight: FontWeight.w600,
        size: 9.44,
      )
    ]);
  }
}
