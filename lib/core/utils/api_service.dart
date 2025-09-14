import 'package:dio/dio.dart';

class ApiService {
  ApiService._internal();
  static final ApiService instance = ApiService._internal();

  factory ApiService() => instance;

  final _baseUrl = 'https://dummyjson.com/products/';

  final Dio _dio = Dio();

  Future<Map<String, dynamic>> get(
      {String? baseUrl, String endPoint = ""}) async {
    var response = await _dio.get("$baseUrl??$_baseUrl$endPoint");

    return response.data;
  }
}
