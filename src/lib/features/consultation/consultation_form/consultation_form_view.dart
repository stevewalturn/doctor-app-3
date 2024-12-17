import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:my_app/core/theme/app_colors.dart';
import 'package:my_app/core/theme/app_typography.dart';
import 'package:my_app/widgets/custom_text_field.dart';
import 'package:my_app/widgets/custom_button.dart';
import 'package:my_app/features/consultation/consultation_form/consultation_form_viewmodel.dart';

class ConsultationFormView extends StackedView<ConsultationFormViewModel> {
  const ConsultationFormView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ConsultationFormViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            viewModel.isEditing ? 'Edit Consultation' : 'New Consultation'),
        actions: [
          if (viewModel.isEditing && !viewModel.isBusy)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: viewModel.deleteConsultation,
            ),
        ],
      ),
      body: viewModel.isBusy
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: viewModel.formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
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
                  _buildPatientInfo(viewModel),
                  const SizedBox(height: 24),
                  CustomTextField(
                    label: 'Chief Complaint',
                    controller: viewModel.chiefComplaintController,
                    validator: viewModel.validateRequired,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Present Illness',
                    controller: viewModel.presentIllnessController,
                    validator: viewModel.validateRequired,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Symptoms',
                    controller: viewModel.symptomsController,
                    validator: viewModel.validateRequired,
                    hint: 'Enter symptoms separated by commas',
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Diagnosis',
                    controller: viewModel.diagnosisController,
                    validator: viewModel.validateRequired,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Treatment Plan',
                    controller: viewModel.treatmentController,
                    validator: viewModel.validateRequired,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Notes (Optional)',
                    controller: viewModel.notesController,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'Add Attachment',
                          onPressed: viewModel.addAttachment,
                          isOutlined: true,
                          icon: Icons.attach_file,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomButton(
                          text: viewModel.isEditing ? 'Update' : 'Save',
                          onPressed: viewModel.saveConsultation,
                          icon: Icons.save,
                        ),
                      ),
                    ],
                  ),
                  if (viewModel.attachments.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Attachments',
                      style: AppTypography.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: viewModel.attachments.length,
                      itemBuilder: (context, index) {
                        final attachment = viewModel.attachments[index];
                        return ListTile(
                          leading: const Icon(Icons.insert_drive_file),
                          title: Text(attachment),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => viewModel.removeAttachment(index),
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildPatientInfo(ConsultationFormViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Patient Information',
            style: AppTypography.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            viewModel.patientName,
            style: AppTypography.bodyLarge,
          ),
          Text(
            'ID: ${viewModel.patientId}',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  ConsultationFormViewModel viewModelBuilder(BuildContext context) =>
      ConsultationFormViewModel();
}
