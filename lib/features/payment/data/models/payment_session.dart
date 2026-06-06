import 'package:ecommerce/features/order_management/data/model/order_model.dart';

class PaymentSession {
  const PaymentSession({
    required this.url,
    required this.order,
  });

  final String url;
  final OrderModel order;
}
