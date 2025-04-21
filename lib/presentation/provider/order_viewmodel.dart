import 'dart:developer';

import 'package:ecommerce/domain/repositories/order_repository.dart';
import 'package:flutter/material.dart';

import '../../data/models/order_model.dart';

class OrderViewModel extends ChangeNotifier {
  final OrderRepository _orderRepository;

  OrderViewModel(this._orderRepository);

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  placeOrder({required OrderModel order}) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _orderRepository.placeOrder(order);

      log("order placed!");
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      log("error in the placeOrder: $error");
      rethrow;
    }
  }

  cancelOrder(OrderModel order) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _orderRepository.cancelOrder(order);
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      log("error in the cancelOrder: $error");
      rethrow;
    }
  }
}
