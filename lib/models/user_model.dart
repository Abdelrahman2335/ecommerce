class UserModel {
  /// Required information
  String? name;
  String? role;
  String? phone;
  String? fullAddress;
  String? country;
  String? city;
  String? area;
  String? street;
  double? latitude;
  double? longitude;
  DateTime? createdAt;

  /// Optional
  String? age;
  String? gender;

  UserModel({
    this.name,
    this.role,
    this.phone,
    this.fullAddress,
    this.country,
    this.city,
    this.area,
    this.street,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.age,
    this.gender,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      role: json['role'],
      phone: json['phone'],
      fullAddress: json['address'],
      country: json['country'],
      city: json['city'],
      area: json['area'],
      street: json['street'],
      latitude: json['latitude'],
      longitude: json['longitude'],
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
      if (fullAddress != null) 'address': fullAddress!.trim(),
      if (country != null) 'country': country!.trim(),
      if (city != null) 'city': city!.trim(),
      if (area != null) 'area': area!.trim(),
      if (street != null) 'street': street!.trim(),
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (createdAt != null) 'createdAt': createdAt,
      if (age != null) 'age': age!.trim(),
      if (gender != null) 'gender': gender,
    };
  }
}
