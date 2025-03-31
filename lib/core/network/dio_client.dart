
import 'package:dio/dio.dart';

class DioClient {

  static Dio initializeDio({required String url}) {

    return Dio(
      BaseOptions(
        baseUrl: url,
        connectTimeout: Duration(seconds: 10),
        receiveTimeout: Duration(seconds: 10),

      ),
    );
  }

}