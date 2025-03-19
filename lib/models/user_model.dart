class UserModel {
  /// Required information
  final String name;
  final String email;
  final String role;
  final String phone;
  final String address;
  final DateTime createdAt;
  /// Optional
   DateTime? age;
   DateTime? gender;

  UserModel({
    required this.name,
    required this.email,
    required this.role,
    required this.phone,
    required this.address,
    required this.createdAt,
    this.age,
    this.gender,
  });

  factory UserModel.fromJson(Map<String,dynamic>json){
    return UserModel(
      name: json['name'],
      email: json['email'],
      role: json['role'],
      phone: json['phone'],
      address: json['address'],
      createdAt: json['createdAt'],
      age: json['age'],
      gender: json['gender'],
    );
  }
  Map<String, dynamic> toJson(){
    return {
      'name': name,
      'email': email,
      'role': role,
      'phone': phone,
      'address': address,
      'createdAt': createdAt,
      'age': age,
      'gender': gender,
    };
  }
}