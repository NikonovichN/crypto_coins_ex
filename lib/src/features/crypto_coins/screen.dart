import 'package:crypto_coins_ex/src/api/app_api.dart';
import 'package:crypto_coins_ex/src/ui_kit/atoms/app_fonts.dart';
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
            final refreshButton = _TryToRefreshButton(
              onPressed: () => screenController.loadData(refresh: true),
            );

            if (snapshot.data == null) {
              return refreshButton;
            }

            final state = snapshot.data!;

            if (state.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            return ListView.builder(
              itemCount: (state.coins?.length ?? 0) + 1,
              itemBuilder: (context, index) {
                if (state.coins == null) {
                  return refreshButton;
                }

                if (index == state.coins!.length) {
                  if (state.inProcess) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    screenController.loadData();
                    return const SizedBox.shrink();
                  }
                }

                final coin = state.coins![index];

                return _CoinCard(
                  name: Text(coin.name),
                  price: Text(coin.priceUsd),
                  color: coin.color,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _TryToRefreshButton extends StatelessWidget {
  static const _text = 'Try to refresh';
  final void Function()? onPressed;
  const _TryToRefreshButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(onPressed: onPressed, child: Text(_text)),
    );
  }
}

class _CoinCard extends StatelessWidget {
  final Text name;
  final Text price;
  final Color color;

  const _CoinCard({required this.name, required this.price, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
      color: Colors.white,
      child: DefaultTextStyle.merge(
        style: AppFonts.boldStyle,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _ColoredBox(color: color),
            SizedBox(width: 16.0),
            Expanded(child: name),
            price,
          ],
        ),
      ),
    );
  }
}

class _ColoredBox extends StatelessWidget {
  static const _side = 56.0;
  static const _radius = 18.0;

  final Color color;

  const _ColoredBox({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _side,
      height: _side,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(_radius)),
    );
  }
}
