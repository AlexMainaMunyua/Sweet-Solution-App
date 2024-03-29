import 'package:ecommerce_application/pages/Config/config.dart';
import 'package:flutter/foundation.dart';

class CartItemCounter extends ChangeNotifier {
  int _counter = SweetSolution.sharedPreferences
          .getStringList(SweetSolution.userCartList)!
          .length -
      1;

  // int get count => _counter ?? "" as int;
  int get count => _counter;

  Future<void> displayResult() async {
    // ignore: unused_local_variable
    int _counter = SweetSolution.sharedPreferences
            .getStringList(SweetSolution.userCartList)!
            .length -
        1;

    await Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }
}
