class AddressModel {
  String? fullAddress;
  String? country;
  String? city;
  String? area;
  String? street;
  double? latitude;
  double? longitude;

  AddressModel(
      {this.city,
      this.area,
      this.street,
      this.country,
      this.fullAddress,
      this.latitude,
      this.longitude});


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
    );
  }

  /// Convert AddressModel to a Map for Firestore
  Map<String, dynamic> toJson() {
    return {
    if(fullAddress != null)  'fullAddress': fullAddress,
      if (country != null) 'country': country,
      if (city != null) 'city': city,
      if (area != null) 'area': area,
      if (street != null) 'street': street,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    };
  }

}
