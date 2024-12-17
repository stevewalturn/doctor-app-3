import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:my_app/app/app.locator.dart';
import 'package:my_app/app/app.router.dart';
import 'package:my_app/services/authentication_service.dart';

class ActivityItem {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;

  ActivityItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
  });
}

class DashboardViewModel extends BaseViewModel {
  final _authService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();

  String get doctorName => _authService.currentUser?.name ?? 'Unknown';
  int get totalPatients => 156; // TODO: Implement real data
  int get todayConsultations => 8; // TODO: Implement real data
  int get pendingReviews => 3; // TODO: Implement real data
  int get totalConsultations => 427; // TODO: Implement real data

  List<ActivityItem> get recentActivities => [
        ActivityItem(
          title: 'New Consultation',
          subtitle: 'Patient: John Doe',
          time: '2h ago',
          icon: Icons.medical_services,
        ),
        ActivityItem(
          title: 'Updated Patient Record',
          subtitle: 'Patient: Jane Smith',
          time: '4h ago',
          icon: Icons.edit_document,
        ),
        ActivityItem(
          title: 'Prescription Added',
          subtitle: 'Patient: Mike Johnson',
          time: '5h ago',
          icon: Icons.medication,
        ),
      ];

  Future<void> logout() async {
    final result = await _dialogService.showDialog(
      title: 'Logout',
      description: 'Are you sure you want to logout?',
      buttonTitle: 'Yes',
      cancelTitle: 'No',
    );

    if (result?.confirmed ?? false) {
      try {
        await _authService.logout();
        await _navigationService.clearStackAndShow(Routes.loginView);
      } catch (error) {
        setError(error.toString());
      }
    }
  }

  void navigateToNewConsultation() {
    _navigationService.navigateToNewConsultationView();
  }

  void navigateToPatientList() {
    _navigationService.navigateToPatientListView();
  }
}
