import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:my_app/app/app.locator.dart';
import 'package:my_app/app/app.router.dart';
import 'package:my_app/models/patient.dart';
import 'package:my_app/repositories/patient_repository.dart';

class PatientListViewModel extends BaseViewModel {
  final _patientRepository = locator<PatientRepository>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();

  final searchController = TextEditingController();
  List<Patient> _allPatients = [];
  List<Patient> _filteredPatients = [];

  List<Patient> get patients => _filteredPatients;

  PatientListViewModel() {
    loadPatients();
  }

  Future<void> loadPatients() async {
    try {
      setBusy(true);
      _allPatients = await _patientRepository.getPatients();
      _filteredPatients = List.from(_allPatients);
      notifyListeners();
    } catch (e) {
      setError('Failed to load patients. Please try again.');
    } finally {
      setBusy(false);
    }
  }

  void onSearchChanged(String query) {
    if (query.isEmpty) {
      _filteredPatients = List.from(_allPatients);
    } else {
      _filteredPatients = _allPatients
          .where((patient) =>
              patient.name.toLowerCase().contains(query.toLowerCase()) ||
              patient.email.toLowerCase().contains(query.toLowerCase()) ||
              patient.phoneNumber.contains(query))
          .toList();
    }
    notifyListeners();
  }

  Future<void> refreshPatients() async {
    await loadPatients();
  }

  void navigateToPatientDetails(String patientId) {
    _navigationService.navigateTo(
      Routes.patientDetailsView,
      arguments: patientId,
    );
  }

  Future<void> showAddPatientDialog() async {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();

    final dialogResponse = await _dialogService.showCustomDialog(
      variant: DialogType.custom,
      title: 'Add New Patient',
      mainButtonTitle: 'Add',
      secondaryButtonTitle: 'Cancel',
      data: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Full Name'),
          ),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            controller: phoneController,
            decoration: const InputDecoration(labelText: 'Phone Number'),
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );

    if (dialogResponse?.confirmed ?? false) {
      try {
        setBusy(true);
        await _patientRepository.createPatient({
          'name': nameController.text,
          'email': emailController.text,
          'phoneNumber': phoneController.text,
        });
        await loadPatients();
      } catch (e) {
        await _dialogService.showDialog(
          title: 'Error',
          description: 'Failed to create patient. Please try again.',
          buttonTitle: 'OK',
        );
      } finally {
        setBusy(false);
      }
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
