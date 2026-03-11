import 'package:database_bridge/database_bridge.dart';
import 'package:dio_bridge/dio_bridge_token_pair.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;

class DioBridgeTokenManager {
  DioBridgeTokenManager._();

  static DioBridgeTokenManager? _instance;
  static DioBridgeTokenManager get instance {
    _instance ??= DioBridgeTokenManager._();
    return _instance!;
  }

  late final DatabaseBridgeSecureStorageService _storage;

  // Web storage methods
  String? _webRead(String key) {
    return html.window.localStorage[key];
  }

  void _webWrite(String key, String value) {
    html.window.localStorage[key] = value;
  }

  void _webDelete(String key) {
    html.window.localStorage.remove(key);
  }

  Future<void> initialize() async {
    if (!kIsWeb) {
      _storage = DatabaseBridgeSecureStorageService();
      await _storage.initialize();
    }
    // On web, we use localStorage directly - no initialization needed
  }

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _expiresAtKey = 'token_expires_at';

  Future<DioBridgeTokenPair?> get tokenPair async {
    final accessToken = kIsWeb
        ? _webRead(_accessTokenKey)
        : await _storage.read(_accessTokenKey);
    if (accessToken == null) return null;

    final refreshToken = kIsWeb
        ? _webRead(_refreshTokenKey)
        : await _storage.read(_refreshTokenKey);
    final expiresAtStr = kIsWeb
        ? _webRead(_expiresAtKey)
        : await _storage.read(_expiresAtKey);
    final expiresAt = expiresAtStr != null
        ? DateTime.fromMillisecondsSinceEpoch(int.parse(expiresAtStr))
        : null;

    return DioBridgeTokenPair(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: expiresAt,
    );
  }

  Future<void> setTokenPair(DioBridgeTokenPair tokenPair) async {
    if (kIsWeb) {
      _webWrite(_accessTokenKey, tokenPair.accessToken);
      if (tokenPair.refreshToken != null) {
        _webWrite(_refreshTokenKey, tokenPair.refreshToken!);
      }
      if (tokenPair.expiresAt != null) {
        _webWrite(_expiresAtKey, tokenPair.expiresAt!.millisecondsSinceEpoch.toString());
      }
    } else {
      await _storage.write(_accessTokenKey, tokenPair.accessToken);
      if (tokenPair.refreshToken != null) {
        await _storage.write(_refreshTokenKey, tokenPair.refreshToken!);
      }
      if (tokenPair.expiresAt != null) {
        await _storage.write(_expiresAtKey, tokenPair.expiresAt!.millisecondsSinceEpoch.toString());
      }
    }
  }

  Future<void> clearTokens() async {
    if (kIsWeb) {
      _webDelete(_accessTokenKey);
      _webDelete(_refreshTokenKey);
      _webDelete(_expiresAtKey);
    } else {
      await Future.wait([
        _storage.delete(_accessTokenKey),
        _storage.delete(_refreshTokenKey),
        _storage.delete(_expiresAtKey),
      ]);
    }
  }

  Future<bool> get isAuthenticated async {
    return await tokenPair != null;
  }

  Future<bool> get isTokenExpired async {
    final pair = await tokenPair;
    return pair == null || pair.isExpired;
  }

  Future<String?> get accessToken async {
    return (await tokenPair)?.accessToken;
  }

  Future<String?> get refreshToken async {
    return (await tokenPair)?.refreshToken;
  }
}
