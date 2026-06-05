class AddressModel {
  String? fullAddress;
  String? country;
  String? city;
  String? area;
  String? street;
  double? latitude;
  double? longitude;
  bool? defaultAddress;

  AddressModel(
      {this.city,
      this.area,
      this.street,
      this.country,
      this.fullAddress,
      this.latitude,
      this.longitude,
      this.defaultAddress = false});

  AddressModel copyWith({
    String? fullAddress,
    String? country,
    String? city,
    String? area,
    String? street,
    double? latitude,
    double? longitude,
    bool? defaultAddress,
  }) {
    return AddressModel(
      fullAddress: fullAddress ?? this.fullAddress,
      country: country ?? this.country,
      city: city ?? this.city,
      area: area ?? this.area,
      street: street ?? this.street,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      defaultAddress: defaultAddress ?? this.defaultAddress,
    );
  }

  /// Optionally, create a fromJson() method for deserialization
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      fullAddress: json['fullAddress'],
      country: json['country'],
      city: json['city'],
      area: json['area'],
      street: json['street'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      defaultAddress: json['defaultAddress'] ?? false,
    );
  }

  /// Convert AddressModel to a Map for Firestore
  Map<String, dynamic> toJson() {
    return {
      if (fullAddress != null) 'fullAddress': fullAddress,
      if (country != null) 'country': country,
      if (city != null) 'city': city,
      if (area != null) 'area': area,
      if (street != null) 'street': street,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      'defaultAddress': defaultAddress ?? false,
    };
  }

  bool get isValid {
    return city != null &&
        city!.isNotEmpty &&
        area != null &&
        area!.isNotEmpty &&
        street != null &&
        street!.isNotEmpty;
  }

  String? get validationError {
    if (city == null || city!.isEmpty) {
      return 'City is required';
    }
    if (area == null || area!.isEmpty) {
      return 'Area is required';
    }
    if (street == null || street!.isEmpty) {
      return 'Street is required';
    }
    return null;
  }
}
