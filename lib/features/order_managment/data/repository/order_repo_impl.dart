import 'dart:developer';

import 'package:ecommerce/core/services/firebase_service.dart';
import 'package:ecommerce/data/models/order_product_model.dart';
import 'package:ecommerce/features/order_managment/data/repository/order_repo.dart';

import '../../../../data/models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Future<void> placeOrder(OrderModel order) async {
    try {
      if (_firebaseService.auth.currentUser == null) return;
      await _firebaseService.firestore
          .collection("customers")
          .doc(_firebaseService.auth.currentUser!.uid)
          .collection("orders")
          .doc(order.id)
          .set(order.toJson());
    } catch (error) {
      log("error in the placeOrder impl: $error");
    }
  }

  @override
  Future<void> cancelOrder(OrderModel order) async {
    try {
      final data = await _firebaseService.firestore
          .collection("customers")
          .doc(_firebaseService.auth.currentUser!.uid)
          .collection("orders")
          .doc(order.id)
          .get();

      if (data.exists) {
        OrderProductModel item = data.data()!["cartItems"] as OrderProductModel;
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
