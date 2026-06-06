import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:ecommerce/core/models/address_model.dart';
import 'package:ecommerce/features/address/data/repo/AddressRepo.dart';
import 'package:ecommerce/features/cart/data/model/cart_model.dart';
import 'package:ecommerce/features/cart/presentation/manager/cart_bloc.dart';
import 'package:ecommerce/features/checkout/data/models/checkout_summary.dart';
import 'package:ecommerce/features/checkout/data/models/promo_code_model.dart';
import 'package:ecommerce/features/checkout/data/repository/checkout_repository.dart';
import 'package:ecommerce/features/order_management/data/model/order_model.dart';
import 'package:ecommerce/features/payment/presentation/manager/payment_provider.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

@injectable
class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CheckoutRepository _checkoutRepository;
  final AddressRepo _addressRepo;
  final CartBloc _cartBloc;
  late final StreamSubscription _cartSubscription;

  CheckoutBloc(this._checkoutRepository, this._addressRepo, this._cartBloc)
      : super(const CheckoutState()) {
    on<CheckoutInitialized>(_onInitialized);
    on<CheckoutPromoCodeApplied>(_onPromoCodeApplied);
    on<CheckoutPromoCodeRemoved>(_onPromoCodeRemoved);
    on<CheckoutUpdated>(_onUpdated);
    on<CheckoutOrderConfirmed>(_onOrderConfirmed);
    on<CheckoutOrderPaymentStarted>(_onOrderPaymentStarted);
    on<CheckoutValidated>(_onValidated);
    on<CheckoutPromoCodeUpdated>(_onPromoCodeUpdated);

    // Initial calculation
    add(const CheckoutInitialized());

    // Listen to cart changes to update summary automatically
    _cartSubscription = _cartBloc.stream.listen((cartState) {
      add(CheckoutUpdated(cartState.items));
    });
  }

  @override
  Future<void> close() {
    _cartSubscription.cancel();
    return super.close();
  }

  void _onInitialized(
    CheckoutInitialized event,
    Emitter<CheckoutState> emit,
  ) async {
    try {
      emit(state.copyWith(status: CheckoutStatus.loading, errorMessage: null));

      // Load saved address from Firebase
      final addressResult = await _addressRepo.getUserAddress();
      AddressModel? savedAddress;
      addressResult.fold((_) => null, (address) => savedAddress = address);

      _calculateSummary(_cartBloc.state.items, emit);

      emit(state.copyWith(
        shippingAddress: savedAddress,
      ));
    } catch (e) {
      log("Error initializing checkout: $e");
      emit(state.copyWith(
        status: CheckoutStatus.failure,
        errorMessage: "Failed to initialize checkout: $e",
      ));
    }
  }

  void _onPromoCodeApplied(
    CheckoutPromoCodeApplied event,
    Emitter<CheckoutState> emit,
  ) async {
    try {
      emit(state.copyWith(
          status: CheckoutStatus.promoValidating, errorMessage: null));

      final promoResult =
          await _checkoutRepository.validatePromoCode(event.promoCode);

      if (promoResult.isValid) {
        emit(state.copyWith(
          appliedPromoCode: promoResult,
          errorMessage: null,
          status: CheckoutStatus.success,
        ));
      } else {
        emit(state.copyWith(
          appliedPromoCode: null,
          errorMessage: "Invalid voucher",
          status: CheckoutStatus.success,
        ));
      }

      _calculateSummary(event.cartItems, emit);
    } catch (e) {
      log("Error applying promo code: $e");
      emit(state.copyWith(
        status: CheckoutStatus.failure,
        errorMessage: "Failed to apply promo code",
        appliedPromoCode: null,
      ));
    }
  }

  void _onPromoCodeUpdated(
    CheckoutPromoCodeUpdated event,
    Emitter<CheckoutState> emit,
  ) {
    emit(state.copyWith(promoValue: event.promoValue, errorMessage: ''));
  }

  void _onPromoCodeRemoved(
    CheckoutPromoCodeRemoved event,
    Emitter<CheckoutState> emit,
  ) {
    emit(state.clearAppliedPromoCode());
    _calculateSummary(event.cartItems, emit);
  }

  void _onUpdated(
    CheckoutUpdated event,
    Emitter<CheckoutState> emit,
  ) {
    try {
      _calculateSummary(event.cartItems, emit);
    } catch (e) {
      log("Error updating checkout: $e");
      emit(state.copyWith(
        status: CheckoutStatus.failure,
        errorMessage: "Failed to update checkout",
      ));
    }
  }

  void _onOrderConfirmed(
    CheckoutOrderConfirmed event,
    Emitter<CheckoutState> emit,
  ) async {
    try {
      emit(state.copyWith(
          status: CheckoutStatus.orderProcessing, errorMessage: null));

      // Validate checkout first
      final isValid = await _checkoutRepository.validateCheckoutData(
        cartItems: event.cartItems,
        shippingAddress: event.shippingAddress,
      );

      if (!isValid) {
        emit(state.copyWith(
          status: CheckoutStatus.failure,
          errorMessage: "Please check your order details and try again",
          isCheckoutValid: false,
        ));
        return;
      }

      final itemsPrice = state.checkoutSummary?.itemsPrice ??
          _checkoutRepository.calculateItemsPrice(event.cartItems).itemsPrice;

      final totalPrice = state.checkoutSummary?.totalPrice ?? itemsPrice + 10;
      final deliveryFee = state.checkoutSummary?.shippingFee ?? 10;
      final discount = state.checkoutSummary?.discount ?? 0;

      final order = OrderModel(
        totalPrice: totalPrice,
        deliveryFee: deliveryFee,
        discount: discount,
        paymentMethod: event.paymentMethod,
        products: event.cartItems,
        createdAt: DateTime.now(),
        shippingAddress: event.shippingAddress,
      );

      log("Order created successfully for ${event.paymentMethod.displayName}");
      emit(state.copyWith(
        status: CheckoutStatus.orderSuccess,
        confirmedOrder: order,
        isCheckoutValid: true,
      ));
    } catch (e) {
      log("Error confirming order: $e");
      emit(state.copyWith(
        status: CheckoutStatus.failure,
        errorMessage: "Failed to process order. Please try again.",
      ));
    }
  }

  void _onOrderPaymentStarted(
    CheckoutOrderPaymentStarted event,
    Emitter<CheckoutState> emit,
  ) {
    emit(state.copyWith(
      status: CheckoutStatus.success,
      confirmedOrder: null,
      errorMessage: null,
    ));
  }

  void _onValidated(
    CheckoutValidated event,
    Emitter<CheckoutState> emit,
  ) async {
    try {
      emit(state.copyWith(status: CheckoutStatus.loading, errorMessage: null));

      final isValid = await _checkoutRepository.validateCheckoutData(
        cartItems: event.cartItems,
        shippingAddress: event.shippingAddress,
      );

      if (!isValid) {
        emit(state.copyWith(
          status: CheckoutStatus.failure,
          errorMessage: "Please check your order details and try again",
          isCheckoutValid: false,
        ));
      } else {
        emit(state.copyWith(
          status: CheckoutStatus.success,
          isCheckoutValid: true,
        ));
      }
    } catch (e) {
      log("Error validating checkout: $e");
      emit(state.copyWith(
        status: CheckoutStatus.failure,
        errorMessage: "Validation failed. Please try again.",
        isCheckoutValid: false,
      ));
    }
  }

  void _calculateSummary(
      List<CartModel> cartItems, Emitter<CheckoutState> emit) {
    try {
      final shippingFee =
          _checkoutRepository.calculateShippingFee(cartItems, null);
      final discount = state.appliedPromoCode?.discountAmount ?? 0;

      final summary = _checkoutRepository.calculateCheckoutSummary(
        cartItems: cartItems,
        shippingFee: shippingFee,
        discount: discount,
      );

      emit(state.copyWith(
          checkoutSummary: summary, status: CheckoutStatus.success));
    } catch (e) {
      log("Error calculating checkout summary: $e");
      emit(state.copyWith(errorMessage: "Failed to calculate totals"));
    }
  }
}
