import 'package:flutter/widgets.dart';

class AppFonts {
  const AppFonts._();

  static const fontFamily = 'SFProText';

  static TextStyle boldStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17,
    height: 24 / 17,
    fontWeight: FontWeight.w600,
    color: Color(0xFF17171A),
  );
}
