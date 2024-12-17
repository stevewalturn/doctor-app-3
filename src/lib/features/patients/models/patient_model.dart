import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'patient_model.g.dart';

@JsonSerializable()
class PatientModel extends Equatable {
  final String id;
  final String name;
  final String phoneNumber;
  final String email;
  final int age;
  final String gender;
  final String bloodGroup;
  final String address;
  final List<String> allergies;
  final List<String> chronicConditions;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final Map<String, dynamic>? medicalHistory;

  const PatientModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.age,
    required this.gender,
    required this.bloodGroup,
    required this.address,
    required this.allergies,
    required this.chronicConditions,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    this.medicalHistory,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) =>
      _$PatientModelFromJson(json);

  Map<String, dynamic> toJson() => _$PatientModelToJson(this);

  PatientModel copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? email,
    int? age,
    String? gender,
    String? bloodGroup,
    String? address,
    List<String>? allergies,
    List<String>? chronicConditions,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    Map<String, dynamic>? medicalHistory,
  }) {
    return PatientModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      address: address ?? this.address,
      allergies: allergies ?? this.allergies,
      chronicConditions: chronicConditions ?? this.chronicConditions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      medicalHistory: medicalHistory ?? this.medicalHistory,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        phoneNumber,
        email,
        age,
        gender,
        bloodGroup,
        address,
        allergies,
        chronicConditions,
        createdAt,
        updatedAt,
        createdBy,
        medicalHistory,
      ];
}
