import 'dart:developer';

import 'package:ecommerce/core/router/app_router.dart';
import 'package:ecommerce/core/router/navigation_keys.dart';
import 'package:ecommerce/features/cart/presentation/manager/cart_bloc.dart';
import 'package:ecommerce/features/cart/presentation/manager/cart_event.dart';
import 'package:ecommerce/features/order_management/data/model/order_model.dart';
import 'package:ecommerce/features/order_management/presentation/manager/order_provider.dart';
import 'package:ecommerce/features/payment/data/models/payment_session.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PaymentWebView extends StatefulWidget {
  const PaymentWebView({
    super.key,
    required this.session,
  });

  final PaymentSession session;

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  InAppWebViewController? _webViewController;
  bool _isLoading = true;
  bool _isCompletingPayment = false;
  String? _pageError;

  String get _successMarker =>
      FirebaseRemoteConfig.instance.getString('paymob_success_url');

  String get _failureMarker =>
      FirebaseRemoteConfig.instance.getString('paymob_failure_url');

  bool _matchesPaymentOutcome(String url, String marker) {
    if (marker.trim().isEmpty) {
      return false;
    }
    return url.toLowerCase().contains(marker.toLowerCase());
  }

  Future<void> _handlePaymentSuccess() async {
    if (_isCompletingPayment || !mounted) {
      return;
    }

    _isCompletingPayment = true;
    setState(() {});

    try {
      await context.read<OrderProvider>().placeOrder(order: widget.session.order);
      await _clearOrderedItems(widget.session.order);
      if (!mounted) {
        return;
      }

      scaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(content: Text('Payment successful. Your order was placed.')),
      );
      context.go(AppRouter.kLayoutScreen);
    } catch (error) {
      log('Error completing payment order: $error');
      if (!mounted) {
        return;
      }
      setState(() {
        _isCompletingPayment = false;
        _pageError = 'Payment succeeded but the order could not be saved.';
      });
    }
  }

  Future<void> _clearOrderedItems(OrderModel order) async {
    final cartBloc = context.read<CartBloc>();
    for (final item in order.products) {
      cartBloc.add(CartItemRemoved(item.product, deleteItem: true));
    }
  }

  void _handlePaymentFailure() {
    if (!mounted || _isCompletingPayment) {
      return;
    }

    scaffoldMessengerKey.currentState?.showSnackBar(
      const SnackBar(content: Text('Payment failed. Please try again.')),
    );
    context.pop(false);
  }

  void _handleRedirectUrl(String? url) {
    if (url == null || _isCompletingPayment) {
      return;
    }

    if (_matchesPaymentOutcome(url, _successMarker)) {
      _handlePaymentSuccess();
    } else if (_matchesPaymentOutcome(url, _failureMarker)) {
      _handlePaymentFailure();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isCompletingPayment,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Payment',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: _isCompletingPayment
              ? null
              : IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => context.pop(false),
                ),
        ),
        body: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(widget.session.url)),
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },
              onLoadStart: (_, __) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  _isLoading = true;
                  _pageError = null;
                });
              },
              onLoadStop: (controller, url) {
                if (!mounted) {
                  return;
                }
                setState(() => _isLoading = false);
                log('Final loaded URL: $url');
                _handleRedirectUrl(url?.toString());
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                _handleRedirectUrl(navigationAction.request.url?.toString());
                return NavigationActionPolicy.ALLOW;
              },
              onReceivedError: (controller, request, error) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  _isLoading = false;
                  _pageError = 'Unable to load the payment page.';
                });
              },
            ),
            if (_isLoading || _isCompletingPayment)
              const ColoredBox(
                color: Color.fromARGB(120, 255, 255, 255),
                child: Center(child: CircularProgressIndicator()),
              ),
            if (_pageError != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _pageError!,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _pageError = null;
                            _isLoading = true;
                          });
                          _webViewController?.reload();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
