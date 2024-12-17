import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:my_app/app/app.locator.dart';
import 'package:my_app/app/app.router.dart';
import 'package:my_app/features/patients/models/patient_model.dart';
import 'package:my_app/features/patients/patient_repository.dart';

class PatientListViewModel extends BaseViewModel {
  final _patientRepository = locator<PatientRepository>();
  final _navigationService = locator<NavigationService>();
  final _bottomSheetService = locator<BottomSheetService>();

  List<PatientModel> _allPatients = [];
  List<PatientModel> _filteredPatients = [];
  String _searchQuery = '';
  Map<String, dynamic> _filters = {};

  List<PatientModel> get patients => _filteredPatients;

  Future<void> initialize() async {
    await refreshPatients();
  }

  Future<void> refreshPatients() async {
    try {
      setBusy(true);
      _allPatients = await _patientRepository.getAllPatients();
      _applyFilters();
    } catch (error) {
      setError('Failed to load patients: ${error.toString()}');
    } finally {
      setBusy(false);
    }
  }

  void onSearchChanged(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
  }

  void _applyFilters() {
    _filteredPatients = _allPatients.where((patient) {
      // Apply search filter
      if (_searchQuery.isNotEmpty) {
        final searchMatch = patient.name.toLowerCase().contains(_searchQuery) ||
            patient.phoneNumber.contains(_searchQuery) ||
            patient.email.toLowerCase().contains(_searchQuery);
        if (!searchMatch) return false;
      }

      // Apply other filters
      if (_filters.containsKey('ageRange')) {
        final ageRange = _filters['ageRange'] as RangeValues;
        if (patient.age < ageRange.start || patient.age > ageRange.end) {
          return false;
        }
      }

      if (_filters.containsKey('gender') &&
          _filters['gender'] != null &&
          patient.gender != _filters['gender']) {
        return false;
      }

      if (_filters.containsKey('bloodGroup') &&
          _filters['bloodGroup'] != null &&
          patient.bloodGroup != _filters['bloodGroup']) {
        return false;
      }

      return true;
    }).toList();

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

  void navigateToAddPatient() {
    _navigationService.navigateTo(Routes.patientDetailsView, arguments: null);
  }

  void navigateToPatientDetails(PatientModel patient) {
    _navigationService.navigateTo(
      Routes.patientDetailsView,
      arguments: {'patient': patient},
    );
  }
}
