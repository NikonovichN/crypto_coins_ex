import 'package:crypto_coins_ex/src/api/app_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'controller.dart';
import 'repository.dart';

class CryptoCoinsPage extends StatelessWidget {
  const CryptoCoinsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final api = AppApi();
    final dio = Dio();
    final screenController = SkillsScreenControllerImpl(
      repository: CryptoCoinsRepositoryImpl(api: api, client: dio),
    );
    screenController.loadData();

    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: screenController.stream,
          builder: (context, snapshot) {
            return _Body();
          },
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Test'));
  }
}
