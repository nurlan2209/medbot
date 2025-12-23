import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  static const _storage = FlutterSecureStorage();

  static const _kToken = 'auth_token';
  static const _kEmail = 'user_email';
  static const _kFullName = 'user_full_name';

  static Future<void> saveSession({
    required String token,
    required String email,
    required String fullName,
  }) async {
    await _storage.write(key: _kToken, value: token);
    await _storage.write(key: _kEmail, value: email);
    await _storage.write(key: _kFullName, value: fullName);
  }

  static Future<void> saveProfile({
    required String email,
    required String fullName,
  }) async {
    await _storage.write(key: _kEmail, value: email);
    await _storage.write(key: _kFullName, value: fullName);
  }

  static Future<String?> getToken() => _storage.read(key: _kToken);
  static Future<String?> getEmail() => _storage.read(key: _kEmail);
  static Future<String?> getFullName() => _storage.read(key: _kFullName);

  static Future<void> clear() async {
    await _storage.delete(key: _kToken);
    await _storage.delete(key: _kEmail);
    await _storage.delete(key: _kFullName);
  }
}
