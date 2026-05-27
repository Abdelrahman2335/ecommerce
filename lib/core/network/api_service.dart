import 'package:dio/dio.dart';
import 'package:ecommerce/core/network/api_config.dart';
import 'package:injectable/injectable.dart';

import 'dio_client.dart';

@lazySingleton
class ApiService {
  ApiService(this._config)
      : _dio = DioClient.initializeDio(url: _config.dummyJsonBaseUrl,);

  final ApiConfig _config;
  final Dio _dio;

  String get defaultBaseUrl => _config.dummyJsonBaseUrl;
  String get nominatimBaseUrl => _config.nominatimBaseUrl;

  Future<dynamic> get({
    String? baseUrl,
    String endPoint = "",
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    _dio.options.baseUrl = (baseUrl == null || baseUrl.isEmpty)
        ? _config.dummyJsonBaseUrl
        : baseUrl;

    final response = await _dio.get(
      endPoint,
      queryParameters: queryParameters,
      options: headers == null ? null : Options(headers: headers),
    );

    return response.data;
  }
}
