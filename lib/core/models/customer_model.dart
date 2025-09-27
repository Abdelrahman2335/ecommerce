import 'package:ecommerce/core/models/address_model.dart';
import 'package:ecommerce/core/models/user_model.dart';

class CustomerModel extends UserEntity {
  @override
  String? name;
  @override
  String? role;
  @override
  String? phone;
  @override
  DateTime? createdAt;
  @override
  String? age;
  @override
  Genders? gender;
  List<AddressModel>? address;

  CustomerModel({
    this.name,
    this.role = "customer",
    this.phone,
    this.createdAt,
    this.address,
    this.age,
    this.gender,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      name: json['name'],
      role: json['role'],
      phone: json['phone'],
      createdAt: json['createdAt'],
      address: json['address'],
      age: json['age'],
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name!.trim(),
      if (role != null) 'role': role,
      if (phone != null) 'phone': phone!.trim(),
      if (createdAt != null) 'createdAt': createdAt,
      if (address != null) 'address': address!.map((a) => a.toJson()).toList(),
      if (age != null) 'age': age!.trim(),
      if (gender != null) 'gender': gender,
    };
  }

  CustomerModel copyWith({
    String? name,
    String? role,
    String? phone,
    DateTime? createdAt,
    String? age,
    Genders? gender,
    List<AddressModel>? address,
  }) {
    return CustomerModel(
      name: name ?? this.name,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      address: address ?? this.address,
    );
  }
}
