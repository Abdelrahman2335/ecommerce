import 'package:ecommerce/core/models/user_model.dart';

class AdminModel implements UserEntity {
  @override
  String? name;

  @override
  String? age;

  @override
  DateTime? createdAt;

  @override
  Genders? gender;

  @override
  String? phone;

  @override
  String? role;

  AdminModel({
    this.age,
    this.name,
    this.role = "customer",
    this.phone,
    this.createdAt,
    this.gender,
  });

  factory AdminModel.fromJson(Map<String, dynamic> json) => AdminModel(
        name: json['name'],
        role: json['role'],
        phone: json['phone'],
        createdAt: json['createdAt'],
        age: json['age'],
        gender: json['gender'],
      );

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name!.trim(),
      if (role != null) 'role': role,
      if (phone != null) 'phone': phone!.trim(),
      if (createdAt != null) 'createdAt': createdAt,
      if (age != null) 'age': age!.trim(),
      if (gender != null) 'gender': gender,
    };
  }

  AdminModel copyWith({
    String? name,
    String? role,
    String? phone,
    DateTime? createdAt,
    String? age,
    Genders? gender,
  }) {
    return AdminModel(
      name: name ?? this.name,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      age: age ?? this.age,
      gender: gender ?? this.gender,
    );
  }
}
