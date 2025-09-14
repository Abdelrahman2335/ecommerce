import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../../core/network/dio_client.dart';
import '../../domain/repositories/payment_repository.dart';

/// When a class [implements] an abstract class, it must provide an implementation for all methods in that abstract class.
class PaymentRepositoryImpl implements PaymentRepository {
  static String apiKey =
      FirebaseRemoteConfig.instance.getString("paymob_api_key");

  final Dio _authDio =
      DioClient.initializeDio(url: "https://accept.paymob.com/api/auth");
  final Dio _paymentDio =
      DioClient.initializeDio(url: "https://accept.paymob.com/api/ecommerce");

  @override
  Future<String?> getPaymentToken() async {
    /// Getting the token by sending your api key or you can use your username and password related Documentation
    /// https://developers.paymob.com/egypt/payment-links/payment-link-api/login
    try {
      final response = await _authDio.post("/tokens", data: {
        "api_key": apiKey,
      });
      return response.data["token"];
    } catch (error) {
      log("Error when getting the token: $error");

      rethrow;
    }
  }

  @override
  Future<String?> createPaymentLink(String token, num amount) async {
    return await _paymentDio
        .post(
      "/payment-links",
      data: {
        "is_live": false,
        "amount_cents": amount,
        "expiration": 3600,
        "payment_methods": [5021285],
        "currency": "EGP",
        "customer": {
          "email": "user@example.com",
          "phone_number": "201234567890"
        }
      },
      options: Options(headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      }),
    )
        .then((response) {
      log("Payment link response: ${response.data}");
      return response.data["client_url"];
    }).catchError((error) {
      if (error is DioException) {
        log("Error in the payment link: ${error.response?.data}");
      } else {
        log("Unexpected error: $error");
        throw error;
      }
    });
  }
}
