import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:my_app/ui/widgets/patient_card.dart';
import 'package:my_app/ui/widgets/custom_textfield.dart';
import 'package:my_app/features/patients/list/patient_list_viewmodel.dart';

class PatientListView extends StackedView<PatientListViewModel> {
  const PatientListView({super.key});

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
            icon: const Icon(Icons.filter_list),
            onPressed: viewModel.showFilters,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: viewModel.navigateToAddPatient,
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
              onChanged: viewModel.onSearchChanged,
            ),
          ),
          if (viewModel.hasError)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
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
            ),
          Expanded(
            child: viewModel.isBusy
                ? const Center(child: CircularProgressIndicator())
                : viewModel.patients.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person_search,
                              size: 64,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No patients found',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Add new patients or try different search terms',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: viewModel.refreshPatients,
                        child: ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: viewModel.patients.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final patient = viewModel.patients[index];
                            return PatientCard(
                              patient: patient,
                              onTap: () =>
                                  viewModel.navigateToPatientDetails(patient),
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

  @override
  void onViewModelReady(PatientListViewModel viewModel) =>
      viewModel.initialize();
}
