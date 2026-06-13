part of 'payment_bloc.dart';

sealed class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class UpdatePaymentMethodEvent extends PaymentEvent {
  final PaymentMethod paymentMethod;

  const UpdatePaymentMethodEvent({
    required this.paymentMethod,
  });

  @override
  List<Object?> get props => [paymentMethod];
}

class InitiatePaymentEvent extends PaymentEvent {
  final OrderModel order;

  const InitiatePaymentEvent({
    required this.order,
  });

  @override
  List<Object?> get props => [order];
}
