import '../../data/models/order_model.dart';

abstract class OrderRepository {

  Future<void> placeOrder(OrderModel order);
  Future<void> cancelOrder(OrderModel order);
  Future<OrderModel?> getOrder(String orderId, String userId);
}