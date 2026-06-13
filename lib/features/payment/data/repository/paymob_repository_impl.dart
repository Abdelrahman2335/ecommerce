import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ecommerce/core/error/dio_failure.dart';
import 'package:ecommerce/core/error/failure.dart';
import 'package:ecommerce/core/network/api_service.dart';
import 'package:ecommerce/core/services/firebase_service.dart';
import 'package:injectable/injectable.dart';

import 'payment_repository.dart';

@LazySingleton(as: PaymentRepository)
class PaymentRepositoryImpl implements PaymentRepository {
  PaymentRepositoryImpl(this._apiService, FirebaseService firebaseService)
      : _apiKey = firebaseService.remoteConfig.getString('paymob_api_key'),
        _integrationId =
            firebaseService.remoteConfig.getInt('paymob_integration_id'),
        _isLive = firebaseService.remoteConfig.getBool('paymob_is_live');

  final ApiService _apiService;

  final String _apiKey;
  final int _integrationId;
  final bool _isLive;

  Future<Either<Failure, String>> _getPaymentToken() async {
    try {
      final response = await _apiService.post(
        baseUrl: _apiService.paymentAuth,
        endPoint: 'tokens',
        data: {
          'api_key': _apiKey,
        },
      );
      final token = response.data['token'];
      if (token is! String || token.isEmpty) {
        return Left(ServerFailure('Paymob did not return a valid auth token.'));
      }
      return Right(token);
    } on DioException catch (error) {
      log('Error when getting the token: ${error.response?.data ?? error.message}');
      return Left(ServerFailure.fromDioException(error));
    } catch (error) {
      log('Error when getting the token: $error');

      return Left(ServerFailure("Unexpected error"));
    }
  }

  @override
  Future<Either<Failure, String>> createPaymentLink({
    required num amount,
    String? email,
    String? phoneNumber,
  }) async {
    try {
      final tokenResult = await _getPaymentToken();
      final Either<Failure, String>? earlyExit = tokenResult.fold(
        (failure) => Left(failure),
        (_) => null,
      );
      if (earlyExit != null) return earlyExit;
      final token = tokenResult.getOrElse(() => '');

      final response = await _apiService.post(
        baseUrl: _apiService.paymentBaseUrl,
        endPoint: '/payment-links',
        data: {
          'is_live': _isLive,
          'amount_cents': (amount * 100).round(),
          'expiration': 3600,
          'payment_methods': [_integrationId],
          'currency': 'EGP',
          'customer': {
            'email': email ?? 'user@example.com',
            'phone_number': phoneNumber ?? '201234567890',
          },
        },
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      );

      log('Payment link response: ${response.data}');
      final clientUrl = response.data['client_url'];
      if (clientUrl is! String || clientUrl.isEmpty) {
        log('Invalid client_url in response: ${response.data}');
        return Left(ServerFailure('Unexpected response from payment service.'));
      }
      return Right(clientUrl);
    } on DioException catch (error) {
      log('Error in the payment link: ${error.response?.data ?? error.message}');
      return Left(ServerFailure.fromDioException(error));
    } catch (error) {
      log('Unexpected payment link error: $error');
      return Left(ServerFailure("Unexpected error"));
    }
  }
}
