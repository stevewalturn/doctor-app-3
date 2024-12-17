import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:my_app/app/app.locator.dart';
import 'package:my_app/app/app.router.dart';
import 'package:my_app/services/authentication_service.dart';
import 'package:my_app/core/utils/validation_utils.dart';

class LoginViewModel extends BaseViewModel {
  final _authService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();

  String _email = '';
  String _password = '';
  bool _showPassword = false;
  String? _emailError;
  String? _passwordError;

  String get email => _email;
  String get password => _password;
  bool get showPassword => _showPassword;
  String? get emailError => _emailError;
  String? get passwordError => _passwordError;

  void setEmail(String value) {
    _email = value;
    _emailError = null;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    _passwordError = null;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _showPassword = !_showPassword;
    notifyListeners();
  }

  bool _validateInputs() {
    bool isValid = true;

    _emailError = ValidationUtils.validateEmail(_email);
    if (_emailError != null) isValid = false;

    _passwordError = ValidationUtils.validatePassword(_password);
    if (_passwordError != null) isValid = false;

    notifyListeners();
    return isValid;
  }

  Future<void> login() async {
    if (!_validateInputs()) return;

    try {
      setBusy(true);
      await _authService.login(_email, _password);
      await _navigationService.clearStackAndShow(Routes.dashboardView);
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

  void navigateToRegister() {
    _navigationService.navigateToRegisterView();
  }
}
