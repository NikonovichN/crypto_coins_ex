import 'package:flutter/material.dart';

import 'features/features.dart';
import 'ui_kit/ui_kit.dart';

class AppCryptoCoin extends StatelessWidget {
  const AppCryptoCoin({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Coins Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: AppFonts.fontFamily,
      ),
      home: const CryptoCoinsPage(),
    );
  }
}
