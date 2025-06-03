import 'package:crypto_coins_ex/src/api/app_api.dart';
import 'package:dio/dio.dart';

abstract class CryptoCoinsRepository {
  // TODO: add correct return type
  Future<dynamic> fetch({required int limit, required int offset});
}

class CryptoCoinsRepositoryImpl implements CryptoCoinsRepository {
  final AppApi _api;
  final Dio _client;

  const CryptoCoinsRepositoryImpl({required AppApi api, required Dio client})
    : _api = api,
      _client = client;

  @override
  // TODO: add correct return type
  Future<dynamic> fetch({required int limit, required int offset}) async {
    final response = await _client.get(
      'https://${_api.coinCapBasePath}/${_api.coinsPath}',
      queryParameters: {_api.keyParam: _api.key, 'limit': limit, 'offset': offset},
    );
    print(response);
  }
}
