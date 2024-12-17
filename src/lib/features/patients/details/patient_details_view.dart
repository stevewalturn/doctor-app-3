import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:my_app/ui/widgets/custom_button.dart';
import 'package:my_app/ui/widgets/custom_textfield.dart';
import 'package:my_app/features/patients/details/patient_details_viewmodel.dart';

class PatientDetailsView extends StackedView<PatientDetailsViewModel> {
  const PatientDetailsView({super.key});

  @override
  Widget builder(
    BuildContext context,
    PatientDetailsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(viewModel.isEditing ? 'Edit Patient' : 'Add Patient'),
        actions: [
          if (viewModel.isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: viewModel.deletePatient,
            ),
        ],
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
                hint: 'Enter patient\'s full name',
                onChanged: viewModel.setName,
                errorText: viewModel.nameError,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Email',
                hint: 'Enter patient\'s email',
                keyboardType: TextInputType.emailAddress,
                onChanged: viewModel.setEmail,
                errorText: viewModel.emailError,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Phone Number',
                hint: 'Enter patient\'s phone number',
                keyboardType: TextInputType.phone,
                onChanged: viewModel.setPhone,
                errorText: viewModel.phoneError,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Age',
                hint: 'Enter patient\'s age',
                keyboardType: TextInputType.number,
                onChanged: viewModel.setAge,
                errorText: viewModel.ageError,
              ),
              const SizedBox(height: 16),
              _buildGenderSelection(context, viewModel),
              const SizedBox(height: 16),
              _buildBloodGroupSelection(context, viewModel),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Address',
                hint: 'Enter patient\'s address',
                maxLines: 3,
                onChanged: viewModel.setAddress,
                errorText: viewModel.addressError,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Medical History',
                hint: 'Enter any relevant medical history',
                maxLines: 4,
                onChanged: viewModel.setMedicalHistory,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Cancel',
                      onPressed: viewModel.navigateBack,
                      type: ButtonType.outlined,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      text:
                          viewModel.isEditing ? 'Save Changes' : 'Add Patient',
                      onPressed: viewModel.savePatient,
                      isLoading: viewModel.isBusy,
                    ),
                  ),
                ],
              ),
              if (viewModel.isEditing) ...[
                const SizedBox(height: 24),
                CustomButton(
                  text: 'View Consultation History',
                  onPressed: viewModel.viewConsultationHistory,
                  type: ButtonType.secondary,
                  icon: Icons.history,
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: 'New Consultation',
                  onPressed: viewModel.startNewConsultation,
                  icon: Icons.add_circle_outline,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderSelection(
    BuildContext context,
    PatientDetailsViewModel viewModel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Male'),
                value: 'Male',
                groupValue: viewModel.gender,
                onChanged: viewModel.setGender,
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Female'),
                value: 'Female',
                groupValue: viewModel.gender,
                onChanged: viewModel.setGender,
              ),
            ),
          ],
        ),
        if (viewModel.genderError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              viewModel.genderError!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBloodGroupSelection(
    BuildContext context,
    PatientDetailsViewModel viewModel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Blood Group',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: viewModel.bloodGroup,
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
              .map((group) => DropdownMenuItem(
                    value: group,
                    child: Text(group),
                  ))
              .toList(),
          onChanged: viewModel.setBloodGroup,
        ),
        if (viewModel.bloodGroupError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              viewModel.bloodGroupError!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  @override
  PatientDetailsViewModel viewModelBuilder(BuildContext context) =>
      PatientDetailsViewModel();

  @override
  void onViewModelReady(PatientDetailsViewModel viewModel) =>
      viewModel.initialize();
}
