import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:my_app/core/theme/app_colors.dart';
import 'package:my_app/core/theme/app_typography.dart';
import 'package:my_app/widgets/custom_card.dart';
import 'package:my_app/widgets/consultation_card.dart';
import 'package:my_app/widgets/custom_button.dart';
import 'package:my_app/features/patients/patient_details/patient_details_viewmodel.dart';

class PatientDetailsView extends StackedView<PatientDetailsViewModel> {
  const PatientDetailsView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    PatientDetailsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: viewModel.editPatient,
          ),
        ],
      ),
      body: viewModel.isBusy
          ? const Center(child: CircularProgressIndicator())
          : viewModel.hasError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        viewModel.modelError.toString(),
                        style: AppTypography.bodyLarge.copyWith(
                          color: AppColors.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        text: 'Retry',
                        onPressed: viewModel.loadPatientData,
                        isOutlined: true,
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: viewModel.refreshData,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPatientInfo(viewModel),
                        const SizedBox(height: 24),
                        _buildConsultationHistory(viewModel),
                      ],
                    ),
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: viewModel.startNewConsultation,
        icon: const Icon(Icons.add),
        label: const Text('New Consultation'),
      ),
    );
  }

  Widget _buildPatientInfo(PatientDetailsViewModel viewModel) {
    final patient = viewModel.patient!;
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text(
                  patient.name.substring(0, 1).toUpperCase(),
                  style: AppTypography.headlineMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patient.name,
                      style: AppTypography.titleLarge,
                    ),
                    Text(
                      'ID: ${patient.id}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildInfoRow(
              'Date of Birth', viewModel.formatDate(patient.dateOfBirth)),
          _buildInfoRow('Gender', patient.gender),
          _buildInfoRow('Phone', patient.phoneNumber),
          _buildInfoRow('Email', patient.email),
          if (patient.bloodType != null)
            _buildInfoRow('Blood Type', patient.bloodType!),
          if (patient.allergies != null && patient.allergies!.isNotEmpty)
            _buildInfoRow('Allergies', patient.allergies!.join(', ')),
          if (patient.medicalHistory != null)
            _buildInfoRow('Medical History', patient.medicalHistory!),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsultationHistory(PatientDetailsViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Consultation History',
          style: AppTypography.titleLarge,
        ),
        const SizedBox(height: 16),
        if (viewModel.consultations.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                'No consultation history',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: viewModel.consultations.length,
            itemBuilder: (context, index) {
              return ConsultationCard(
                consultation: viewModel.consultations[index],
                onTap: () => viewModel.viewConsultationDetails(
                  viewModel.consultations[index].id,
                ),
              );
            },
          ),
      ],
    );
  }

  @override
  PatientDetailsViewModel viewModelBuilder(BuildContext context) =>
      PatientDetailsViewModel();
}
