import 'package:my_app/services/api_service.dart';
import 'package:my_app/features/patients/models/patient_model.dart';

class PatientRepository {
  final ApiService _apiService;

  PatientRepository(this._apiService);

  Future<List<PatientModel>> getAllPatients() async {
    try {
      final response = await _apiService.get('/patients');
      return (response['patients'] as List)
          .map((json) => PatientModel.fromJson(json))
          .toList();
    } catch (e) {
      throw _handlePatientError(e);
    }
  }

  Future<PatientModel> getPatientById(String id) async {
    try {
      final response = await _apiService.get('/patients/$id');
      return PatientModel.fromJson(response['patient']);
    } catch (e) {
      throw _handlePatientError(e);
    }
  }

  Future<PatientModel> createPatient(PatientModel patient) async {
    try {
      final response = await _apiService.post(
        '/patients',
        patient.toJson(),
      );
      return PatientModel.fromJson(response['patient']);
    } catch (e) {
      throw _handlePatientError(e);
    }
  }

  Future<PatientModel> updatePatient(PatientModel patient) async {
    try {
      final response = await _apiService.put(
        '/patients/${patient.id}',
        patient.toJson(),
      );
      return PatientModel.fromJson(response['patient']);
    } catch (e) {
      throw _handlePatientError(e);
    }
  }

  Future<void> deletePatient(String id) async {
    try {
      await _apiService.delete('/patients/$id');
    } catch (e) {
      throw _handlePatientError(e);
    }
  }

  String _handlePatientError(dynamic error) {
    if (error is String) {
      if (error.contains('404')) {
        return 'Patient not found. They may have been deleted.';
      } else if (error.contains('409')) {
        return 'A patient with this information already exists.';
      }
      return error;
    }
    return 'An unexpected error occurred while managing patient data.';
  }
}
