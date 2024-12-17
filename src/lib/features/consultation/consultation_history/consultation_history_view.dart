import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:my_app/core/theme/app_colors.dart';
import 'package:my_app/core/theme/app_typography.dart';
import 'package:my_app/widgets/consultation_card.dart';
import 'package:my_app/widgets/custom_text_field.dart';
import 'package:my_app/features/consultation/consultation_history/consultation_history_viewmodel.dart';

class ConsultationHistoryView
    extends StackedView<ConsultationHistoryViewModel> {
  const ConsultationHistoryView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ConsultationHistoryViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultation History'),
        actions: [
          PopupMenuButton<String>(
            onSelected: viewModel.onFilterChanged,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'all',
                child: Text('All'),
              ),
              const PopupMenuItem(
                value: 'completed',
                child: Text('Completed'),
              ),
              const PopupMenuItem(
                value: 'pending',
                child: Text('Pending'),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    viewModel.currentFilter.toUpperCase(),
                    style: AppTypography.labelMedium,
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: CustomTextField(
              hint: 'Search consultations...',
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
                : viewModel.filteredConsultations.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.history,
                              size: 64,
                              color: AppColors.textLight,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No consultations found',
                              style: AppTypography.titleMedium.copyWith(
                                color: AppColors.textLight,
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: viewModel.refreshConsultations,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: viewModel.filteredConsultations.length,
                          itemBuilder: (context, index) {
                            return ConsultationCard(
                              consultation:
                                  viewModel.filteredConsultations[index],
                              onTap: () => viewModel.viewConsultationDetails(
                                viewModel.filteredConsultations[index].id,
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: viewModel.startNewConsultation,
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  ConsultationHistoryViewModel viewModelBuilder(BuildContext context) =>
      ConsultationHistoryViewModel();
}
