part of 'payment_bloc.dart';

enum PaymentStatus { initial, loading, success, failure }

enum PaymentMethod {
  cashOnDelivery('Cash on delivery'),
  payByCard('Pay by card');

  final String displayName;

  const PaymentMethod(this.displayName);

  String getName() => displayName;
}

final class PaymentState extends Equatable {
  const PaymentState({
    this.status = PaymentStatus.initial,
    this.paymentMethod = PaymentMethod.cashOnDelivery,
    this.paymentUrl,
    this.errorMessage,
  });

  final PaymentStatus status;
  final PaymentMethod paymentMethod;
  final String? paymentUrl;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, paymentMethod, paymentUrl, errorMessage];

  PaymentState copyWith({
    PaymentStatus? status,
    PaymentMethod? paymentMethod,
    String? paymentUrl,
    String? errorMessage,
  }) {
    return PaymentState(
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentUrl: paymentUrl ?? this.paymentUrl,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
