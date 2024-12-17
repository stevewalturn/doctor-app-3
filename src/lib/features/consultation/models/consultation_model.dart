import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'consultation_model.g.dart';

@JsonSerializable()
class ConsultationModel extends Equatable {
  final String id;
  final String patientId;
  final String patientName;
  final String doctorId;
  final String doctorName;
  final DateTime date;
  final String chiefComplaint;
  final String diagnosis;
  final List<String> symptoms;
  final List<String> medications;
  final List<String> tests;
  final String notes;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ConsultationModel({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.doctorId,
    required this.doctorName,
    required this.date,
    required this.chiefComplaint,
    required this.diagnosis,
    required this.symptoms,
    required this.medications,
    required this.tests,
    required this.notes,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ConsultationModel.fromJson(Map<String, dynamic> json) =>
      _$ConsultationModelFromJson(json);

  Map<String, dynamic> toJson() => _$ConsultationModelToJson(this);

  ConsultationModel copyWith({
    String? id,
    String? patientId,
    String? patientName,
    String? doctorId,
    String? doctorName,
    DateTime? date,
    String? chiefComplaint,
    String? diagnosis,
    List<String>? symptoms,
    List<String>? medications,
    List<String>? tests,
    String? notes,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ConsultationModel(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      date: date ?? this.date,
      chiefComplaint: chiefComplaint ?? this.chiefComplaint,
      diagnosis: diagnosis ?? this.diagnosis,
      symptoms: symptoms ?? this.symptoms,
      medications: medications ?? this.medications,
      tests: tests ?? this.tests,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        patientId,
        patientName,
        doctorId,
        doctorName,
        date,
        chiefComplaint,
        diagnosis,
        symptoms,
        medications,
        tests,
        notes,
        status,
        createdAt,
        updatedAt,
      ];
}
