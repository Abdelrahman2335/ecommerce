import 'package:flutter/material.dart';


// enum PaymentMethod {cashOnDelivery, payByCard,}

class PaymentProvider extends ChangeNotifier{

  String paymentMethod = "Cash On Delivery";

  void payByCash(String selectedMethod){
    paymentMethod = selectedMethod;
    notifyListeners();
  }
  void payByCard(String selectedMethod){
    paymentMethod = selectedMethod;
    notifyListeners();
  }
}