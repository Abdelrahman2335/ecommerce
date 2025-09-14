import 'dart:developer';

import 'package:flutter/material.dart';

import '../../domain/repositories/payment_repository.dart';
import '../../main.dart';
import '../screens/payment/payment_web_view.dart';

class PaymentViewModel extends ChangeNotifier {
  final PaymentRepository _paymentRepository;

  PaymentViewModel(this._paymentRepository);

  String? paymentUrl;
  bool isLoading = false;

  void makePayment(num amount) async {
    isLoading = true;
    notifyListeners();

    try {
      final paymentToken = await _paymentRepository.getPaymentToken();
      log("paymentToken: $paymentToken");

      if (paymentToken == null) return;

      Future<String?> paymentLink =
          _paymentRepository.createPaymentLink(paymentToken, 100 * amount);

      final String? urlPayment = await paymentLink;

      log("urlPayment: $urlPayment");

      if (urlPayment == null) return;

      navigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (ctx) => PaymentWebView(url: urlPayment),
        ),
      );
    } catch (error) {
      log("Error when making the payment: $error");
    } finally {
      isLoading = true;
    }
    notifyListeners();
  }
}
