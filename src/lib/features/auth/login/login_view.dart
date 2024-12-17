import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:my_app/core/theme/app_colors.dart';
import 'package:my_app/core/theme/app_typography.dart';
import 'package:my_app/widgets/custom_button.dart';
import 'package:my_app/widgets/custom_text_field.dart';
import 'package:my_app/features/auth/login/login_viewmodel.dart';

class LoginView extends StackedView<LoginViewModel> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    LoginViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.medical_services_rounded,
                  size: 64,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  'Welcome Back',
                  style: AppTypography.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to continue to your account',
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Form(
                  key: viewModel.formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        label: 'Email',
                        hint: 'Enter your email',
                        keyboardType: TextInputType.emailAddress,
                        controller: viewModel.emailController,
                        validator: viewModel.validateEmail,
                        enabled: !viewModel.isBusy,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Password',
                        hint: 'Enter your password',
                        obscureText: !viewModel.showPassword,
                        controller: viewModel.passwordController,
                        validator: viewModel.validatePassword,
                        enabled: !viewModel.isBusy,
                        suffix: IconButton(
                          icon: Icon(
                            viewModel.showPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.textSecondary,
                          ),
                          onPressed: viewModel.togglePasswordVisibility,
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (viewModel.hasError)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            viewModel.modelError.toString(),
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.error,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      CustomButton(
                        text: 'Sign In',
                        onPressed: viewModel.login,
                        isLoading: viewModel.isBusy,
                        width: double.infinity,
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: viewModel.isBusy
                            ? null
                            : viewModel.navigateToRegister,
                        child: Text(
                          'Don\'t have an account? Sign Up',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  LoginViewModel viewModelBuilder(BuildContext context) => LoginViewModel();
}
