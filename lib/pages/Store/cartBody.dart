import 'package:ecommerce_application/pages/Config/config.dart';
import 'package:flutter/material.dart';

class CartBody extends StatelessWidget {
  const CartBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList).toString()),

    );
  }
}
