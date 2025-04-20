import 'dart:developer';

import 'package:ecommerce/core/services/firebase_service.dart';
import 'package:ecommerce/data/models/cart_model.dart';

import '../../domain/repositories/order_repository.dart';
import '../models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Future<void> placeOrder(OrderModel order) async {
    try {
      if (order.cartItems.itemId.isEmpty) return;
      await _firebaseService.firestore
          .collection("orders")
          .doc(order.cartItems.userId)
          .set(order.toJson());
    } catch (error) {
      log("error in the placeOrder: $error");
    }
  }

  @override
  Future<void> cancelOrder(OrderModel order) async {
    try {
      final data = await _firebaseService.firestore
          .collection("orders")
          .doc(order.cartItems.userId)
          .get();

      if (data.exists) {
        CartModel item = data.data()!["cartItems"] as CartModel;
        item.status = OrderStatus.cancelled;
      }
    } catch (error) {
      log("error in the cancelOrder: $error");
    }
  }

  @override
  Future<OrderModel?> getOrder(String orderId, String userId) async {
    final docSnapshot =
        await _firebaseService.firestore.collection("orders").doc(userId).get();

    if (docSnapshot.exists && docSnapshot.data() != null) {
      final data = docSnapshot.data() as Map<String, dynamic>;
      data["orderId"] = orderId;
      return OrderModel.fromJson(data);
    }

    return null;
  }
}
