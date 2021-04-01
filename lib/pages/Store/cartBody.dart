import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_application/pages/Config/config.dart';
import 'package:ecommerce_application/pages/Model/item.dart';
import 'package:ecommerce_application/pages/Widgets/loadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class CartBody extends StatelessWidget {
  const CartBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList).toString()),

    );
  }
}
