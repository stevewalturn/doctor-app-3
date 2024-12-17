import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stacked/stacked.dart';
import 'package:my_app/core/constants/app_constants.dart';

class ApiService implements InitializableDependency {
  final _client = http.Client();
  String? _authToken;

  void setAuthToken(String token) {
    _authToken = token;
  }

  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
    };
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    return headers;
  }

  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final response = await _client
          .get(
            Uri.parse('${AppConstants.baseUrl}$endpoint'),
            headers: _headers,
          )
          .timeout(Duration(seconds: AppConstants.apiTimeout));

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client
          .post(
            Uri.parse('${AppConstants.baseUrl}$endpoint'),
            headers: _headers,
            body: json.encode(data),
          )
          .timeout(Duration(seconds: AppConstants.apiTimeout));

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client
          .put(
            Uri.parse('${AppConstants.baseUrl}$endpoint'),
            headers: _headers,
            body: json.encode(data),
          )
          .timeout(Duration(seconds: AppConstants.apiTimeout));

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final response = await _client
          .delete(
            Uri.parse('${AppConstants.baseUrl}$endpoint'),
            headers: _headers,
          )
          .timeout(Duration(seconds: AppConstants.apiTimeout));

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final body = json.decode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    } else if (response.statusCode == 401) {
      throw 'Your session has expired. Please login again.';
    } else if (response.statusCode == 403) {
      throw 'You do not have permission to perform this action.';
    } else if (response.statusCode == 404) {
      throw 'The requested resource was not found.';
    } else if (response.statusCode >= 500) {
      throw 'A server error occurred. Please try again later.';
    } else {
      throw body['message'] ?? 'An unexpected error occurred.';
    }
  }

  String _handleError(dynamic error) {
    if (error is http.ClientException) {
      return 'Unable to connect to the server. Please check your internet connection.';
    } else if (error is FormatException) {
      return 'Received invalid data from the server. Please try again.';
    } else if (error is TimeoutException) {
      return 'The request timed out. Please try again.';
    } else {
      return error.toString();
    }
  }

  @override
  Future<void> init() async {
    // Initialize any required configurations
  }
}
