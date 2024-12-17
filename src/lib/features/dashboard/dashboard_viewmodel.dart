import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:my_app/app/app.locator.dart';
import 'package:my_app/app/app.router.dart';
import 'package:my_app/models/consultation.dart';
import 'package:my_app/repositories/auth_repository.dart';
import 'package:my_app/repositories/consultation_repository.dart';
import 'package:intl/intl.dart';

class DashboardViewModel extends BaseViewModel {
  final _authRepository = locator<AuthRepository>();
  final _consultationRepository = locator<ConsultationRepository>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();

  String get doctorName => _authRepository.currentUser?.name ?? '';

  int _totalPatients = 0;
  int get totalPatients => _totalPatients;

  int _todayConsultations = 0;
  int get todayConsultations => _todayConsultations;

  int _pendingReviews = 0;
  int get pendingReviews => _pendingReviews;

  int _completedToday = 0;
  int get completedToday => _completedToday;

  List<Consultation> _recentConsultations = [];
  List<Consultation> get recentConsultations => _recentConsultations;

  DashboardViewModel() {
    initialize();
  }

  Future<void> initialize() async {
    await loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    try {
      setBusy(true);

      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final consultations = await _consultationRepository.getConsultations(
        startDate: startOfDay,
        endDate: endOfDay,
      );

      _recentConsultations = consultations.take(5).toList();
      _todayConsultations = consultations.length;
      _completedToday = consultations
          .where((c) => c.status.toLowerCase() == 'completed')
          .length;
      _pendingReviews = consultations
          .where((c) => c.status.toLowerCase() == 'pending')
          .length;

      // This would normally come from a separate API call
      _totalPatients = 150;

      notifyListeners();
    } catch (e) {
      setError(e.toString());
      await _dialogService.showDialog(
        title: 'Error',
        description: 'Failed to load dashboard data. Please try again.',
        buttonTitle: 'OK',
      );
    } finally {
      setBusy(false);
    }
  }

  Future<void> refreshDashboard() async {
    await loadDashboardData();
  }

  String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  void navigateToNewConsultation() {
    _navigationService.navigateTo(Routes.consultationFormView);
  }

  void navigateToPatientList() {
    _navigationService.navigateTo(Routes.patientListView);
  }

  void navigateToConsultationHistory() {
    _navigationService.navigateTo(Routes.consultationHistoryView);
  }

  void navigateToConsultationDetails(String consultationId) {
    _navigationService.navigateTo(
      Routes.consultationFormView,
      arguments: consultationId,
    );
  }

  Future<void> logout() async {
    final dialogResponse = await _dialogService.showDialog(
      title: 'Logout',
      description: 'Are you sure you want to logout?',
      buttonTitle: 'Yes',
      cancelTitle: 'No',
    );

    if (dialogResponse?.confirmed ?? false) {
      try {
        await _authRepository.logout();
        await _navigationService.clearStackAndShow(Routes.loginView);
      } catch (e) {
        await _dialogService.showDialog(
          title: 'Error',
          description: 'Failed to logout. Please try again.',
          buttonTitle: 'OK',
        );
      }
    }
  }
}
