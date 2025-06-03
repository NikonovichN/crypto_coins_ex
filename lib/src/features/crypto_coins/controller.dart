import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../common/common.dart';
import 'dto.dart';
import 'repository.dart';

class Coin extends Equatable {
  final String id;
  final String symbol;
  final String name;
  final String priceUsd;
  final Color color;

  const Coin({
    required this.id,
    required this.symbol,
    required this.name,
    required this.priceUsd,
    required this.color,
  });

  @override
  List<Object?> get props => [id, symbol, name, priceUsd, color];
}

class CryptoCoinsScreenState extends Equatable {
  final bool isLoading;
  final bool inProcess;
  final List<Coin>? coins;
  final RepositoryException? error;

  const CryptoCoinsScreenState({
    required this.isLoading,
    required this.inProcess,
    this.coins,
    this.error,
  });

  @override
  List<Object?> get props => [isLoading, coins, error];

  CryptoCoinsScreenState copyWith({
    required bool isLoading,
    required bool inProcess,
    List<Coin>? coins,
    RepositoryException? error,
  }) {
    return CryptoCoinsScreenState(
      isLoading: isLoading,
      inProcess: inProcess,
      coins: coins ?? this.coins,
      error: error ?? this.error,
    );
  }
}

abstract class CryptoCoinsScreenController {
  Future<void> loadData();
  Stream<CryptoCoinsScreenState> get stream;
  CryptoCoinsScreenState get state;
}

class SkillsScreenControllerImpl with AppLogger implements CryptoCoinsScreenController {
  static const _partitionToLoad = 15;

  final StreamController<CryptoCoinsScreenState> _controller =
      StreamController<CryptoCoinsScreenState>.broadcast();

  CryptoCoinsScreenState _state = const CryptoCoinsScreenState(isLoading: false, inProcess: true);

  final CryptoCoinsRepository _repository;

  SkillsScreenControllerImpl({required CryptoCoinsRepository repository})
    : _repository = repository;

  @override
  Stream<CryptoCoinsScreenState> get stream => _controller.stream;

  @override
  CryptoCoinsScreenState get state => _state;

  void emit(CryptoCoinsScreenState newState) {
    _state = newState;
    _controller.add(newState);
  }

  @override
  Future<void> loadData({bool refresh = false}) async {
    if (state.isLoading) {
      return;
    }

    final stateCoinsIsEmpty = state.coins == null || state.coins?.isEmpty == true;

    emit(_state.copyWith(isLoading: stateCoinsIsEmpty, inProcess: !stateCoinsIsEmpty, error: null));

    try {
      final repositoryData = await _repository.fetch(
        limit: _partitionToLoad,
        offset: state.coins?.length ?? 0,
      );

      info(repositoryData.toString());

      List<Coin> cryptoCoins = refresh ? [] : List.from(state.coins ?? []);

      cryptoCoins.addAll(repositoryData.map((c) => c.toScreenData()).toList());

      emit(_state.copyWith(isLoading: false, inProcess: false, coins: cryptoCoins));
    } catch (e) {
      final errorString = e.toString();

      error(errorString);
      emit(
        _state.copyWith(
          isLoading: false,
          inProcess: false,
          error: RepositoryException(message: errorString),
        ),
      );
    }
  }
}

extension on CryptoCoinsDto {
  static const _maxChannelColor = 256;
  Color _generateColor() {
    final randomizer = Random();
    return Color.fromARGB(
      26,
      randomizer.nextInt(_maxChannelColor),
      randomizer.nextInt(_maxChannelColor),
      randomizer.nextInt(_maxChannelColor),
    );
  }

  Coin toScreenData() {
    final price = double.tryParse(priceUsd)?.toStringAsFixed(2);
    return Coin(
      id: id,
      symbol: symbol,
      name: name,
      priceUsd: price != null ? '\$$price' : 'none',
      color: _generateColor(),
    );
  }
}
