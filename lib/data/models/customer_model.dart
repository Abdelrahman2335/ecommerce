import 'package:ecommerce/data/models/address_model.dart';
import 'package:ecommerce/domain/entities/user_model.dart';

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
  String? gender;
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
      if (address != null) 'address': address!.map((a)=> a.toJson()).toList(),
      if (age != null) 'age': age!.trim(),
      if (gender != null) 'gender': gender,
    };
  }
}
