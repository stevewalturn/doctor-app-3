import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  final String id;
  final String email;
  final String name;
  final String phoneNumber;
  final String specialization;
  final String? profileImage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isEmailVerified;
  final List<String> roles;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.specialization,
    this.profileImage,
    required this.createdAt,
    required this.updatedAt,
    required this.isEmailVerified,
    required this.roles,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? phoneNumber,
    String? specialization,
    String? profileImage,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isEmailVerified,
    List<String>? roles,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      specialization: specialization ?? this.specialization,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      roles: roles ?? this.roles,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        phoneNumber,
        specialization,
        profileImage,
        createdAt,
        updatedAt,
        isEmailVerified,
        roles,
      ];
}
