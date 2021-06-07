import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_application/main.dart';
import 'package:ecommerce_application/pages/Config/config.dart';
import 'package:ecommerce_application/pages/Model/address.dart';
import 'package:ecommerce_application/pages/Order/myOder.dart';
import 'package:ecommerce_application/pages/Widgets/loadingWidget.dart';
import 'package:ecommerce_application/pages/Widgets/orderCardDetails.dart';
import 'package:ecommerce_application/pages/Widgets/wideButton.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

String getOrderId = "";

class OrderDetails extends StatefulWidget {
  final String orderID;

  const OrderDetails({Key key, this.orderID}) : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  Future<bool> _onWillPop() async {
    Route route = MaterialPageRoute(builder: (c) => MyOrders());

    Navigator.pushReplacement(context, route);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    getOrderId = widget.orderID;
    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: SafeArea(
        child: Scaffold(
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
            title: Text(
              "My Order Details",
              style: TextStyle(
                  fontSize: 30.0, color: Colors.white, fontFamily: "Signatra"),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Route route = MaterialPageRoute(builder: (c) => MyOrders());

                Navigator.pushReplacement(context, route);
              },
            ),
          ),
          body: SingleChildScrollView(
            child: FutureBuilder<DocumentSnapshot>(
              future: EcommerceApp.firestore
                  .collection(EcommerceApp.collectionUser)
                  .doc(EcommerceApp.sharedPreferences
                      .getString(EcommerceApp.userUID))
                  .collection(EcommerceApp.collectionOrders)
                  .doc(widget.orderID)
                  .get(),
              builder: (c, snapshot) {
                Map dataMap;
                if (snapshot.hasData) {
                  dataMap = snapshot.data.data();
                }
                return snapshot.hasData
                    ? Container(
                        child: Column(
                          children: [
                            StatusBanner(
                              status: dataMap[EcommerceApp.isSuccess],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Ksh." +
                                      dataMap[EcommerceApp.totalAmount]
                                          .toString(),
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Text(
                                "Order ID: " + getOrderId,
                                style: TextStyle(fontSize: 8.0),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Text(
                                "Ordered on: " +
                                    DateFormat("dd MMMM, yyyy - hh:mm aa")
                                        .format(
                                            DateTime.fromMicrosecondsSinceEpoch(
                                                int.parse(
                                                    dataMap["orderTime"]))),
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 16.0),
                              ),
                            ),
                            Divider(height: 2.0),
                            FutureBuilder<QuerySnapshot>(
                                future: EcommerceApp.firestore
                                    .collection("items")
                                    .where("productId",
                                        whereIn:
                                            dataMap[EcommerceApp.productID])
                                    .get(),
                                builder: (c, dataSnapshot) {
                                  return dataSnapshot.hasData
                                      ? OrderCardDetails(
                                          itemCount:
                                              dataSnapshot.data.docs.length,
                                          data: dataSnapshot.data.docs,
                                        )
                                      : Center(
                                          child: circularProgress(),
                                        );
                                }),
                            Divider(
                              height: 2,
                            ),
                            FutureBuilder<DocumentSnapshot>(
                                future: EcommerceApp.firestore
                                    .collection(EcommerceApp.collectionUser)
                                    .doc(EcommerceApp.sharedPreferences
                                        .getString(EcommerceApp.userUID))
                                    .collection(
                                        EcommerceApp.subCollectionAddress)
                                    .doc(dataMap[EcommerceApp.addressID])
                                    .get(),
                                builder: (c, snap) {
                                  return snap.hasData
                                      ? ShippingDetails(
                                          model: AddressModel.fromJson(
                                              snap.data.data()),
                                        )
                                      : Center(
                                          child: circularProgress(),
                                        );
                                })
                          ],
                        ),
                      )
                    : Center(
                        child: circularProgress(),
                      );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class StatusBanner extends StatelessWidget {
  final bool status;

  const StatusBanner({Key key, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String msg;
    IconData iconData;

    status ? iconData = Icons.done : iconData = Icons.cancel;

    status ? msg = "Succeful" : msg = "Unsuccessful";

    return Container(
      color: Colors.grey.shade300,
      height: 40.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20.0,
          ),
          Text(
            "Order Placed " + msg,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            width: 5.0,
          ),
          CircleAvatar(
            radius: 8.0,
            backgroundColor: Colors.grey,
            child: Center(
              child: Icon(
                iconData,
                color: Colors.white,
                size: 14.0,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class PaymentDetailsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ShippingDetails extends StatelessWidget {
  final AddressModel model;

  const ShippingDetails({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Shipment Details",
            style: TextStyle(
                color: Colors.black45,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          width: screenWidth,
          child: Table(
            children: [
              TableRow(children: [
                KeyText(
                  msg: "Name",
                ),
                Text(model.name, style: TextStyle(color: Colors.black45)),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "Phone Number",
                ),
                Text(model.phoneNumber,
                    style: TextStyle(color: Colors.black45)),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "Business Name",
                ),
                Text(model.flatNumber, style: TextStyle(color: Colors.black45)),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "Area",
                ),
                Text(model.city, style: TextStyle(color: Colors.black45)),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "Next to",
                ),
                Text(
                  model.state,
                  style: TextStyle(color: Colors.black45),
                ),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "County",
                ),
                Text(
                  model.pincode,
                  style: TextStyle(color: Colors.black45),
                ),
              ])
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20.0, bottom: 30.0),
          child: WideButton(
              onPressed: () {
                confirmedUserOrderReceived(context, getOrderId);
              },
              msg: "CONFIRMED ITEM RECEIVED"),
        ),
      ],
    );
  }

  confirmedUserOrderReceived(BuildContext context, String myOrderID) {
    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.collectionOrders)
        .doc(myOrderID)
        .delete();

    getOrderId = "";

    Route route = MaterialPageRoute(builder: (c) => SplashScreen());

    Navigator.pushReplacement(context, route);

    Fluttertoast.showToast(msg: "Order has been Received. Confirmed");
  }
}

class KeyText extends StatelessWidget {
  final String msg;

  const KeyText({Key key, this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        msg,
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
      ),
    );
  }
}
