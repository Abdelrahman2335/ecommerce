import 'package:injectable/injectable.dart';

@lazySingleton
class ApiConfig {
  final String dummyJsonBaseUrl;
  final String nominatimBaseUrl;

  ApiConfig._({
    required this.dummyJsonBaseUrl,
    required this.nominatimBaseUrl,
  });

  @factoryMethod
  static ApiConfig create() => ApiConfig._(
        dummyJsonBaseUrl: "https://dummyjson.com/products/",
        nominatimBaseUrl: "https://nominatim.openstreetmap.org/",
      );
}
