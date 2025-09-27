import 'dart:developer';

import 'package:flutter/material.dart';

import '../../data/repository/payment_repository.dart';
import '../../../../main.dart';
import '../view/screens/payment_web_view.dart';

enum PaymentMethod {
  cashOnDelivery("Cash on delivery"),
  payByCard("Pay by Card");

  final String displayName;

  const PaymentMethod(this.displayName);
  String getName() => displayName;
}

class PaymentProvider extends ChangeNotifier {
  final PaymentRepository _paymentRepository;

  PaymentProvider(this._paymentRepository);

  String? paymentUrl;
  bool isLoading = false;

  PaymentMethod _selectedPaymentMethod = PaymentMethod.cashOnDelivery;

  PaymentMethod get getPaymentMethod => _selectedPaymentMethod;

  void selectPayment({required PaymentMethod selectedPayment}) {
    _selectedPaymentMethod = selectedPayment;
    notifyListeners();
  }

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
