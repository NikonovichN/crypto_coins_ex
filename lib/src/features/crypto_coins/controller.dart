import 'dart:async';

import 'package:equatable/equatable.dart';

import '../../common/common.dart';
import 'repository.dart';

class CryptoCoinsScreenData extends Equatable {
  @override
  List<Object?> get props => [];
}

class CryptoCoinsScreenState extends Equatable {
  final bool isLoading;
  final CryptoCoinsScreenData? screenData;
  final RepositoryException? error;

  const CryptoCoinsScreenState({required this.isLoading, this.screenData, this.error});

  @override
  List<Object?> get props => [isLoading, screenData, error];

  CryptoCoinsScreenState copyWith({
    required bool isLoading,
    CryptoCoinsScreenData? screenData,
    RepositoryException? error,
  }) {
    return CryptoCoinsScreenState(
      isLoading: isLoading,
      screenData: screenData ?? this.screenData,
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

  CryptoCoinsScreenState _state = const CryptoCoinsScreenState(isLoading: false);

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
  Future<void> loadData() async {
    if (state.isLoading) {
      return;
    }

    emit(_state.copyWith(isLoading: true, error: null));

    try {
      final repositoryData = await _repository.fetch(limit: _partitionToLoad, offset: 0);

      // emit(_state.copyWith(isLoading: false, screenData: repositoryData));
    } catch (e) {
      final errorString = e.toString();

      error(errorString);
      emit(_state.copyWith(isLoading: false, error: RepositoryException(message: errorString)));
    }
  }
}
