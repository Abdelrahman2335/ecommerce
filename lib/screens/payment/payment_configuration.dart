import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:ecommerce/screens/payment/payment_web_view.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class PaymentConfiguration extends ChangeNotifier {
  static String api_key =
      "ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmpiR0Z6Y3lJNklrMWxjbU5vWVc1MElpd2ljSEp2Wm1sc1pWOXdheUk2TVRBek1qRXpNQ3dpYm1GdFpTSTZJakUzTkRJeU56WXhPVFF1T0RBME16WTNJbjAuUjg2bG5GMDN5WDRzbnc1dXBSLWJRc3BKOThnLW9UWWJPQThJTmtLU21QZWJsTHVHMjcyczk4NV81eHlQT09OaVplNGNYUzV1SkI0R2ZkMDFJZ2R6eEE=";
  Dio dio = Dio();
  bool isLoading = false;

  void makePayment(int amount) async {
    isLoading = true;
    notifyListeners();
    try {
      final paymentToken = await getToken();
      log("paymentToken: $paymentToken");

      /// Client error responses (400 – 499)
      /// Server error responses (500 – 599)
      if (paymentToken == null) return;
      final String? urlPayment = await paymentLink(paymentToken, 100 * amount);
      log("urlPayment: $urlPayment");
      if (urlPayment == null) return;
      navigatorKey.currentState!.push(MaterialPageRoute(
          builder: (context) => PaymentWebView(url: urlPayment)));
    } catch (error) {
      log("Error when making the payment: $error");
    } finally {
      isLoading = false;
    }
    notifyListeners();
  }

  Future getToken() async {
    /// Getting the token by sending your api key or you can use your username and password related Documentation https://developers.paymob.com/egypt/payment-links/payment-link-api/login
    try {
      final response =
          await dio.post("https://accept.paymob.com/api/auth/tokens", data: {
        "api_key": api_key,
      });
      return response.data["token"];
    } catch (error) {
      log("Error when getting the token: $error");
    }
  }

  Future paymentLink(String token, int amount) async {
    return await dio
        .post(
      "https://accept.paymob.com/api/ecommerce/payment-links",
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
      }
      return null;
    });
  }
}
