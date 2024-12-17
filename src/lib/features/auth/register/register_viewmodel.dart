import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:my_app/app/app.locator.dart';
import 'package:my_app/app/app.router.dart';
import 'package:my_app/services/authentication_service.dart';
import 'package:my_app/core/utils/validation_utils.dart';

class RegisterViewModel extends BaseViewModel {
  final _authService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();

  String _name = '';
  String _email = '';
  String _phone = '';
  String _specialization = '';
  String _password = '';
  String _confirmPassword = '';
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  String? _nameError;
  String? _emailError;
  String? _phoneError;
  String? _specializationError;
  String? _passwordError;
  String? _confirmPasswordError;

  // Getters
  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  String get specialization => _specialization;
  String get password => _password;
  String get confirmPassword => _confirmPassword;
  bool get showPassword => _showPassword;
  bool get showConfirmPassword => _showConfirmPassword;

  String? get nameError => _nameError;
  String? get emailError => _emailError;
  String? get phoneError => _phoneError;
  String? get specializationError => _specializationError;
  String? get passwordError => _passwordError;
  String? get confirmPasswordError => _confirmPasswordError;

  // Setters
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

  void setSpecialization(String value) {
    _specialization = value;
    _specializationError = null;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    _passwordError = null;
    notifyListeners();
  }

  void setConfirmPassword(String value) {
    _confirmPassword = value;
    _confirmPasswordError = null;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _showPassword = !_showPassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _showConfirmPassword = !_showConfirmPassword;
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

    _specializationError = ValidationUtils.validateRequired(
      _specialization,
      'Specialization',
    );
    if (_specializationError != null) isValid = false;

    _passwordError = ValidationUtils.validatePassword(_password);
    if (_passwordError != null) isValid = false;

    if (_password != _confirmPassword) {
      _confirmPasswordError = 'Passwords do not match';
      isValid = false;
    }

    notifyListeners();
    return isValid;
  }

  Future<void> register() async {
    if (!_validateInputs()) return;

    try {
      setBusy(true);
      await _authService.register(
        email: _email,
        password: _password,
        name: _name,
        phoneNumber: _phone,
        specialization: _specialization,
      );
      await _navigationService.clearStackAndShow(Routes.dashboardView);
      _snackbarService.showSnackbar(
        message: 'Account created successfully!',
        duration: const Duration(seconds: 3),
      );
    } catch (error) {
      setError(error.toString());
      _snackbarService.showSnackbar(
        message: error.toString(),
        duration: const Duration(seconds: 3),
      );
    } finally {
      setBusy(false);
    }
  }

  void navigateBack() {
    _navigationService.back();
  }
}
