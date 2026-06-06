import 'dart:developer';

import 'package:ecommerce/core/error/dio_failure.dart';
import 'package:ecommerce/core/router/navigation_keys.dart';
import 'package:ecommerce/core/services/firebase_service.dart';
import 'package:ecommerce/features/order_management/data/model/order_model.dart';
import 'package:flutter/material.dart';

import '../../data/repository/payment_repository.dart';

enum PaymentMethod {
  cashOnDelivery('Cash on delivery'),
  payByCard('Pay by card');

  final String displayName;

  const PaymentMethod(this.displayName);

  String getName() => displayName;
}

class PaymentProvider extends ChangeNotifier {
  PaymentProvider(this._paymentRepository);

  final PaymentRepository _paymentRepository;
  final FirebaseService _firebaseService = FirebaseService();

  String? paymentUrl;
  bool isLoading = false;
  String? errorMessage;
  bool _paymentInProgress = false;

  PaymentMethod _selectedPaymentMethod = PaymentMethod.cashOnDelivery;

  PaymentMethod get getPaymentMethod => _selectedPaymentMethod;

  bool get paymentInProgress => _paymentInProgress;

  void selectPayment({required PaymentMethod selectedPayment}) {
    _selectedPaymentMethod = selectedPayment;
    notifyListeners();
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }

  Future<bool> makePayment({required OrderModel order}) async {
    if (_paymentInProgress) {
      return false;
    }

    isLoading = true;
    _paymentInProgress = true;
    errorMessage = null;
    notifyListeners();

    try {
      final urlPayment = await _paymentRepository.createPaymentLink(
        amount: order.totalPrice,
        email: _firebaseService.auth.currentUser?.email,
        phoneNumber: null,
      );

      log('urlPayment: $urlPayment');
      // paymentUrl = urlPayment;

      final context = navigatorKey.currentContext;
      if (context == null || !context.mounted) {
        throw ServerFailure('Unable to open the payment screen.');
      }

      // await context.push(
      //   AppRouter.kPaymentScreen,
      //   extra: PaymentSession(url: urlPayment, order: order),
      // );
      return true;
    } on ServerFailure catch (error) {
      errorMessage = error.errorMessage;
      log('Payment failure: ${error.errorMessage}');
      return false;
    } catch (error) {
      errorMessage = 'Something went wrong while starting payment.';
      log('Error when making the payment: $error');
      return false;
    } finally {
      isLoading = false;
      _paymentInProgress = false;
      notifyListeners();
    }
  }
}
