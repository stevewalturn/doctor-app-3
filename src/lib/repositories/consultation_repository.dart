import 'package:my_app/models/consultation.dart';
import 'package:my_app/services/api_service.dart';
import 'package:my_app/services/auth_service.dart';

class ConsultationRepository {
  final ApiService _apiService;
  final AuthService _authService;

  ConsultationRepository(this._apiService, this._authService);

  Future<List<Consultation>> getConsultations({
    String? patientId,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = {
        if (patientId != null) 'patientId': patientId,
        if (status != null) 'status': status,
        if (startDate != null) 'startDate': startDate.toIso8601String(),
        if (endDate != null) 'endDate': endDate.toIso8601String(),
      };

      final response = await _apiService.get(
        '/consultations?${Uri(queryParameters: queryParams).query}',
        token: _authService.token,
      );

      return (response as List)
          .map((json) => Consultation.fromJson(json))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Consultation> getConsultation(String id) async {
    try {
      final response = await _apiService.get(
        '/consultations/$id',
        token: _authService.token,
      );

      return Consultation.fromJson(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Consultation> createConsultation(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post(
        '/consultations',
        data,
        token: _authService.token,
      );

      return Consultation.fromJson(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Consultation> updateConsultation(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _apiService.put(
        '/consultations/$id',
        data,
        token: _authService.token,
      );

      return Consultation.fromJson(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteConsultation(String id) async {
    try {
      await _apiService.delete(
        '/consultations/$id',
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
