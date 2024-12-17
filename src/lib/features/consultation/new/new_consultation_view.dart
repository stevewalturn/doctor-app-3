import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:my_app/ui/widgets/custom_button.dart';
import 'package:my_app/ui/widgets/custom_textfield.dart';
import 'package:my_app/features/consultation/new/new_consultation_viewmodel.dart';

class NewConsultationView extends StackedView<NewConsultationViewModel> {
  final String patientId;
  final String? consultationId;

  const NewConsultationView({
    super.key,
    required this.patientId,
    this.consultationId,
  });

  @override
  Widget builder(
    BuildContext context,
    NewConsultationViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            viewModel.isEditing ? 'Edit Consultation' : 'New Consultation'),
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
              Text(
                'Patient: ${viewModel.patientName}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: 'Chief Complaint',
                hint: 'Enter the main reason for visit',
                maxLines: 3,
                onChanged: viewModel.setChiefComplaint,
                errorText: viewModel.chiefComplaintError,
              ),
              const SizedBox(height: 16),
              _buildChipInput(
                context,
                'Symptoms',
                viewModel.symptoms,
                viewModel.addSymptom,
                viewModel.removeSymptom,
                'Add a symptom',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Diagnosis',
                hint: 'Enter the diagnosis',
                maxLines: 3,
                onChanged: viewModel.setDiagnosis,
                errorText: viewModel.diagnosisError,
              ),
              const SizedBox(height: 16),
              _buildChipInput(
                context,
                'Medications',
                viewModel.medications,
                viewModel.addMedication,
                viewModel.removeMedication,
                'Add a medication',
              ),
              const SizedBox(height: 16),
              _buildChipInput(
                context,
                'Tests',
                viewModel.tests,
                viewModel.addTest,
                viewModel.removeTest,
                'Add a test',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Notes',
                hint: 'Enter any additional notes',
                maxLines: 4,
                onChanged: viewModel.setNotes,
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
                      text: viewModel.isEditing
                          ? 'Save Changes'
                          : 'Save Consultation',
                      onPressed: viewModel.saveConsultation,
                      isLoading: viewModel.isBusy,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChipInput(
    BuildContext context,
    String label,
    List<String> items,
    Function(String) onAdd,
    Function(String) onRemove,
    String hint,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...items.map(
              (item) => Chip(
                label: Text(item),
                onDeleted: () => onRemove(item),
                deleteIcon: const Icon(Icons.close, size: 18),
              ),
            ),
            InputChip(
              label: Text(hint),
              onPressed: () async {
                final textController = TextEditingController();
                final result = await showDialog<String>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Add $label'),
                    content: TextField(
                      controller: textController,
                      decoration: InputDecoration(
                        hintText: hint,
                      ),
                      autofocus: true,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () =>
                            Navigator.pop(context, textController.text),
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                );
                if (result != null && result.isNotEmpty) {
                  onAdd(result);
                }
              },
              avatar: const Icon(Icons.add, size: 18),
            ),
          ],
        ),
      ],
    );
  }

  @override
  NewConsultationViewModel viewModelBuilder(BuildContext context) =>
      NewConsultationViewModel(patientId, consultationId);

  @override
  void onViewModelReady(NewConsultationViewModel viewModel) =>
      viewModel.initialize();
}
