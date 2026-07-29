import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Centralized API client. Single Dio instance shared across all services.
/// JWT token is injected via interceptor — no per-call boilerplate.
class ApiClient {
  static const String _tokenKey = 'jwt_access_token';

  // Change this to your backend URL (Docker: http://10.0.2.2:8000 for Android emulator)
  static const String baseUrl = 'http://10.0.2.2:8000/api/v1';

  final Dio dio;
  final FlutterSecureStorage _storage;

  ApiClient._internal(this.dio, this._storage);

  static ApiClient? _instance;

  factory ApiClient() {
    if (_instance != null) return _instance!;

    final storage = const FlutterSecureStorage();
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // JWT interceptor: reads token from secure storage, attaches to every request
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await storage.read(key: _tokenKey);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          // 401 errors could trigger a logout in the future
          handler.next(error);
        },
      ),
    );

    _instance = ApiClient._internal(dio, storage);
    return _instance!;
  }

  /// Save JWT after login
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Clear JWT on logout
  Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }

  /// Check if a token exists (for auth gate)
  Future<bool> hasToken() async {
    final token = await _storage.read(key: _tokenKey);
    return token != null && token.isNotEmpty;
  }
}
