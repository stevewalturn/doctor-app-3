import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:my_app/app/app.locator.dart';
import 'package:my_app/features/consultation/models/consultation_model.dart';
import 'package:my_app/features/consultation/consultation_repository.dart';
import 'package:my_app/features/patients/patient_repository.dart';
import 'package:my_app/core/utils/validation_utils.dart';

class NewConsultationViewModel extends BaseViewModel {
  final String patientId;
  final String? consultationId;
  final _consultationRepository = locator<ConsultationRepository>();
  final _patientRepository = locator<PatientRepository>();
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();

  NewConsultationViewModel(this.patientId, this.consultationId);

  ConsultationModel? _consultation;
  String _patientName = '';
  String _chiefComplaint = '';
  String _diagnosis = '';
  List<String> _symptoms = [];
  List<String> _medications = [];
  List<String> _tests = [];
  String _notes = '';

  String? _chiefComplaintError;
  String? _diagnosisError;

  bool get isEditing => consultationId != null;
  String get patientName => _patientName;
  String get chiefComplaint => _chiefComplaint;
  String get diagnosis => _diagnosis;
  List<String> get symptoms => _symptoms;
  List<String> get medications => _medications;
  List<String> get tests => _tests;
  String get notes => _notes;

  String? get chiefComplaintError => _chiefComplaintError;
  String? get diagnosisError => _diagnosisError;

  Future<void> initialize() async {
    await _loadPatientDetails();
    if (isEditing) {
      await _loadConsultation();
    }
  }

  Future<void> _loadPatientDetails() async {
    try {
      final patient = await _patientRepository.getPatientById(patientId);
      _patientName = patient.name;
      notifyListeners();
    } catch (error) {
      setError('Failed to load patient details: ${error.toString()}');
    }
  }

  Future<void> _loadConsultation() async {
    try {
      setBusy(true);
      _consultation =
          await _consultationRepository.getConsultationById(consultationId!);
      _chiefComplaint = _consultation!.chiefComplaint;
      _diagnosis = _consultation!.diagnosis;
      _symptoms = List.from(_consultation!.symptoms);
      _medications = List.from(_consultation!.medications);
      _tests = List.from(_consultation!.tests);
      _notes = _consultation!.notes;
      notifyListeners();
    } catch (error) {
      setError('Failed to load consultation: ${error.toString()}');
    } finally {
      setBusy(false);
    }
  }

  void setChiefComplaint(String value) {
    _chiefComplaint = value;
    _chiefComplaintError = null;
    notifyListeners();
  }

  void setDiagnosis(String value) {
    _diagnosis = value;
    _diagnosisError = null;
    notifyListeners();
  }

  void addSymptom(String value) {
    if (!_symptoms.contains(value)) {
      _symptoms.add(value);
      notifyListeners();
    }
  }

  void removeSymptom(String value) {
    _symptoms.remove(value);
    notifyListeners();
  }

  void addMedication(String value) {
    if (!_medications.contains(value)) {
      _medications.add(value);
      notifyListeners();
    }
  }

  void removeMedication(String value) {
    _medications.remove(value);
    notifyListeners();
  }

  void addTest(String value) {
    if (!_tests.contains(value)) {
      _tests.add(value);
      notifyListeners();
    }
  }

  void removeTest(String value) {
    _tests.remove(value);
    notifyListeners();
  }

  void setNotes(String value) {
    _notes = value;
    notifyListeners();
  }

  bool _validateInputs() {
    bool isValid = true;

    _chiefComplaintError = ValidationUtils.validateRequired(
      _chiefComplaint,
      'Chief complaint',
    );
    if (_chiefComplaintError != null) isValid = false;

    _diagnosisError = ValidationUtils.validateRequired(
      _diagnosis,
      'Diagnosis',
    );
    if (_diagnosisError != null) isValid = false;

    notifyListeners();
    return isValid;
  }

  Future<void> saveConsultation() async {
    if (!_validateInputs()) return;

    try {
      setBusy(true);
      final consultationData = ConsultationModel(
        id: _consultation?.id ?? '',
        patientId: patientId,
        patientName: _patientName,
        doctorId: _consultation?.doctorId ?? '',
        doctorName: _consultation?.doctorName ?? '',
        date: DateTime.now(),
        chiefComplaint: _chiefComplaint,
        diagnosis: _diagnosis,
        symptoms: _symptoms,
        medications: _medications,
        tests: _tests,
        notes: _notes,
        status: 'Active',
        createdAt: _consultation?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (isEditing) {
        await _consultationRepository.updateConsultation(consultationData);
        _snackbarService.showSnackbar(
          message: 'Consultation updated successfully',
        );
      } else {
        await _consultationRepository.createConsultation(consultationData);
        _snackbarService.showSnackbar(
          message: 'Consultation saved successfully',
        );
      }
      _navigationService.back();
    } catch (error) {
      setError(error.toString());
    } finally {
      setBusy(false);
    }
  }

  void navigateBack() {
    _navigationService.back();
  }
}
