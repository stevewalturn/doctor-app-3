import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:my_app/app/app.locator.dart';
import 'package:my_app/app/app.router.dart';
import 'package:my_app/repositories/auth_repository.dart';
import 'package:my_app/core/utils/input_validators.dart';

class RegisterViewModel extends BaseViewModel {
  final _authRepository = locator<AuthRepository>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final specializationController = TextEditingController();

  bool _showPassword = false;
  bool get showPassword => _showPassword;

  void togglePasswordVisibility() {
    _showPassword = !_showPassword;
    notifyListeners();
  }

  String? validateName(String? value) => InputValidators.validateName(value);
  String? validateEmail(String? value) => InputValidators.validateEmail(value);
  String? validatePassword(String? value) =>
      InputValidators.validatePassword(value);

  String? validateConfirmPassword(String? value) {
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? validateSpecialization(String? value) {
    return InputValidators.validateRequired(value, 'specialization');
  }

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;

    try {
      setBusy(true);
      await _authRepository.register({
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'password': passwordController.text,
        'specialization': specializationController.text.trim(),
        'role': 'doctor',
      });
      await _navigationService.replaceWith(Routes.dashboardView);
    } catch (e) {
      setError(e.toString());
      await _dialogService.showDialog(
        title: 'Registration Failed',
        description: modelError.toString(),
        buttonTitle: 'OK',
      );
    } finally {
      setBusy(false);
    }
  }

  void navigateToLogin() {
    _navigationService.back();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    specializationController.dispose();
    super.dispose();
  }
}
