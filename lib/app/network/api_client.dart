import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:med_bot/app/auth/auth_storage.dart';
import 'package:med_bot/config.dart';

class ApiClient {
  static Uri _uri(String path) => Uri.parse('$serverUrl$path');

  static Future<Map<String, dynamic>> postJson(
    String path, {
    Map<String, dynamic>? body,
    bool auth = true,
  }) async {
    final headers = await _headers(auth: auth);
    final response = await http.post(
      _uri(path),
      headers: headers,
      body: jsonEncode(body ?? const {}),
    );
    final decoded = _tryDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) return decoded;
    throw ApiException(response.statusCode, decoded['message']?.toString() ?? 'Request failed');
  }

  static Future<Map<String, dynamic>> putJson(
    String path, {
    Map<String, dynamic>? body,
    bool auth = true,
  }) async {
    final headers = await _headers(auth: auth);
    final response = await http.put(
      _uri(path),
      headers: headers,
      body: jsonEncode(body ?? const {}),
    );
    final decoded = _tryDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) return decoded;
    throw ApiException(response.statusCode, decoded['message']?.toString() ?? 'Request failed');
  }

  static Future<dynamic> getJson(
    String path, {
    bool auth = true,
  }) async {
    final headers = await _headers(auth: auth);
    final response = await http.get(_uri(path), headers: headers);
    final decoded = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) return decoded;
    final message = (decoded is Map<String, dynamic>) ? decoded['message']?.toString() : null;
    throw ApiException(response.statusCode, message ?? 'Request failed');
  }

  static Future<Map<String, dynamic>> deleteJson(
    String path, {
    bool auth = true,
  }) async {
    final headers = await _headers(auth: auth);
    final response = await http.delete(_uri(path), headers: headers);
    final decoded = _tryDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) return decoded;
    throw ApiException(response.statusCode, decoded['message']?.toString() ?? 'Request failed');
  }

  static Future<Map<String, dynamic>> postMultipart(
    String path, {
    required http.MultipartFile file,
    bool auth = true,
  }) async {
    final request = http.MultipartRequest('POST', _uri(path));
    if (auth) {
      final token = await AuthStorage.getToken();
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }
    }
    request.files.add(file);
    final response = await request.send();
    final body = await response.stream.bytesToString();
    final decoded = _tryDecode(body);
    if (response.statusCode >= 200 && response.statusCode < 300) return decoded;
    throw ApiException(response.statusCode, decoded['message']?.toString() ?? 'Request failed');
  }

  static Future<Map<String, String>> _headers({required bool auth}) async {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (!auth) return headers;
    final token = await AuthStorage.getToken();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  static Map<String, dynamic> _tryDecode(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) return decoded;
      return {'data': decoded};
    } catch (_) {
      return {'message': body};
    }
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException(this.statusCode, this.message);
  @override
  String toString() => 'ApiException($statusCode): $message';
}
