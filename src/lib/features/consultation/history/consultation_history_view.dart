import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:my_app/ui/widgets/consultation_card.dart';
import 'package:my_app/features/consultation/history/consultation_history_viewmodel.dart';

class ConsultationHistoryView
    extends StackedView<ConsultationHistoryViewModel> {
  final String patientId;

  const ConsultationHistoryView({
    super.key,
    required this.patientId,
  });

  @override
  Widget builder(
    BuildContext context,
    ConsultationHistoryViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consultation History - ${viewModel.patientName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: viewModel.showFilters,
          ),
        ],
      ),
      body: Column(
        children: [
          if (viewModel.hasError)
            Container(
              margin: const EdgeInsets.all(16),
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
          Expanded(
            child: viewModel.isBusy
                ? const Center(child: CircularProgressIndicator())
                : viewModel.consultations.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.history,
                              size: 64,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No consultation history',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Add a new consultation to get started',
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
                        onRefresh: viewModel.refreshConsultations,
                        child: ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: viewModel.consultations.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final consultation = viewModel.consultations[index];
                            return ConsultationCard(
                              consultation: consultation,
                              onTap: () => viewModel
                                  .viewConsultationDetails(consultation),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: viewModel.startNewConsultation,
        icon: const Icon(Icons.add),
        label: const Text('New Consultation'),
      ),
    );
  }

  @override
  ConsultationHistoryViewModel viewModelBuilder(BuildContext context) =>
      ConsultationHistoryViewModel(patientId);

  @override
  void onViewModelReady(ConsultationHistoryViewModel viewModel) =>
      viewModel.initialize();
}
