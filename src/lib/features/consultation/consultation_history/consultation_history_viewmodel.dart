import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:my_app/app/app.locator.dart';
import 'package:my_app/app/app.router.dart';
import 'package:my_app/models/consultation.dart';
import 'package:my_app/repositories/consultation_repository.dart';

class ConsultationHistoryViewModel extends BaseViewModel {
  final _consultationRepository = locator<ConsultationRepository>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();

  final searchController = TextEditingController();

  List<Consultation> _allConsultations = [];
  List<Consultation> _filteredConsultations = [];
  List<Consultation> get filteredConsultations => _filteredConsultations;

  String _currentFilter = 'all';
  String get currentFilter => _currentFilter;

  ConsultationHistoryViewModel() {
    loadConsultations();
  }

  Future<void> loadConsultations() async {
    try {
      setBusy(true);
      _allConsultations = await _consultationRepository.getConsultations();
      _applyFilters();
    } catch (e) {
      setError('Failed to load consultations. Please try again.');
    } finally {
      setBusy(false);
    }
  }

  void _applyFilters() {
    var filtered = List<Consultation>.from(_allConsultations);

    // Apply status filter
    if (_currentFilter != 'all') {
      filtered = filtered
          .where((c) => c.status.toLowerCase() == _currentFilter.toLowerCase())
          .toList();
    }

    // Apply search filter
    final searchQuery = searchController.text.toLowerCase();
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((c) {
        return c.patient.name.toLowerCase().contains(searchQuery) ||
            c.chiefComplaint.toLowerCase().contains(searchQuery) ||
            c.diagnosis.name.toLowerCase().contains(searchQuery);
      }).toList();
    }

    _filteredConsultations = filtered;
    notifyListeners();
  }

  void onFilterChanged(String filter) {
    _currentFilter = filter;
    _applyFilters();
  }

  void onSearchChanged(String query) {
    _applyFilters();
  }

  Future<void> refreshConsultations() async {
    await loadConsultations();
  }

  void viewConsultationDetails(String consultationId) {
    _navigationService.navigateTo(
      Routes.consultationFormView,
      arguments: consultationId,
    );
  }

  Future<void> startNewConsultation() async {
    try {
      final consultation = await _consultationRepository.createConsultation({
        'status': 'pending',
        'consultationDate': DateTime.now().toIso8601String(),
      });

      await _navigationService.navigateTo(
        Routes.consultationFormView,
        arguments: consultation.id,
      );

      await refreshConsultations();
    } catch (e) {
      await _dialogService.showDialog(
        title: 'Error',
        description: 'Failed to create new consultation. Please try again.',
        buttonTitle: 'OK',
      );
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
