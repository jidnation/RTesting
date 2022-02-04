import 'package:flutter/material.dart';

class RMOnboardingModel {
  String title;
  String description;
  Color titleColor;
  Color descripColor;
  String imagePath;

  RMOnboardingModel({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.titleColor,
    required this.descripColor,
  });
}
