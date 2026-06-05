part of 'checkout_bloc.dart';

enum CheckoutStatus {
  initial,
  loading,
  success,
  failure,
  promoValidating,
  orderProcessing,
  orderSuccess
}

final class CheckoutState extends Equatable {
  final CheckoutStatus status;
  final String? errorMessage;
  final CheckoutModel? checkoutSummary;
  final PromoCodeModel? appliedPromoCode;
  final OrderModel? confirmedOrder;
  final bool isCheckoutValid;
  final String? promoValue;
  final AddressModel? shippingAddress;

  const CheckoutState({
    this.status = CheckoutStatus.initial,
    this.errorMessage,
    this.checkoutSummary,
    this.appliedPromoCode,
    this.confirmedOrder,
    this.isCheckoutValid = false,
    this.promoValue,
    this.shippingAddress,
  });

  CheckoutState copyWith({
    CheckoutStatus? status,
    String? errorMessage,
    CheckoutModel? checkoutSummary,
    PromoCodeModel? appliedPromoCode,
    OrderModel? confirmedOrder,
    bool? isCheckoutValid,
    String? promoValue,
    AddressModel? shippingAddress,
  }) {
    return CheckoutState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      checkoutSummary: checkoutSummary ?? this.checkoutSummary,
      appliedPromoCode: appliedPromoCode ?? this.appliedPromoCode,
      confirmedOrder: confirmedOrder ?? this.confirmedOrder,
      isCheckoutValid: isCheckoutValid ?? this.isCheckoutValid,
      promoValue: promoValue ?? this.promoValue,
      shippingAddress: shippingAddress ?? this.shippingAddress,
    );
  }

  CheckoutState clearAppliedPromoCode() => CheckoutState(
        status: CheckoutStatus.success,
        promoValue: promoValue,
        checkoutSummary: checkoutSummary,
        shippingAddress: shippingAddress,
        isCheckoutValid: isCheckoutValid,
        confirmedOrder: confirmedOrder,
        errorMessage: null,
        appliedPromoCode: null,
      );

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        checkoutSummary,
        appliedPromoCode,
        confirmedOrder,
        isCheckoutValid,
        promoValue,
        shippingAddress,
      ];
}
