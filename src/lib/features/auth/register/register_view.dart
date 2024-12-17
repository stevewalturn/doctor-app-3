import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:my_app/core/theme/app_colors.dart';
import 'package:my_app/core/theme/app_typography.dart';
import 'package:my_app/widgets/custom_button.dart';
import 'package:my_app/widgets/custom_text_field.dart';
import 'package:my_app/features/auth/register/register_viewmodel.dart';

class RegisterView extends StackedView<RegisterViewModel> {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    RegisterViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: viewModel.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Join Us',
                  style: AppTypography.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Create your account to get started',
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  controller: viewModel.nameController,
                  validator: viewModel.validateName,
                  enabled: !viewModel.isBusy,
                ),
                const SizedBox(height: 16),
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
                  hint: 'Create a password',
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
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Confirm Password',
                  hint: 'Confirm your password',
                  obscureText: !viewModel.showPassword,
                  controller: viewModel.confirmPasswordController,
                  validator: viewModel.validateConfirmPassword,
                  enabled: !viewModel.isBusy,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Specialization',
                  hint: 'Enter your medical specialization',
                  controller: viewModel.specializationController,
                  validator: viewModel.validateSpecialization,
                  enabled: !viewModel.isBusy,
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
                  text: 'Create Account',
                  onPressed: viewModel.register,
                  isLoading: viewModel.isBusy,
                  width: double.infinity,
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed:
                      viewModel.isBusy ? null : viewModel.navigateToLogin,
                  child: Text(
                    'Already have an account? Sign In',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.primary,
                    ),
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
  RegisterViewModel viewModelBuilder(BuildContext context) =>
      RegisterViewModel();
}
