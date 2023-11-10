import 'package:flutter/foundation.dart';

class FontSizeProvider with ChangeNotifier {
  double _fontSize = 18.0;

  double get fontSize => _fontSize;

  set fontSize(double newSize) {
    _fontSize = newSize;
    notifyListeners();
  }
}
