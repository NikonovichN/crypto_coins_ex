import 'package:dio/dio.dart';

import '../../api/app_api.dart';
import '../../common/common.dart';
import 'dto.dart';

abstract class CryptoCoinsRepository {
  Future<List<CryptoCoinsDto>> fetch({required int limit, required int offset});
}

class CryptoCoinsRepositoryImpl implements CryptoCoinsRepository {
  final AppApi _api;
  final Dio _client;

  const CryptoCoinsRepositoryImpl({required AppApi api, required Dio client})
    : _api = api,
      _client = client;

  @override
  Future<List<CryptoCoinsDto>> fetch({required int limit, required int offset}) async {
    final response = await _client.get(
      'https://${_api.coinCapBasePath}/${_api.coinsPath}',
      queryParameters: {_api.keyParam: _api.key, 'limit': limit, 'offset': offset},
    );

    if (response.statusCode != 200) {
      throw RepositoryException.httpError;
    }

    final List<dynamic> responseJson = response.data['data'];

    return responseJson.map((c) => CryptoCoinsDto.fromJson(c)).toList();
  }
}
