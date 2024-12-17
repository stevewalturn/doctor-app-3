import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'diagnosis_model.g.dart';

@JsonSerializable()
class DiagnosisModel extends Equatable {
  final String id;
  final String consultationId;
  final String condition;
  final String description;
  final List<String> symptoms;
  final List<String> treatments;
  final List<String> medications;
  final String notes;
  final DateTime diagnosedAt;
  final String diagnosedBy;
  final bool isActive;

  const DiagnosisModel({
    required this.id,
    required this.consultationId,
    required this.condition,
    required this.description,
    required this.symptoms,
    required this.treatments,
    required this.medications,
    required this.notes,
    required this.diagnosedAt,
    required this.diagnosedBy,
    required this.isActive,
  });

  factory DiagnosisModel.fromJson(Map<String, dynamic> json) =>
      _$DiagnosisModelFromJson(json);

  Map<String, dynamic> toJson() => _$DiagnosisModelToJson(this);

  DiagnosisModel copyWith({
    String? id,
    String? consultationId,
    String? condition,
    String? description,
    List<String>? symptoms,
    List<String>? treatments,
    List<String>? medications,
    String? notes,
    DateTime? diagnosedAt,
    String? diagnosedBy,
    bool? isActive,
  }) {
    return DiagnosisModel(
      id: id ?? this.id,
      consultationId: consultationId ?? this.consultationId,
      condition: condition ?? this.condition,
      description: description ?? this.description,
      symptoms: symptoms ?? this.symptoms,
      treatments: treatments ?? this.treatments,
      medications: medications ?? this.medications,
      notes: notes ?? this.notes,
      diagnosedAt: diagnosedAt ?? this.diagnosedAt,
      diagnosedBy: diagnosedBy ?? this.diagnosedBy,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
        id,
        consultationId,
        condition,
        description,
        symptoms,
        treatments,
        medications,
        notes,
        diagnosedAt,
        diagnosedBy,
        isActive,
      ];
}
