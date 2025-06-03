class AppApi {
  final String coinCapBasePath;
  final String coinsPath;
  final String key;
  final String keyParam;
  const AppApi({
    this.coinCapBasePath = "rest.coincap.io",
    this.coinsPath = "v3/assets",
    this.key = 'ae6172427fbad1d1d2f679459029ee0fb96db0be33c8ce93cfd0c64e0cd7a117',
    this.keyParam = 'apiKey',
  });
}
