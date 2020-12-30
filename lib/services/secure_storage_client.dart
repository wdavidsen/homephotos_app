import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageClient {
  final _storage = new FlutterSecureStorage();

  Future<String> read(String key) {
    return _storage.read(key: key);
  }

  Future write(String key, String value) {
    return _storage.write(key: key, value: value);
  }

  Future delete(String key) {
    return _storage.delete(key: key);
  }
}