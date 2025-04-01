import 'package:ecommerce/data/models/address_model.dart';

class UserModel {
  /// Required information
  String? name;
  String? role;
  String? phone;
  AddressModel? address;
  DateTime? createdAt;

  /// Optional
  String? age;
  String? gender;

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
      if (name != null) 'name': name!.trim(),
      if (role != null) 'role': role,
      if (phone != null) 'phone': phone!.trim(),
      if (address != null) 'address': address,

      if (createdAt != null) 'createdAt': createdAt,
      if (age != null) 'age': age!.trim(),
      if (gender != null) 'gender': gender,
    };
  }
  Map<String, dynamic> addressToJson() {
    return {
      'address': address?.toJson(), // Convert the AddressModel to a Map
    };
  }

}
