import 'package:equatable/equatable.dart';

class Patient extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final DateTime dateOfBirth;
  final String gender;
  final String? bloodType;
  final List<String>? allergies;
  final String? medicalHistory;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Patient({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.gender,
    this.bloodType,
    this.allergies,
    this.medicalHistory,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      gender: json['gender'] as String,
      bloodType: json['bloodType'] as String?,
      allergies: (json['allergies'] as List?)?.cast<String>(),
      medicalHistory: json['medicalHistory'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'gender': gender,
      'bloodType': bloodType,
      'allergies': allergies,
      'medicalHistory': medicalHistory,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Patient copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    DateTime? dateOfBirth,
    String? gender,
    String? bloodType,
    List<String>? allergies,
    String? medicalHistory,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Patient(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      bloodType: bloodType ?? this.bloodType,
      allergies: allergies ?? this.allergies,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phoneNumber,
        dateOfBirth,
        gender,
        bloodType,
        allergies,
        medicalHistory,
        createdAt,
        updatedAt,
      ];
}
