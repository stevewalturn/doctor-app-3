import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:my_app/ui/widgets/custom_button.dart';
import 'package:my_app/ui/widgets/custom_textfield.dart';
import 'package:my_app/features/auth/login/login_viewmodel.dart';

class LoginView extends StackedView<LoginViewModel> {
  const LoginView({super.key});

  @override
  Widget builder(
    BuildContext context,
    LoginViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 48),
              Text(
                'Welcome Back',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Login to your account',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              if (viewModel.hasError)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    viewModel.modelError.toString(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              CustomTextField(
                label: 'Email',
                hint: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
                onChanged: viewModel.setEmail,
                errorText: viewModel.emailError,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Password',
                hint: 'Enter your password',
                obscureText: !viewModel.showPassword,
                onChanged: viewModel.setPassword,
                errorText: viewModel.passwordError,
                suffix: IconButton(
                  icon: Icon(
                    viewModel.showPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: viewModel.togglePasswordVisibility,
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Login',
                onPressed: viewModel.login,
                isLoading: viewModel.isBusy,
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Create Account',
                onPressed: viewModel.navigateToRegister,
                type: ButtonType.outlined,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  LoginViewModel viewModelBuilder(BuildContext context) => LoginViewModel();
}
