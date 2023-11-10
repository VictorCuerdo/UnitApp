// navigation_extension.dart
import 'package:flutter/material.dart';
import 'package:unitapp/widgets/unit_conversion.dart';

extension NavigationExtension on BuildContext {
  void navigateTo(String routeName) {
    if (routeName == '/') {
      Navigator.pushReplacement(
        this,
        MaterialPageRoute(builder: (context) => const UnitConversion()),
      );
    } else {
      Navigator.pushNamed(this, routeName);
    }
  }
}
