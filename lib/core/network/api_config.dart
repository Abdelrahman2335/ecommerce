import 'package:injectable/injectable.dart';

@lazySingleton
class ApiConfig {
  final String dummyJsonBaseUrl;
  final String nominatimBaseUrl;
  final String osmTileUrl;
  final String payAuth;
  final String payBaseUrl;

  ApiConfig._(
      {required this.dummyJsonBaseUrl,
      required this.nominatimBaseUrl,
      required this.osmTileUrl,
      required this.payAuth,
      required this.payBaseUrl});

  @factoryMethod
  static ApiConfig create() => ApiConfig._(
        dummyJsonBaseUrl: "https://dummyjson.com/products/",
        nominatimBaseUrl: "https://nominatim.openstreetmap.org/",
        osmTileUrl: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
        payAuth: "https://accept.paymob.com/api/auth/",
        payBaseUrl: "https://accept.paymob.com/api/ecommerce/",
      );
}
