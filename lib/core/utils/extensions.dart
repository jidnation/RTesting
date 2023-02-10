import 'package:flutter/material.dart';

extension WidgetUtilsX on Widget {
  Widget paddingAll(double padding) => Padding(
        padding: EdgeInsets.all(padding),
        child: this,
      );

  Widget paddingSymmetric({double h = 0.0, double v = 0.0}) => Padding(
        padding: EdgeInsets.symmetric(horizontal: h, vertical: v),
        child: this,
      );

  Widget paddingOnly({double l = 0, double t = 0, double r = 0, double b = 0}) {
    return Padding(
      padding: EdgeInsets.only(left: l, top: t, bottom: b, right: r),
      child: this,
    );
  }
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

extension Group<T> on Iterable<T> {
  Map<K, Iterable<T>> groupBy<K>(K Function(T) key) {
    final map = <K, List<T>>{};
    for (final element in this) {
      final keyValue = key(element);
      if (!map.containsKey(keyValue!)) {
        map[keyValue] = [];
      }
      map[keyValue]?.add(element);
    }
    return map;
  }
}

extension StringExtention on String {
  String appendOverflow(int cropLen) {
    if (length > cropLen) {
      return '${substring(0, cropLen)}...';
    } else {
      return this;
    }
  }
}

extension Mentions on String {
  List<String>? get mentions {
    final regExp = RegExp('(@\\w+)');

    final matches = regExp.allMatches(this).map((e) => e[0]);

    return matches.map((e) => e!.replaceAll('@', '')).toList();
  }
}
