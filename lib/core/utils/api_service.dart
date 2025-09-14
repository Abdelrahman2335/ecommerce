import 'package:dio/dio.dart';

class ApiService {
  ApiService._internal();
  static final ApiService instance = ApiService._internal();

  factory ApiService() => instance;

  var _baseUrl = 'https://dummyjson.com/products/';

  final Dio _dio = Dio();

  Future<dynamic> get({String? baseUrl, String endPoint = ""}) async {
    _baseUrl = baseUrl ?? _baseUrl;
    var response = await _dio.get("$_baseUrl$endPoint");

    return response.data;
  }
}
