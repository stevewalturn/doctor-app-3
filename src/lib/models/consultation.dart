import 'package:equatable/equatable.dart';
import 'package:my_app/models/diagnosis.dart';
import 'package:my_app/models/patient.dart';
import 'package:my_app/models/user.dart';

class Consultation extends Equatable {
  final String id;
  final Patient patient;
  final User doctor;
  final DateTime consultationDate;
  final String chiefComplaint;
  final String presentIllness;
  final List<String> symptoms;
  final Diagnosis diagnosis;
  final String treatment;
  final String? notes;
  final List<String>? attachments;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Consultation({
    required this.id,
    required this.patient,
    required this.doctor,
    required this.consultationDate,
    required this.chiefComplaint,
    required this.presentIllness,
    required this.symptoms,
    required this.diagnosis,
    required this.treatment,
    this.notes,
    this.attachments,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Consultation.fromJson(Map<String, dynamic> json) {
    return Consultation(
      id: json['id'] as String,
      patient: Patient.fromJson(json['patient'] as Map<String, dynamic>),
      doctor: User.fromJson(json['doctor'] as Map<String, dynamic>),
      consultationDate: DateTime.parse(json['consultationDate'] as String),
      chiefComplaint: json['chiefComplaint'] as String,
      presentIllness: json['presentIllness'] as String,
      symptoms: (json['symptoms'] as List).cast<String>(),
      diagnosis: Diagnosis.fromJson(json['diagnosis'] as Map<String, dynamic>),
      treatment: json['treatment'] as String,
      notes: json['notes'] as String?,
      attachments: (json['attachments'] as List?)?.cast<String>(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient': patient.toJson(),
      'doctor': doctor.toJson(),
      'consultationDate': consultationDate.toIso8601String(),
      'chiefComplaint': chiefComplaint,
      'presentIllness': presentIllness,
      'symptoms': symptoms,
      'diagnosis': diagnosis.toJson(),
      'treatment': treatment,
      'notes': notes,
      'attachments': attachments,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Consultation copyWith({
    String? id,
    Patient? patient,
    User? doctor,
    DateTime? consultationDate,
    String? chiefComplaint,
    String? presentIllness,
    List<String>? symptoms,
    Diagnosis? diagnosis,
    String? treatment,
    String? notes,
    List<String>? attachments,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Consultation(
      id: id ?? this.id,
      patient: patient ?? this.patient,
      doctor: doctor ?? this.doctor,
      consultationDate: consultationDate ?? this.consultationDate,
      chiefComplaint: chiefComplaint ?? this.chiefComplaint,
      presentIllness: presentIllness ?? this.presentIllness,
      symptoms: symptoms ?? this.symptoms,
      diagnosis: diagnosis ?? this.diagnosis,
      treatment: treatment ?? this.treatment,
      notes: notes ?? this.notes,
      attachments: attachments ?? this.attachments,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        patient,
        doctor,
        consultationDate,
        chiefComplaint,
        presentIllness,
        symptoms,
        diagnosis,
        treatment,
        notes,
        attachments,
        status,
        createdAt,
        updatedAt,
      ];
}
