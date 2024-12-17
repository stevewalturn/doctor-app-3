import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:my_app/ui/widgets/custom_button.dart';
import 'package:my_app/features/dashboard/dashboard_viewmodel.dart';

class DashboardView extends StackedView<DashboardViewModel> {
  const DashboardView({super.key});

  @override
  Widget builder(
    BuildContext context,
    DashboardViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: viewModel.logout,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, Dr. ${viewModel.doctorName}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              _buildStatsCards(context, viewModel),
              const SizedBox(height: 32),
              _buildQuickActions(context, viewModel),
              const SizedBox(height: 32),
              _buildRecentActivity(context, viewModel),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCards(BuildContext context, DashboardViewModel viewModel) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _buildStatCard(
          context,
          'Total Patients',
          viewModel.totalPatients.toString(),
          Icons.people,
          Colors.blue,
        ),
        _buildStatCard(
          context,
          'Today\'s Consultations',
          viewModel.todayConsultations.toString(),
          Icons.calendar_today,
          Colors.green,
        ),
        _buildStatCard(
          context,
          'Pending Reviews',
          viewModel.pendingReviews.toString(),
          Icons.pending_actions,
          Colors.orange,
        ),
        _buildStatCard(
          context,
          'Total Consultations',
          viewModel.totalConsultations.toString(),
          Icons.medical_services,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: color.withOpacity(0.8),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(
      BuildContext context, DashboardViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomButton(
                text: 'New Consultation',
                onPressed: viewModel.navigateToNewConsultation,
                icon: Icons.add_circle_outline,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomButton(
                text: 'View Patients',
                onPressed: viewModel.navigateToPatientList,
                type: ButtonType.secondary,
                icon: Icons.people_outline,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentActivity(
      BuildContext context, DashboardViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        if (viewModel.recentActivities.isEmpty)
          Center(
            child: Text(
              'No recent activity',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: viewModel.recentActivities.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final activity = viewModel.recentActivities[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  child: Icon(
                    activity.icon,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                title: Text(activity.title),
                subtitle: Text(activity.subtitle),
                trailing: Text(
                  activity.time,
                  style: Theme.of(context).textTheme.bodySmall,
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
