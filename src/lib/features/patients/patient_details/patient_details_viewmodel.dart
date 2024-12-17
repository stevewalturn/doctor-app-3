import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:my_app/app/app.locator.dart';
import 'package:my_app/app/app.router.dart';
import 'package:my_app/models/patient.dart';
import 'package:my_app/models/consultation.dart';
import 'package:my_app/repositories/patient_repository.dart';
import 'package:my_app/repositories/consultation_repository.dart';
import 'package:intl/intl.dart';

class PatientDetailsViewModel extends BaseViewModel {
  final _patientRepository = locator<PatientRepository>();
  final _consultationRepository = locator<ConsultationRepository>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();

  Patient? _patient;
  List<Consultation> _consultations = [];

  Patient? get patient => _patient;
  List<Consultation> get consultations => _consultations;

  PatientDetailsViewModel() {
    loadPatientData();
  }

  Future<void> loadPatientData() async {
    try {
      setBusy(true);
      final patientId = _navigationService.currentArguments as String;

      _patient = await _patientRepository.getPatient(patientId);
      _consultations = await _consultationRepository.getConsultations(
        patientId: patientId,
      );

      notifyListeners();
    } catch (e) {
      setError('Failed to load patient data. Please try again.');
    } finally {
      setBusy(false);
    }
  }

  Future<void> refreshData() async {
    await loadPatientData();
  }

  String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  void viewConsultationDetails(String consultationId) {
    _navigationService.navigateTo(
      Routes.consultationFormView,
      arguments: consultationId,
    );
  }

  Future<void> startNewConsultation() async {
    if (_patient == null) return;

    try {
      final consultation = await _consultationRepository.createConsultation({
        'patientId': _patient!.id,
        'status': 'pending',
        'consultationDate': DateTime.now().toIso8601String(),
      });

      await _navigationService.navigateTo(
        Routes.consultationFormView,
        arguments: consultation.id,
      );

      await refreshData();
    } catch (e) {
      await _dialogService.showDialog(
        title: 'Error',
        description: 'Failed to create new consultation. Please try again.',
        buttonTitle: 'OK',
      );
    }
  }

  Future<void> editPatient() async {
    if (_patient == null) return;

    final result = await _dialogService.showDialog(
      title: 'Edit Patient',
      description: 'This feature is coming soon.',
      buttonTitle: 'OK',
    );
  }
}
