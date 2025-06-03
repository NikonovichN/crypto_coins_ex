class CryptoCoinsDto {
  final String id;
  final String symbol;
  final String name;
  final String priceUsd;

  const CryptoCoinsDto({
    required this.id,
    required this.symbol,
    required this.name,
    required this.priceUsd,
  });

  static CryptoCoinsDto fromJson(Map<String, dynamic> json) {
    return CryptoCoinsDto(
      id: json['id'] ?? '',
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      priceUsd: json['priceUsd'] ?? '',
    );
  }
}
