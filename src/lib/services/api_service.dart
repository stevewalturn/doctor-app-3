import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stacked/stacked.dart';

class ApiService implements InitializableDependency {
  static const String _baseUrl = 'https://api.example.com/v1';
  final String _apiKey = 'your_api_key';

  Future<Map<String, String>> _getHeaders({String? token}) async {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-API-Key': _apiKey,
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<dynamic> get(String endpoint, {String? token}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl$endpoint'),
        headers: await _getHeaders(token: token),
      );

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<dynamic> post(String endpoint, dynamic data, {String? token}) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl$endpoint'),
        headers: await _getHeaders(token: token),
        body: json.encode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<dynamic> put(String endpoint, dynamic data, {String? token}) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl$endpoint'),
        headers: await _getHeaders(token: token),
        body: json.encode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<dynamic> delete(String endpoint, {String? token}) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl$endpoint'),
        headers: await _getHeaders(token: token),
      );

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return json.decode(response.body);
    }

    switch (response.statusCode) {
      case 400:
        throw 'Invalid request. Please check your input and try again.';
      case 401:
        throw 'Unauthorized. Please log in again.';
      case 403:
        throw 'Access denied. You do not have permission to perform this action.';
      case 404:
        throw 'Resource not found. Please try again later.';
      case 500:
        throw 'Server error. Please try again later.';
      default:
        throw 'An unexpected error occurred. Please try again later.';
    }
  }

  String _handleError(dynamic error) {
    if (error is http.ClientException) {
      return 'Network error. Please check your internet connection.';
    }
    if (error is FormatException) {
      return 'Invalid response format. Please try again later.';
    }
    return error.toString();
  }

  @override
  Future<void> init() async {
    // Initialize any required configurations
  }
}
