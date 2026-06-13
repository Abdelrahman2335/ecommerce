import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:ecommerce/core/router/app_router.dart';
import 'package:ecommerce/core/router/navigation_keys.dart';
import 'package:ecommerce/core/services/firebase_service.dart';
import 'package:ecommerce/features/order_management/data/model/order_model.dart';
import 'package:ecommerce/features/payment/data/models/payment_session.dart';
import 'package:ecommerce/features/payment/data/repository/payment_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

part 'payment_event.dart';
part 'payment_state.dart';

@injectable
class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc(this._paymentRepository, this._firebaseService)
      : super(const PaymentState()) {
    on<UpdatePaymentMethodEvent>(_onPaymentUpdate);
    on<InitiatePaymentEvent>(_initPayment);
  }

  final PaymentRepository _paymentRepository;
  final FirebaseService _firebaseService;

  void _onPaymentUpdate(
      UpdatePaymentMethodEvent event, Emitter<PaymentState> emit) {
    {
      emit(state.copyWith(paymentMethod: event.paymentMethod));
    }
  }

  void _initPayment(
      InitiatePaymentEvent event, Emitter<PaymentState> emit) async {
    emit(state.copyWith(status: PaymentStatus.loading));
    final response = await _paymentRepository.createPaymentLink(
      amount: event.order.totalPrice,
      email: _firebaseService.auth.currentUser?.email,
      phoneNumber: null,
    );
    response.fold(
      (error) {
        log('Failed to create payment link: $error');
        emit(state.copyWith(
            status: PaymentStatus.failure, errorMessage: error.toString()));
      },
      (urlPayment) async {
        final context = navigatorKey.currentContext;
        if (context == null || !context.mounted) {
          log('Context is null or not mounted. Cannot navigate to payment screen.');
          emit(state.copyWith(
              status: PaymentStatus.failure,
              errorMessage: 'Unable to navigate to payment screen.'));
          return;
        }

        await context.push(
          AppRouter.kPaymentScreen,
          extra: PaymentSession(url: urlPayment, order: event.order),
        );
        emit(state.copyWith(status: PaymentStatus.initial));
      },
    );
  }
}
