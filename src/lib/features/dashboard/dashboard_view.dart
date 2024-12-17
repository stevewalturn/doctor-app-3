import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:my_app/core/theme/app_colors.dart';
import 'package:my_app/core/theme/app_typography.dart';
import 'package:my_app/widgets/custom_card.dart';
import 'package:my_app/features/dashboard/dashboard_viewmodel.dart';

class DashboardView extends StackedView<DashboardViewModel> {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    DashboardViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor\'s Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: viewModel.logout,
          ),
        ],
      ),
      body: viewModel.isBusy
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: viewModel.refreshDashboard,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, Dr. ${viewModel.doctorName}',
                      style: AppTypography.headlineSmall,
                    ),
                    const SizedBox(height: 24),
                    _buildStatsGrid(viewModel),
                    const SizedBox(height: 24),
                    _buildQuickActions(viewModel),
                    const SizedBox(height: 24),
                    _buildRecentSection(viewModel),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatsGrid(DashboardViewModel viewModel) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildStatCard(
          'Total Patients',
          viewModel.totalPatients.toString(),
          Icons.people,
          AppColors.primary,
        ),
        _buildStatCard(
          'Today\'s Consultations',
          viewModel.todayConsultations.toString(),
          Icons.calendar_today,
          AppColors.secondary,
        ),
        _buildStatCard(
          'Pending Reviews',
          viewModel.pendingReviews.toString(),
          Icons.pending_actions,
          AppColors.warning,
        ),
        _buildStatCard(
          'Completed Today',
          viewModel.completedToday.toString(),
          Icons.check_circle,
          AppColors.success,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return CustomCard(
      backgroundColor: color.withOpacity(0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTypography.headlineMedium.copyWith(color: color),
          ),
          Text(
            title,
            style: AppTypography.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(DashboardViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Actions', style: AppTypography.titleLarge),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomCard(
                onTap: viewModel.navigateToNewConsultation,
                child: Column(
                  children: [
                    Icon(Icons.add_circle, color: AppColors.primary, size: 32),
                    const SizedBox(height: 8),
                    Text(
                      'New Consultation',
                      style: AppTypography.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomCard(
                onTap: viewModel.navigateToPatientList,
                child: Column(
                  children: [
                    Icon(Icons.people, color: AppColors.primary, size: 32),
                    const SizedBox(height: 8),
                    Text(
                      'View Patients',
                      style: AppTypography.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentSection(DashboardViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent Consultations', style: AppTypography.titleLarge),
            TextButton(
              onPressed: viewModel.navigateToConsultationHistory,
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (viewModel.recentConsultations.isEmpty)
          Center(
            child: Text(
              'No recent consultations',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: viewModel.recentConsultations.length,
            itemBuilder: (context, index) {
              final consultation = viewModel.recentConsultations[index];
              return CustomCard(
                onTap: () => viewModel.navigateToConsultationDetails(
                  consultation.id,
                ),
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(consultation.patient.name),
                  subtitle: Text(consultation.chiefComplaint),
                  trailing: Text(
                    viewModel.formatDate(consultation.consultationDate),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  @override
  DashboardViewModel viewModelBuilder(BuildContext context) =>
      DashboardViewModel();
}
