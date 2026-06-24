import 'package:web/web.dart';

Future<void> initTokenStorage() async {}

Future<String?> readToken(String key) async {
  return window.localStorage.getItem(key);
}

Future<void> writeToken(String key, String value) async {
  window.localStorage.setItem(key, value);
}

Future<void> deleteToken(String key) async {
  window.localStorage.removeItem(key);
}
