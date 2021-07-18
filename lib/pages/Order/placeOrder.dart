import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_application/pages/Address/address.dart';
import 'package:ecommerce_application/pages/Config/config.dart';
import 'package:ecommerce_application/pages/Counter/cartItemCounter.dart';
import 'package:ecommerce_application/pages/Widgets/wideButton.dart';
import 'package:ecommerce_application/pages/myhomepage/myhomePage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class PaymentPage extends StatefulWidget {
  final String? addressId;
  final double? totalAmount;

  const PaymentPage({Key? key, this.addressId, this.totalAmount})
      : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.black26, Colors.white],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp)),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Route route = MaterialPageRoute(builder: (c) => Address());

            Navigator.pushReplacement(context, route);
          },
        ),
        title: Text(
          "Confirm",
          style: TextStyle(
              fontSize: 35.0, color: Colors.white, fontFamily: "Signatra"),
        ),
      ),
      body: ListView(
        children: [
          Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 50.0,
                    color: Colors.grey.shade200,
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Container(
                            margin: EdgeInsets.only(left: 15.0),
                            child: Text(
                              "Select payment method",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black26,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Card(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Radio(
                                  value: true,
                                  groupValue: true,
                                  onChanged: (dynamic val) {}),
                              Text(
                                "Pay on Delivery",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )
                            ],
                          ),
                          Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(
                                  right: 20.0, left: 40.0, top: 10.0),
                              child: Text(
                                "- Available",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                          Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(
                                  right: 20.0, left: 40.0, top: 10.0),
                              child: Text(
                                "Before you proceed, kindly make sure you have enough money at hand",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black45),
                              )),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Card(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Radio(
                                activeColor: Colors.grey.shade300,
                                onChanged: (dynamic val) {},
                                groupValue: null,
                                value: null,
                              ),
                              Text(
                                "Lipa na mpesa",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black38),
                              )
                            ],
                          ),
                          Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(
                                  right: 20.0, left: 40.0, top: 10.0),
                              child: Text(
                                "Comming soon",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 2.0,
                    indent: 25.0,
                    endIndent: 25.0,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 25, right: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Amount",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Ksh. ${widget.totalAmount}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  WideButton(
                    msg: "COMPLETE ORDER",
                    onPressed: () {
                      addOrderDetails();
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  addOrderDetails() {
    writeOrderDetailsForUsers({
      SweetSolution.addressID: widget.addressId,
      SweetSolution.totalAmount: widget.totalAmount,
      "orderBy":
          SweetSolution.sharedPreferences.getString(SweetSolution.userUID),
      SweetSolution.productID: SweetSolution.sharedPreferences
          .getStringList(SweetSolution.userCartList),
      SweetSolution.paymentDetails: "Cash on Delivery",
      SweetSolution.orderTime: DateTime.now().microsecondsSinceEpoch.toString(),
      SweetSolution.isSuccess: true
    });

    writeOrderDetailsForAdmin({
      SweetSolution.addressID: widget.addressId,
      SweetSolution.totalAmount: widget.totalAmount,
      "orderBy":
          SweetSolution.sharedPreferences.getString(SweetSolution.userUID),
      SweetSolution.productID: SweetSolution.sharedPreferences
          .getStringList(SweetSolution.userCartList),
      SweetSolution.paymentDetails: "Cash on Delivery",
      SweetSolution.orderTime: DateTime.now().microsecondsSinceEpoch.toString(),
      SweetSolution.isSuccess: true
    }).whenComplete(() => {emptyCartNow()});
  }

  emptyCartNow() {
    SweetSolution.sharedPreferences
        .setStringList(SweetSolution.userCartList, ["garbageValue"]);

    List? tempList = SweetSolution.sharedPreferences
        .getStringList(SweetSolution.userCartList);

    FirebaseFirestore.instance
        .collection("userPhone")
        .doc(SweetSolution.sharedPreferences.getString(SweetSolution.userUID))
        .update({
      SweetSolution.userCartList: tempList,
    }).then((value) {
      SweetSolution.sharedPreferences
          .setStringList(SweetSolution.userCartList, tempList as List<String>);

      Provider.of<CartItemCounter>(context, listen: false).displayResult();
    });

    Route route = MaterialPageRoute(builder: (c) => MyHomePage());

    Navigator.pushReplacement(context, route);

    Fluttertoast.showToast(
        msg: "Congratulations, Your order has been placed succefully");
  }

  Future writeOrderDetailsForUsers(Map<String, dynamic> data) async {
    await SweetSolution.firestore
        .collection(SweetSolution.collectionUser)
        .doc(SweetSolution.sharedPreferences.getString(SweetSolution.userUID))
        .collection(SweetSolution.collectionOrders)
        .doc(SweetSolution.sharedPreferences.getString(SweetSolution.userUID)! +
            data['orderTime'])
        .set(data);
  }

  Future writeOrderDetailsForAdmin(Map<String, dynamic> data) async {
    await SweetSolution.firestore
        .collection(SweetSolution.collectionOrders)
        .doc(SweetSolution.sharedPreferences.getString(SweetSolution.userUID)! +
            data['orderTime'])
        .set(data);
  }
}
