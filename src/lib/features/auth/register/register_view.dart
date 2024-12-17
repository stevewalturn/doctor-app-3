import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:my_app/ui/widgets/custom_button.dart';
import 'package:my_app/ui/widgets/custom_textfield.dart';
import 'package:my_app/features/auth/register/register_viewmodel.dart';

class RegisterView extends StackedView<RegisterViewModel> {
  const RegisterView({super.key});

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                label: 'Full Name',
                hint: 'Enter your full name',
                onChanged: viewModel.setName,
                errorText: viewModel.nameError,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Email',
                hint: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
                onChanged: viewModel.setEmail,
                errorText: viewModel.emailError,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Phone Number',
                hint: 'Enter your phone number',
                keyboardType: TextInputType.phone,
                onChanged: viewModel.setPhone,
                errorText: viewModel.phoneError,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Specialization',
                hint: 'Enter your medical specialization',
                onChanged: viewModel.setSpecialization,
                errorText: viewModel.specializationError,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Password',
                hint: 'Create a password',
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
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Confirm Password',
                hint: 'Confirm your password',
                obscureText: !viewModel.showConfirmPassword,
                onChanged: viewModel.setConfirmPassword,
                errorText: viewModel.confirmPasswordError,
                suffix: IconButton(
                  icon: Icon(
                    viewModel.showConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: viewModel.toggleConfirmPasswordVisibility,
                ),
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Create Account',
                onPressed: viewModel.register,
                isLoading: viewModel.isBusy,
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Back to Login',
                onPressed: viewModel.navigateBack,
                type: ButtonType.outlined,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  RegisterViewModel viewModelBuilder(BuildContext context) =>
      RegisterViewModel();
}
