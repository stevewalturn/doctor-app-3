import 'package:my_app/models/patient.dart';
import 'package:my_app/services/api_service.dart';
import 'package:my_app/services/auth_service.dart';

class PatientRepository {
  final ApiService _apiService;
  final AuthService _authService;

  PatientRepository(this._apiService, this._authService);

  Future<List<Patient>> getPatients({
    String? search,
    int? page,
    int? limit,
  }) async {
    try {
      final queryParams = {
        if (search != null) 'search': search,
        if (page != null) 'page': page.toString(),
        if (limit != null) 'limit': limit.toString(),
      };

      final response = await _apiService.get(
        '/patients?${Uri(queryParameters: queryParams).query}',
        token: _authService.token,
      );

      return (response as List).map((json) => Patient.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Patient> getPatient(String id) async {
    try {
      final response = await _apiService.get(
        '/patients/$id',
        token: _authService.token,
      );

      return Patient.fromJson(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Patient> createPatient(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post(
        '/patients',
        data,
        token: _authService.token,
      );

      return Patient.fromJson(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Patient> updatePatient(String id, Map<String, dynamic> data) async {
    try {
      final response = await _apiService.put(
        '/patients/$id',
        data,
        token: _authService.token,
      );

      return Patient.fromJson(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deletePatient(String id) async {
    try {
      await _apiService.delete(
        '/patients/$id',
        token: _authService.token,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(dynamic error) {
    if (error is String) {
      return error;
    }
    return 'An error occurred while processing your request. Please try again.';
  }
}
