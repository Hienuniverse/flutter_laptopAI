import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import 'api_exception.dart';

class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  String? _token;

  void setToken(String? token) => _token = token;

  Uri _uri(String path) => Uri.parse('${ApiConstants.baseUrl}$path');

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  Future<dynamic> get(String path) async {
    final response = await _client.get(_uri(path), headers: _headers);
    return _handleResponse(response);
  }

  Future<dynamic> post(String path, {Map<String, dynamic>? body}) async {
    final response = await _client.post(
      _uri(path),
      headers: _headers,
      body: jsonEncode(body ?? {}),
    );
    return _handleResponse(response);
  }

  Future<dynamic> put(String path, {Map<String, dynamic>? body}) async {
    final response = await _client.put(
      _uri(path),
      headers: _headers,
      body: jsonEncode(body ?? {}),
    );
    return _handleResponse(response);
  }

  Future<dynamic> delete(String path) async {
    final response = await _client.delete(_uri(path), headers: _headers);
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    final body = response.body.isEmpty ? null : jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) return body;
    throw ApiException(
      body is Map && body['message'] != null
          ? body['message'].toString()
          : 'Có lỗi xảy ra khi gọi API',
      statusCode: response.statusCode,
    );
  }
}
