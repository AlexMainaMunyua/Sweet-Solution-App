import 'package:flutter/foundation.dart';

class ItemQuantity with ChangeNotifier {
  int _numberOfItems = 0;

  int get numberOfItems => _numberOfItems;

  display(int no) async {
    _numberOfItems = no;

    notifyListeners();
  }

  void increment() {
    _numberOfItems++;

    notifyListeners();
  }

   void decrement() {
    _numberOfItems--;

    notifyListeners();
  }
}
