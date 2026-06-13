import 'dart:convert';
import 'dart:developer';

import 'package:ecommerce/core/router/app_router.dart';
import 'package:ecommerce/core/router/navigation_keys.dart';
import 'package:ecommerce/features/cart/presentation/manager/cart_bloc.dart';
import 'package:ecommerce/features/cart/presentation/manager/cart_event.dart';
import 'package:ecommerce/features/order_management/data/model/order_model.dart';
import 'package:ecommerce/features/order_management/data/repository/order_repo.dart';
import 'package:ecommerce/features/payment/data/models/payment_session.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

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

  // Repo via get_it — no BuildContext needed in async methods
  final _orderRepo = GetIt.instance<OrderRepository>();

  // Single handler name used in both Dart and the injected JS string
  static const _jsHandlerName = 'paymentPageInfo';

  String get _successMarker =>
      FirebaseRemoteConfig.instance.getString('paymob_success_url');

  String get _failureMarker =>
      FirebaseRemoteConfig.instance.getString('paymob_failure_url');

  // --- URL-based matching (Layer 1) -------------------------------------------

  bool _matchesSuccessUrl(String url) {
    final lowerUrl = url.toLowerCase();
    final marker = _successMarker;

    if (marker.trim().isNotEmpty && lowerUrl.contains(marker.toLowerCase())) {
      return true;
    }
    // Paymob uses txn_response_code=APPROVED (not 0) — keep both for safety
    return lowerUrl.contains('success=true') ||
        lowerUrl.contains('txn_response_code=approved') ||
        lowerUrl.contains('txn_response_code=0') ||
        lowerUrl.contains('status=success');
  }

  bool _isFailureUrl(String url) {
    final lowerUrl = url.toLowerCase();
    final marker = _failureMarker;

    if (marker.trim().isNotEmpty && lowerUrl.contains(marker.toLowerCase())) {
      return true;
    }
    return lowerUrl.contains('success=false') ||
        (lowerUrl.contains('txn_response_code=') &&
            !lowerUrl.contains('txn_response_code=approved') &&
            !lowerUrl.contains('txn_response_code=0'));
  }

  // --- JS message handler setup (Layer 2) --------------------------------------

  /// Registers the Flutter-side handler that receives messages from injected JS.
  /// Must be called in onWebViewCreated — before any page loads.
  void _setupJavaScriptHandler(InAppWebViewController controller) {
    controller.addJavaScriptHandler(
      handlerName: _jsHandlerName,
      callback: (args) {
        if (args.isEmpty || _isCompletingPayment) return;

        try {
          final info = jsonDecode(args[0].toString()) as Map<String, dynamic>;
          final url = (info['url'] as String?) ?? '';
          final isSuccess = (info['isSuccess'] as bool?) ?? false;
          final isFailure = (info['isFailure'] as bool?) ?? false;

          log('JS scan — url: $url | success: $isSuccess | failure: $isFailure',
              name: 'PaymentWebView');

          // JS content check takes priority; URL pattern is a secondary fallback
          if (isSuccess || _matchesSuccessUrl(url)) {
            _handlePaymentSuccess();
          } else if (isFailure || _isFailureUrl(url)) {
            _handlePaymentFailure();
          }
        } catch (e) {
          log('JS handler parse error: $e', name: 'PaymentWebView');
        }
      },
    );
  }

  /// Injected after every onLoadStop.
  /// Reads the real JS URL + scans visible body text for success/failure phrases.
  /// This catches Paymob's hosted success page even when no redirect happens.
  void _injectPaymentDetector(InAppWebViewController controller) {
    controller.evaluateJavascript(source: '''
      (function() {
        try {
          var url   = window.location.href;
          var body  = document.body ? document.body.innerText.toLowerCase() : '';
          var title = document.title.toLowerCase();

          var isSuccess =
            body.includes('thanks for your payment') ||
            body.includes('payment successful')       ||
            body.includes('transaction approved')     ||
            title.includes('payment success')         ||
            url.toLowerCase().includes('success=true');

          var isFailure =
            body.includes('payment failed')       ||
            body.includes('payment declined')     ||
            body.includes('transaction failed')   ||
            body.includes('transaction declined') ||
            title.includes('payment failed')      ||
            url.toLowerCase().includes('success=false');

          window.flutter_inappwebview.callHandler('$_jsHandlerName', JSON.stringify({
            url: url,
            isSuccess: isSuccess,
            isFailure: isFailure
          }));
        } catch(e) { /* silently skip cross-origin frames */ }
      })();
    ''');
  }

  // --- Payment outcome handlers ------------------------------------------------

  Future<void> _handlePaymentSuccess() async {
    if (_isCompletingPayment || !mounted) return;

    log('Payment success — placing order...', name: 'PaymentWebView');
    _isCompletingPayment = true;
    setState(() {});

    // Cache context-dependent objects BEFORE any await
    final cartBloc = context.read<CartBloc>();
    final messenger = scaffoldMessengerKey.currentState;
    final router = GoRouter.of(context);

    try {
      final confirmedOrder = widget.session.order.copyWith(
        orderStatus: OrderStatus.confirmed,
      );

      log('Placing order: ${confirmedOrder.id}', name: 'PaymentWebView');
      await _orderRepo.placeOrder(confirmedOrder);

      log('Order placed — clearing cart...', name: 'PaymentWebView');
      for (final item in confirmedOrder.products) {
        cartBloc.add(CartItemRemoved(item.product, deleteItem: true));
      }

      messenger?.showSnackBar(
        const SnackBar(
            content: Text('Payment successful. Your order was placed.')),
      );

      log('Navigating to layout screen', name: 'PaymentWebView');
      router.go(AppRouter.kLayoutScreen);
    } catch (error, stackTrace) {
      log('Error completing order after payment: $error',
          name: 'PaymentWebView', error: error, stackTrace: stackTrace);
      if (!mounted) return;

      setState(() {
        _isCompletingPayment = false;
        _pageError =
            'Payment succeeded but the order could not be saved: $error';
      });
    }
  }

  void _handlePaymentFailure() {
    if (!mounted || _isCompletingPayment) return;

    log('Payment failure detected', name: 'PaymentWebView');
    scaffoldMessengerKey.currentState?.showSnackBar(
      const SnackBar(content: Text('Payment failed. Please try again.')),
    );
    context.pop(false);
  }

  /// Layer 1: pure URL-based detection (redirect flows)
  void _handleRedirectUrl(String? url) {
    if (url == null || _isCompletingPayment) return;

    log('URL check: $url', name: 'PaymentWebView');
    if (_matchesSuccessUrl(url)) {
      log('Success URL matched: $url', name: 'PaymentWebView');
      _handlePaymentSuccess();
    } else if (_isFailureUrl(url)) {
      log('Failure URL matched: $url', name: 'PaymentWebView');
      _handlePaymentFailure();
    }
  }

  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isCompletingPayment,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Payment',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
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
                // Register BEFORE any page loads
                _setupJavaScriptHandler(controller);
              },
              onLoadStart: (_, __) {
                if (!mounted) return;
                setState(() {
                  _isLoading = true;
                  _pageError = null;
                });
              },
              onLoadStop: (controller, url) {
                log('>>> LOADED URL: ${url?.toString()}',
                    name: 'PaymentWebView');
                if (!mounted) return;
                setState(() => _isLoading = false);

                final urlString = url?.toString();
                log('Page loaded: $urlString', name: 'PaymentWebView');

                // Layer 1: check URL pattern (handles redirect flows)
                _handleRedirectUrl(urlString);

                // Layer 2: JS content scan (handles Paymob's hosted success page)
                _injectPaymentDetector(controller);
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                final url = navigationAction.request.url?.toString();
                log('Navigation intercepted: $url', name: 'PaymentWebView');

                if (url != null) {
                  if (_matchesSuccessUrl(url)) {
                    log('Success URL intercepted: $url',
                        name: 'PaymentWebView');
                    _handlePaymentSuccess();
                    return NavigationActionPolicy.CANCEL;
                  } else if (_isFailureUrl(url)) {
                    log('Failure URL intercepted: $url',
                        name: 'PaymentWebView');
                    _handlePaymentFailure();
                    return NavigationActionPolicy.CANCEL;
                  }
                }
                return NavigationActionPolicy.ALLOW;
              },
              onReceivedError: (controller, request, error) {
                if (!mounted) return;
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
                      Text(_pageError!, textAlign: TextAlign.center),
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
