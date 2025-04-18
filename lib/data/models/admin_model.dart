import 'package:ecommerce/domain/entities/user_model.dart';

class AdminModel implements UserEntity {
  @override
  String? age;

  @override
  DateTime? createdAt;

  @override
  String? gender;

  @override
  String? name;

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
}
