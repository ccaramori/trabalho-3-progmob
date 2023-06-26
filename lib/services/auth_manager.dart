import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthManager {
  static final AuthManager _instance = AuthManager._internal();

  factory AuthManager() {
    return _instance;
  }

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  Future<void> logout() async {
    await _secureStorage.delete(key: 'token');
    _isLoggedIn = false;
  }

  Future<bool> checkLoginStatus() async {
    final token = await _secureStorage.read(key: 'token');
    _isLoggedIn = token != null;
    return _isLoggedIn;
  }

  AuthManager._internal();
}
