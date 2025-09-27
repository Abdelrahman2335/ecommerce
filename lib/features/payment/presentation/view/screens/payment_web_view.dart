import 'dart:developer';

import 'package:ecommerce/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';

class PaymentWebView extends StatefulWidget {
  const PaymentWebView({super.key, required this.url});

  final String url;

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late InAppWebViewController webViewController;
  @override
  void dispose() {
    webViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "Payment",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          )),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(widget.url)),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },

        /// We will look in the
        onLoadStop: (controller, url) {
          log("in the onLoadStop");
          log("Final loaded URL: $url");

          if (url.toString().contains("success")) {
            log("Payment successful!");
            GoRouter.of(context).push(AppRouter.kLayoutScreen); // Close WebView
          } else if (url.toString().contains("failure")) {
            log("Payment failed!");
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
