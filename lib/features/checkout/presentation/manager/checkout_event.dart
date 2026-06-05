part of 'checkout_bloc.dart';

@immutable
abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object?> get props => [];
}

class CheckoutInitialized extends CheckoutEvent {
  const CheckoutInitialized();
}

class CheckoutPromoCodeApplied extends CheckoutEvent {
  final String promoCode;
  final List<CartModel> cartItems;

  const CheckoutPromoCodeApplied({
    required this.promoCode,
    required this.cartItems,
  });

  @override
  List<Object?> get props => [promoCode, cartItems];
}

class CheckoutPromoCodeUpdated extends CheckoutEvent {
  final String? promoValue;

  const CheckoutPromoCodeUpdated(this.promoValue);

  @override
  List<Object?> get props => [promoValue];
}

class CheckoutPromoCodeRemoved extends CheckoutEvent {
  final List<CartModel> cartItems;

  const CheckoutPromoCodeRemoved(this.cartItems);

  @override
  List<Object?> get props => [cartItems];
}

class CheckoutUpdated extends CheckoutEvent {
  final List<CartModel> cartItems;

  const CheckoutUpdated(this.cartItems);

  @override
  List<Object?> get props => [cartItems];
}

class CheckoutOrderConfirmed extends CheckoutEvent {
  final List<CartModel> cartItems;
  final AddressModel shippingAddress;
  final PaymentMethod paymentMethod;

  const CheckoutOrderConfirmed({
    required this.cartItems,
    required this.shippingAddress,
    required this.paymentMethod,
  });

  @override
  List<Object?> get props => [cartItems, shippingAddress, paymentMethod];
}

class CheckoutValidated extends CheckoutEvent {
  final List<CartModel> cartItems;
  final AddressModel shippingAddress;

  const CheckoutValidated({
    required this.cartItems,
    required this.shippingAddress,
  });

  @override
  List<Object?> get props => [cartItems, shippingAddress];
}
