import 'package:dio_bridge/dio_bridge_token_pair.dart';
import 'package:dio_bridge/src/token_storage/token_storage.dart';

class DioBridgeTokenManager {
  DioBridgeTokenManager._();

  static DioBridgeTokenManager? _instance;
  static DioBridgeTokenManager get instance {
    _instance ??= DioBridgeTokenManager._();
    return _instance!;
  }

  Future<void> initialize() async {
    await initTokenStorage();
  }

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _expiresAtKey = 'token_expires_at';

  Future<DioBridgeTokenPair?> get tokenPair async {
    final accessToken = await readToken(_accessTokenKey);
    if (accessToken == null) return null;

    final refreshToken = await readToken(_refreshTokenKey);
    final expiresAtStr = await readToken(_expiresAtKey);
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
    await writeToken(_accessTokenKey, tokenPair.accessToken);
    if (tokenPair.refreshToken != null) {
      await writeToken(_refreshTokenKey, tokenPair.refreshToken!);
    }
    if (tokenPair.expiresAt != null) {
      await writeToken(
        _expiresAtKey,
        tokenPair.expiresAt!.millisecondsSinceEpoch.toString(),
      );
    }
  }

  Future<void> clearTokens() async {
    await Future.wait([
      deleteToken(_accessTokenKey),
      deleteToken(_refreshTokenKey),
      deleteToken(_expiresAtKey),
    ]);
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
