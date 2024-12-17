import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:my_app/app/app.locator.dart';
import 'package:my_app/models/consultation.dart';
import 'package:my_app/repositories/consultation_repository.dart';
import 'package:file_picker/file_picker.dart';

class ConsultationFormViewModel extends BaseViewModel {
  final _consultationRepository = locator<ConsultationRepository>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();

  final formKey = GlobalKey<FormState>();
  final chiefComplaintController = TextEditingController();
  final presentIllnessController = TextEditingController();
  final symptomsController = TextEditingController();
  final diagnosisController = TextEditingController();
  final treatmentController = TextEditingController();
  final notesController = TextEditingController();

  List<String> _attachments = [];
  List<String> get attachments => _attachments;

  Consultation? _consultation;
  bool get isEditing => _consultation != null;

  String get patientName => _consultation?.patient.name ?? '';
  String get patientId => _consultation?.patient.id ?? '';

  ConsultationFormViewModel() {
    loadConsultation();
  }

  Future<void> loadConsultation() async {
    try {
      setBusy(true);
      final consultationId = _navigationService.currentArguments as String?;

      if (consultationId != null) {
        _consultation =
            await _consultationRepository.getConsultation(consultationId);
        _populateFields();
      }
    } catch (e) {
      setError('Failed to load consultation data. Please try again.');
    } finally {
      setBusy(false);
    }
  }

  void _populateFields() {
    if (_consultation != null) {
      chiefComplaintController.text = _consultation!.chiefComplaint;
      presentIllnessController.text = _consultation!.presentIllness;
      symptomsController.text = _consultation!.symptoms.join(', ');
      diagnosisController.text = _consultation!.diagnosis.name;
      treatmentController.text = _consultation!.treatment;
      notesController.text = _consultation!.notes ?? '';
      _attachments = _consultation!.attachments ?? [];
    }
  }

  String? validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  Future<void> addAttachment() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx'],
      );

      if (result != null) {
        _attachments.addAll(
          result.files.map((file) => file.name).toList(),
        );
        notifyListeners();
      }
    } catch (e) {
      await _dialogService.showDialog(
        title: 'Error',
        description: 'Failed to add attachment. Please try again.',
        buttonTitle: 'OK',
      );
    }
  }

  void removeAttachment(int index) {
    _attachments.removeAt(index);
    notifyListeners();
  }

  Future<void> saveConsultation() async {
    if (!formKey.currentState!.validate()) return;

    try {
      setBusy(true);

      final consultationData = {
        'chiefComplaint': chiefComplaintController.text.trim(),
        'presentIllness': presentIllnessController.text.trim(),
        'symptoms':
            symptomsController.text.split(',').map((s) => s.trim()).toList(),
        'diagnosis': {
          'name': diagnosisController.text.trim(),
          // Add more diagnosis fields as needed
        },
        'treatment': treatmentController.text.trim(),
        'notes': notesController.text.trim(),
        'attachments': _attachments,
        'status': 'completed',
      };

      if (isEditing) {
        await _consultationRepository.updateConsultation(
          _consultation!.id,
          consultationData,
        );
      } else {
        await _consultationRepository.createConsultation(consultationData);
      }

      await _dialogService.showDialog(
        title: 'Success',
        description: isEditing
            ? 'Consultation updated successfully'
            : 'Consultation saved successfully',
        buttonTitle: 'OK',
      );

      _navigationService.back();
    } catch (e) {
      setError(isEditing
          ? 'Failed to update consultation. Please try again.'
          : 'Failed to save consultation. Please try again.');
    } finally {
      setBusy(false);
    }
  }

  Future<void> deleteConsultation() async {
    if (!isEditing) return;

    final response = await _dialogService.showDialog(
      title: 'Delete Consultation',
      description: 'Are you sure you want to delete this consultation?',
      buttonTitle: 'Delete',
      cancelTitle: 'Cancel',
    );

    if (response?.confirmed ?? false) {
      try {
        setBusy(true);
        await _consultationRepository.deleteConsultation(_consultation!.id);
        _navigationService.back();
      } catch (e) {
        setError('Failed to delete consultation. Please try again.');
      } finally {
        setBusy(false);
      }
    }
  }

  @override
  void dispose() {
    chiefComplaintController.dispose();
    presentIllnessController.dispose();
    symptomsController.dispose();
    diagnosisController.dispose();
    treatmentController.dispose();
    notesController.dispose();
    super.dispose();
  }
}
