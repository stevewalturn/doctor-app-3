import 'package:my_app/services/api_service.dart';
import 'package:my_app/features/consultation/models/consultation_model.dart';

class ConsultationRepository {
  final ApiService _apiService;

  ConsultationRepository(this._apiService);

  Future<List<ConsultationModel>> getConsultationsForPatient(
      String patientId) async {
    try {
      final response =
          await _apiService.get('/patients/$patientId/consultations');
      return (response['consultations'] as List)
          .map((json) => ConsultationModel.fromJson(json))
          .toList();
    } catch (e) {
      throw _handleConsultationError(e);
    }
  }

  Future<ConsultationModel> getConsultationById(String id) async {
    try {
      final response = await _apiService.get('/consultations/$id');
      return ConsultationModel.fromJson(response['consultation']);
    } catch (e) {
      throw _handleConsultationError(e);
    }
  }

  Future<ConsultationModel> createConsultation(
      ConsultationModel consultation) async {
    try {
      final response = await _apiService.post(
        '/consultations',
        consultation.toJson(),
      );
      return ConsultationModel.fromJson(response['consultation']);
    } catch (e) {
      throw _handleConsultationError(e);
    }
  }

  Future<ConsultationModel> updateConsultation(
      ConsultationModel consultation) async {
    try {
      final response = await _apiService.put(
        '/consultations/${consultation.id}',
        consultation.toJson(),
      );
      return ConsultationModel.fromJson(response['consultation']);
    } catch (e) {
      throw _handleConsultationError(e);
    }
  }

  Future<void> deleteConsultation(String id) async {
    try {
      await _apiService.delete('/consultations/$id');
    } catch (e) {
      throw _handleConsultationError(e);
    }
  }

  Future<List<ConsultationModel>> getDoctorConsultations({
    DateTime? startDate,
    DateTime? endDate,
    String? status,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
      }
      if (status != null) {
        queryParams['status'] = status;
      }

      final response = await _apiService.get('/consultations');
      return (response['consultations'] as List)
          .map((json) => ConsultationModel.fromJson(json))
          .toList();
    } catch (e) {
      throw _handleConsultationError(e);
    }
  }

  String _handleConsultationError(dynamic error) {
    if (error is String) {
      if (error.contains('404')) {
        return 'Consultation record not found. It may have been deleted.';
      } else if (error.contains('403')) {
        return 'You do not have permission to access this consultation record.';
      } else if (error.contains('409')) {
        return 'A consultation with these details already exists.';
      }
      return error;
    }
    return 'An unexpected error occurred while managing consultation records.';
  }
}
