import 'package:database_bridge/database_bridge_core.dart';

DatabaseBridgeSecureStorageService? _storage;

Future<void> initTokenStorage() async {
  _storage = DatabaseBridgeSecureStorageService();
  await _storage!.initialize();
}

Future<String?> readToken(String key) async {
  return _storage!.read(key);
}

Future<void> writeToken(String key, String value) async {
  await _storage!.write(key, value);
}

Future<void> deleteToken(String key) async {
  await _storage!.delete(key);
}
