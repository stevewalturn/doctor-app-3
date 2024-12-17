import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:my_app/app/app.locator.dart';
import 'package:my_app/app/app.router.dart';
import 'package:my_app/repositories/auth_repository.dart';
import 'package:my_app/core/utils/input_validators.dart';

class LoginViewModel extends BaseViewModel {
  final _authRepository = locator<AuthRepository>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _showPassword = false;
  bool get showPassword => _showPassword;

  void togglePasswordVisibility() {
    _showPassword = !_showPassword;
    notifyListeners();
  }

  String? validateEmail(String? value) => InputValidators.validateEmail(value);
  String? validatePassword(String? value) =>
      InputValidators.validatePassword(value);

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    try {
      setBusy(true);
      await _authRepository.login(
        emailController.text.trim(),
        passwordController.text,
      );
      await _navigationService.replaceWith(Routes.dashboardView);
    } catch (e) {
      setError(e.toString());
      await _dialogService.showDialog(
        title: 'Login Failed',
        description: modelError.toString(),
        buttonTitle: 'OK',
      );
    } finally {
      setBusy(false);
    }
  }

  void navigateToRegister() {
    _navigationService.navigateTo(Routes.registerView);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
