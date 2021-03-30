import 'package:flutter/cupertino.dart';

class TotalAmount extends ChangeNotifier {
  double _totalAmount = 0;

  double get totalAmount => _totalAmount;

  displayAmount(double amount) async {
    _totalAmount = amount;

    await Future.delayed(const Duration(milliseconds: 100), () {
 notifyListeners();

    });

   
  }
}
