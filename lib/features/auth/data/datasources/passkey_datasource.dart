abstract class PasskeyDatasource {
  Future<Map<String, dynamic>> register({
    required Map<String, dynamic> publicKeyOptions,
  });

  Future<Map<String, dynamic>> authenticate({
    required Map<String, dynamic> publicKeyOptions,
  });

  Future<bool> isSupported();
}
