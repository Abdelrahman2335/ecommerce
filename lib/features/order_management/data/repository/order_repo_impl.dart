import 'dart:developer';

import 'package:ecommerce/core/services/firebase_service.dart';
import 'package:ecommerce/features/order_management/data/repository/order_repo.dart';
import 'package:injectable/injectable.dart';

import '../model/order_model.dart';

@LazySingleton(as: OrderRepository)
class OrderRepositoryImpl implements OrderRepository {
  final FirebaseService _firebaseService;

  OrderRepositoryImpl(this._firebaseService);

  @override
  Future<void> placeOrder(OrderModel order) async {
    try {
      if (_firebaseService.auth.currentUser == null) {
        throw Exception('User must be logged in to place an order');
      }
      final uid = _firebaseService.auth.currentUser!.uid;
      log("Placing order ${order.id} for user $uid");

      await _firebaseService.firestore
          .collection("customers")
          .doc(uid)
          .collection("orders")
          .doc(order.id)
          .set(order.toJson());
      log("Order ${order.id} successfully placed in Firestore");
    } catch (error) {
      log("error in the placeOrder impl: $error");
      rethrow;
    }
  }

  @override
  Future<void> cancelOrder(OrderModel order) async {
    try {
      final uid = _firebaseService.auth.currentUser!.uid;
      await _firebaseService.firestore
          .collection("customers")
          .doc(uid)
          .collection("orders")
          .doc(order.id)
          .update({'orderStatus': OrderStatus.cancelled.displayName});
      log("Order ${order.id} cancelled successfully");
    } catch (error) {
      log("error in the cancelOrder: $error");
      rethrow;
    }
  }

  @override
  Future<OrderModel?> getOrder(String orderId, String userId) async {
    try {
      final docSnapshot = await _firebaseService.firestore
          .collection("customers")
          .doc(userId)
          .collection("orders")
          .doc(orderId)
          .get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        return OrderModel.fromJson(docSnapshot.data()!);
      }
    } catch (error) {
      log("Error getting order: $error");
    }
    return null;
  }
}
