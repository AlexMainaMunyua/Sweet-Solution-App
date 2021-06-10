import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_application/pages/Model/item.dart';
import 'package:ecommerce_application/pages/Widgets/orderCard.dart';
import 'package:flutter/material.dart';

int counter = 0;

class AdminOrderDetailCard extends StatelessWidget {
  final int? itemCount;
  final List<DocumentSnapshot>? data;
  final String? orderID;
  final String? addressID;
  final String? orderBy;

  const AdminOrderDetailCard(
      {Key? key,
      this.itemCount,
      this.data,
      this.orderID,
      this.addressID,
      this.orderBy})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 20),
      color: Colors.grey.shade200,
      margin: EdgeInsets.only(top: 10.0, left: 30.0, right: 30.0, bottom: 20),
      height: itemCount! * 120.0,
      child: ListView.builder(
          itemCount: itemCount,
          itemBuilder: (c, index) {
            ItemModel model = ItemModel.fromJson(data![index].data()!);
            return sourceInfo(model, context);
          }),
    );
  }
}


