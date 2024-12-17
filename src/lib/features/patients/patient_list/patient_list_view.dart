import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:my_app/core/theme/app_colors.dart';
import 'package:my_app/core/theme/app_typography.dart';
import 'package:my_app/widgets/custom_text_field.dart';
import 'package:my_app/widgets/custom_button.dart';
import 'package:my_app/widgets/patient_card.dart';
import 'package:my_app/features/patients/patient_list/patient_list_viewmodel.dart';

class PatientListView extends StackedView<PatientListViewModel> {
  const PatientListView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    PatientListViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patients'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: viewModel.showAddPatientDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: CustomTextField(
              hint: 'Search patients...',
              prefix: const Icon(Icons.search),
              controller: viewModel.searchController,
              onChanged: viewModel.onSearchChanged,
            ),
          ),
          if (viewModel.hasError)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                viewModel.modelError.toString(),
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.error,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          Expanded(
            child: viewModel.isBusy
                ? const Center(child: CircularProgressIndicator())
                : viewModel.patients.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.people_outline,
                              size: 64,
                              color: AppColors.textLight,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No patients found',
                              style: AppTypography.titleMedium.copyWith(
                                color: AppColors.textLight,
                              ),
                            ),
                            const SizedBox(height: 16),
                            CustomButton(
                              text: 'Add New Patient',
                              onPressed: viewModel.showAddPatientDialog,
                              isOutlined: true,
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: viewModel.refreshPatients,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: viewModel.patients.length,
                          itemBuilder: (context, index) {
                            final patient = viewModel.patients[index];
                            return PatientCard(
                              patient: patient,
                              onTap: () => viewModel
                                  .navigateToPatientDetails(patient.id),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  @override
  PatientListViewModel viewModelBuilder(BuildContext context) =>
      PatientListViewModel();
}
