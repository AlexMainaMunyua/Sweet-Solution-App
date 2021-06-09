import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_application/pages/Admin/adminOrderDetailCard.dart';
import 'package:ecommerce_application/pages/Admin/shiftOrders.dart';
import 'package:ecommerce_application/pages/Admin/uploadItems.dart';
import 'package:ecommerce_application/pages/Config/config.dart';
import 'package:ecommerce_application/pages/Model/address.dart';
import 'package:ecommerce_application/pages/Widgets/loadingWidget.dart';
import 'package:ecommerce_application/pages/Widgets/wideButton.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

String? getOrderId = "";

class AdminOrderDetails extends StatefulWidget {
  final String? orderID;
  final String? orderBy;
  final String? addressID;

  const AdminOrderDetails({Key? key, this.orderID, this.orderBy, this.addressID})
      : super(key: key);

  @override
  _AdminOrderDetailsState createState() => _AdminOrderDetailsState();
}

class _AdminOrderDetailsState extends State<AdminOrderDetails> {
  Future<bool> _onWillPop() async {
    Route route = MaterialPageRoute(builder: (c) => AdminShiftOrders());

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
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Route route =
                    MaterialPageRoute(builder: (c) => AdminShiftOrders());
                Navigator.pushReplacement(context, route);
              },
            ),
            title: Text(
              "Order Details",
              style: TextStyle(
                  fontSize: 35.0, color: Colors.white, fontFamily: "Signatra"),
            ),
          ),
          body: SingleChildScrollView(
            child: FutureBuilder<DocumentSnapshot>(
              future: EcommerceApp.firestore
                  .collection(EcommerceApp.collectionOrders)
                  .doc(getOrderId)
                  .get(),
              builder: (c, snapshot) {
                Map? dataMap;
                if (snapshot.hasData) {
                  dataMap = snapshot.data!.data();
                }
                return snapshot.hasData
                    ? Container(
                        child: Column(
                          children: [
                            AdminStatusBanner(
                              status: dataMap![EcommerceApp.isSuccess],
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
                              child: Text("Order ID:" + getOrderId!,
                                  style: TextStyle(fontSize: 8.0)),
                            ),
                            Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Text(
                                "Ordered at:" +
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
                                      ? AdminOrderDetailCard(
                                          itemCount:
                                              dataSnapshot.data!.docs.length,
                                          data: dataSnapshot.data!.docs,
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
                                    .doc(widget.orderBy)
                                    .collection(
                                        EcommerceApp.subCollectionAddress)
                                    .doc(widget.addressID)
                                    .get(),
                                builder: (c, snap) {
                                  return snap.hasData
                                      ? AdminShippingDetails(
                                          model: AddressModel.fromJson(
                                              snap.data!.data()!),
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

class AdminStatusBanner extends StatelessWidget {
  final bool? status;

  const AdminStatusBanner({Key? key, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String msg;
    // ignore: unused_local_variable
    IconData iconData;

    status! ? iconData = Icons.done : iconData = Icons.cancel;

    status! ? msg = "Succeful" : msg = "Unsuccessful";

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
            "Order Shipped" + msg,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            width: 5.0,
          ),
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

class AdminShippingDetails extends StatelessWidget {
  final AddressModel? model;

  const AdminShippingDetails({Key? key, this.model}) : super(key: key);

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
                Text(model!.name!, style: TextStyle(color: Colors.black45)),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "Phone Number",
                ),
                Text(model!.phoneNumber!,
                    style: TextStyle(color: Colors.black45)),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "Business Name",
                ),
                Text(model!.flatNumber!, style: TextStyle(color: Colors.black45)),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "Area",
                ),
                Text(model!.city!, style: TextStyle(color: Colors.black45)),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "Next to",
                ),
                Text(
                  model!.state!,
                  style: TextStyle(color: Colors.black45),
                ),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "County",
                ),
                Text(
                  model!.pincode!,
                  style: TextStyle(color: Colors.black45),
                ),
              ]),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20.0, bottom: 30.0),
          child: WideButton(
            msg: "CONFIRMED ORDER SHIFTED",
            onPressed: () {
              confirmedOrderShifted(context, getOrderId);
            },
          ),
        ),
      ],
    );
  }

  confirmedOrderShifted(BuildContext context, String? myOrderID) {
    EcommerceApp.firestore
        .collection(EcommerceApp.collectionOrders)
        .doc(myOrderID)
        .delete();

    getOrderId = "";

    Route route = MaterialPageRoute(builder: (c) => UploadPage());

    Navigator.pushReplacement(context, route);

    Fluttertoast.showToast(msg: "Order has been Shifted. Confirmed");
  }
}

class KeyText extends StatelessWidget {
  final String? msg;

  const KeyText({Key? key, this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        msg!,
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
      ),
    );
  }
}
