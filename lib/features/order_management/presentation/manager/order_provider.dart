import 'dart:developer';

import 'package:ecommerce/features/order_management/data/repository/order_repo.dart';
import 'package:flutter/material.dart';

import '../../data/model/order_model.dart';

class OrderProvider extends ChangeNotifier {
  final OrderRepository _orderRepository;

  OrderProvider(this._orderRepository);

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void placeOrder({required OrderModel order}) async {
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
