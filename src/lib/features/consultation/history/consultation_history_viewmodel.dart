import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:my_app/app/app.locator.dart';
import 'package:my_app/app/app.router.dart';
import 'package:my_app/features/consultation/models/consultation_model.dart';
import 'package:my_app/features/consultation/consultation_repository.dart';
import 'package:my_app/features/patients/patient_repository.dart';

class ConsultationHistoryViewModel extends BaseViewModel {
  final String patientId;
  final _consultationRepository = locator<ConsultationRepository>();
  final _patientRepository = locator<PatientRepository>();
  final _navigationService = locator<NavigationService>();
  final _bottomSheetService = locator<BottomSheetService>();

  ConsultationHistoryViewModel(this.patientId);

  List<ConsultationModel> _consultations = [];
  String _patientName = '';
  Map<String, dynamic> _filters = {};

  List<ConsultationModel> get consultations => _consultations;
  String get patientName => _patientName;

  Future<void> initialize() async {
    await _loadPatientDetails();
    await refreshConsultations();
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

  Future<void> refreshConsultations() async {
    try {
      setBusy(true);
      _consultations =
          await _consultationRepository.getConsultationsForPatient(patientId);
      _applyFilters();
    } catch (error) {
      setError('Failed to load consultations: ${error.toString()}');
    } finally {
      setBusy(false);
    }
  }

  void _applyFilters() {
    var filteredConsultations = _consultations;

    if (_filters.containsKey('dateRange')) {
      final dateRange = _filters['dateRange'] as DateTimeRange;
      filteredConsultations = filteredConsultations
          .where((c) =>
              c.date.isAfter(dateRange.start) && c.date.isBefore(dateRange.end))
          .toList();
    }

    if (_filters.containsKey('status') && _filters['status'] != null) {
      filteredConsultations = filteredConsultations
          .where((c) => c.status == _filters['status'])
          .toList();
    }

    _consultations = filteredConsultations;
    notifyListeners();
  }

  Future<void> showFilters() async {
    final result = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.filters,
      data: _filters,
    );

    if (result?.confirmed ?? false) {
      _filters = result!.data;
      _applyFilters();
    }
  }

  void viewConsultationDetails(ConsultationModel consultation) {
    _navigationService.navigateToNewConsultationView(
      consultationId: consultation.id,
      patientId: patientId,
    );
  }

  void startNewConsultation() {
    _navigationService.navigateToNewConsultationView(
      patientId: patientId,
    );
  }
}
