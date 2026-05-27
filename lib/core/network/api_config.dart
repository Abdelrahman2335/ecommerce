import 'package:injectable/injectable.dart';

@lazySingleton
class ApiConfig {
  final String dummyJsonBaseUrl;
  final String nominatimBaseUrl;
  final String osmTileUrl;

  ApiConfig._({
    required this.dummyJsonBaseUrl,
    required this.nominatimBaseUrl,
    required this.osmTileUrl,
  });

  @factoryMethod
  static ApiConfig create() => ApiConfig._(
        dummyJsonBaseUrl: "https://dummyjson.com/products/",
        nominatimBaseUrl: "https://nominatim.openstreetmap.org/",
        osmTileUrl: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
      );
}
