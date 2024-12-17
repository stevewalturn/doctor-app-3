import 'package:equatable/equatable.dart';

class Diagnosis extends Equatable {
  final String id;
  final String name;
  final String description;
  final String icdCode;
  final String category;
  final List<String>? differentials;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Diagnosis({
    required this.id,
    required this.name,
    required this.description,
    required this.icdCode,
    required this.category,
    this.differentials,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Diagnosis.fromJson(Map<String, dynamic> json) {
    return Diagnosis(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      icdCode: json['icdCode'] as String,
      category: json['category'] as String,
      differentials: (json['differentials'] as List?)?.cast<String>(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icdCode': icdCode,
      'category': category,
      'differentials': differentials,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Diagnosis copyWith({
    String? id,
    String? name,
    String? description,
    String? icdCode,
    String? category,
    List<String>? differentials,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Diagnosis(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icdCode: icdCode ?? this.icdCode,
      category: category ?? this.category,
      differentials: differentials ?? this.differentials,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        icdCode,
        category,
        differentials,
        createdAt,
        updatedAt,
      ];
}
