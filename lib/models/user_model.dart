import 'package:ecommerce/models/address_model.dart';

class UserModel {
  /// Required information
  String? name;
  String? role;
  String? phone;
  AddressModel? address;
  DateTime? createdAt;

  /// Optional
  DateTime? age;
  DateTime? gender;

  UserModel({
    this.name,
    this.role,
    this.phone,
    this.address,
    this.createdAt,
    this.age,
    this.gender,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      role: json['role'],
      phone: json['phone'],
      address: json['address'],
      createdAt: json['createdAt'],
      age: json['age'],
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'role': role,
      'phone': phone,
      'address': address,
      'createdAt': createdAt,
      'age': age,
      'gender': gender,
    };
  }
}
