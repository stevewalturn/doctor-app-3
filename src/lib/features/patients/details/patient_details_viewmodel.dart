import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:my_app/app/app.locator.dart';
import 'package:my_app/app/app.router.dart';
import 'package:my_app/features/patients/models/patient_model.dart';
import 'package:my_app/features/patients/patient_repository.dart';
import 'package:my_app/core/utils/validation_utils.dart';

class PatientDetailsViewModel extends BaseViewModel {
  final _patientRepository = locator<PatientRepository>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _snackbarService = locator<SnackbarService>();

  PatientModel? _patient;
  String _name = '';
  String _email = '';
  String _phone = '';
  String _age = '';
  String? _gender;
  String? _bloodGroup;
  String _address = '';
  String _medicalHistory = '';

  String? _nameError;
  String? _emailError;
  String? _phoneError;
  String? _ageError;
  String? _genderError;
  String? _bloodGroupError;
  String? _addressError;

  bool get isEditing => _patient != null;
  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  String get age => _age;
  String? get gender => _gender;
  String? get bloodGroup => _bloodGroup;
  String get address => _address;
  String get medicalHistory => _medicalHistory;

  String? get nameError => _nameError;
  String? get emailError => _emailError;
  String? get phoneError => _phoneError;
  String? get ageError => _ageError;
  String? get genderError => _genderError;
  String? get bloodGroupError => _bloodGroupError;
  String? get addressError => _addressError;

  Future<void> initialize() async {
    final args = _navigationService.current.arguments;
    if (args != null && args['patient'] != null) {
      _patient = args['patient'] as PatientModel;
      _loadPatientData();
    }
  }

  void _loadPatientData() {
    if (_patient != null) {
      _name = _patient!.name;
      _email = _patient!.email;
      _phone = _patient!.phoneNumber;
      _age = _patient!.age.toString();
      _gender = _patient!.gender;
      _bloodGroup = _patient!.bloodGroup;
      _address = _patient!.address;
      _medicalHistory = _patient!.medicalHistory ?? '';
      notifyListeners();
    }
  }

  void setName(String value) {
    _name = value;
    _nameError = null;
    notifyListeners();
  }

  void setEmail(String value) {
    _email = value;
    _emailError = null;
    notifyListeners();
  }

  void setPhone(String value) {
    _phone = value;
    _phoneError = null;
    notifyListeners();
  }

  void setAge(String value) {
    _age = value;
    _ageError = null;
    notifyListeners();
  }

  void setGender(String? value) {
    _gender = value;
    _genderError = null;
    notifyListeners();
  }

  void setBloodGroup(String? value) {
    _bloodGroup = value;
    _bloodGroupError = null;
    notifyListeners();
  }

  void setAddress(String value) {
    _address = value;
    _addressError = null;
    notifyListeners();
  }

  void setMedicalHistory(String value) {
    _medicalHistory = value;
    notifyListeners();
  }

  bool _validateInputs() {
    bool isValid = true;

    _nameError = ValidationUtils.validateName(_name);
    if (_nameError != null) isValid = false;

    _emailError = ValidationUtils.validateEmail(_email);
    if (_emailError != null) isValid = false;

    _phoneError = ValidationUtils.validatePhone(_phone);
    if (_phoneError != null) isValid = false;

    _ageError = ValidationUtils.validateAge(_age);
    if (_ageError != null) isValid = false;

    if (_gender == null) {
      _genderError = 'Please select a gender';
      isValid = false;
    }

    if (_bloodGroup == null) {
      _bloodGroupError = 'Please select a blood group';
      isValid = false;
    }

    _addressError = ValidationUtils.validateRequired(_address, 'Address');
    if (_addressError != null) isValid = false;

    notifyListeners();
    return isValid;
  }

  Future<void> savePatient() async {
    if (!_validateInputs()) return;

    try {
      setBusy(true);
      final patientData = PatientModel(
        id: _patient?.id ?? '',
        name: _name,
        email: _email,
        phoneNumber: _phone,
        age: int.parse(_age),
        gender: _gender!,
        bloodGroup: _bloodGroup!,
        address: _address,
        medicalHistory: _medicalHistory,
        createdAt: _patient?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        createdBy: _patient?.createdBy ?? '',
        allergies: _patient?.allergies ?? [],
        chronicConditions: _patient?.chronicConditions ?? [],
      );

      if (isEditing) {
        await _patientRepository.updatePatient(patientData);
        _snackbarService.showSnackbar(
          message: 'Patient details updated successfully',
        );
      } else {
        await _patientRepository.createPatient(patientData);
        _snackbarService.showSnackbar(
          message: 'Patient added successfully',
        );
      }
      _navigationService.back();
    } catch (error) {
      setError(error.toString());
    } finally {
      setBusy(false);
    }
  }

  Future<void> deletePatient() async {
    if (_patient == null) return;

    final response = await _dialogService.showDialog(
      title: 'Delete Patient',
      description:
          'Are you sure you want to delete this patient? This action cannot be undone.',
      buttonTitle: 'Delete',
      cancelTitle: 'Cancel',
    );

    if (response?.confirmed ?? false) {
      try {
        setBusy(true);
        await _patientRepository.deletePatient(_patient!.id);
        _snackbarService.showSnackbar(
          message: 'Patient deleted successfully',
        );
        _navigationService.back();
      } catch (error) {
        setError(error.toString());
      } finally {
        setBusy(false);
      }
    }
  }

  void navigateBack() {
    _navigationService.back();
  }

  void viewConsultationHistory() {
    if (_patient == null) return;
    _navigationService.navigateToConsultationHistoryView(
      patientId: _patient!.id,
    );
  }

  void startNewConsultation() {
    if (_patient == null) return;
    _navigationService.navigateToNewConsultationView(
      patientId: _patient!.id,
    );
  }
}
