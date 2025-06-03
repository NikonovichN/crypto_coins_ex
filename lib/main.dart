import 'dart:async';

import 'package:flutter/material.dart';

import 'src/app_crypto_coin.dart';

void main() {
  runZonedGuarded(() {
    runApp(const AppCryptoCoin());
  }, (error, stackTrace) {});
}
