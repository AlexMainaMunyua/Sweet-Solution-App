import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_application/pages/Admin/orderCard.dart';
import 'package:ecommerce_application/pages/Admin/uploadItems.dart';
import 'package:ecommerce_application/pages/Config/config.dart';
import 'package:ecommerce_application/pages/Widgets/loadingWidget.dart';
import 'package:flutter/material.dart';

class AdminShiftOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<AdminShiftOrders> {
  _onWillPop(BuildContext context) {
    Route route = MaterialPageRoute(builder: (c) => UploadPage());

    Navigator.pushReplacement(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        _onWillPop(context);
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
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
              "My Orders",
              style: TextStyle(color: Colors.white, fontSize: 35.0, fontFamily: "Signatra"),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Route route = MaterialPageRoute(builder: (c) => UploadPage());

                Navigator.pushReplacement(context, route);
              },
            ),
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("orders").snapshots(),
            builder: (c, snapshot) {
              return snapshot.hasData
                  ? ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (c, index) {
                        return FutureBuilder<QuerySnapshot>(
                            future: FirebaseFirestore.instance
                                .collection("items")
                                .where("productId",
                                    whereIn: snapshot.data.docs[index]
                                        .data()[EcommerceApp.productID])
                                .get(),
                            builder: (c, snap) {
                              return snap.hasData
                                  ? AdminOrderCard(
                                      itemCount: snap.data.docs.length,
                                      data: snap.data.docs,
                                      orderID: snapshot.data.docs[index].id,
                                      orderBy: snapshot.data.docs[index]
                                          .data()["orderBy"],
                                      addressID: snapshot.data.docs[index]
                                          .data()["addressID"])
                                  : Center(
                                      child: circularProgress(),
                                    );
                            });
                      })
                  : Center(
                      child: circularProgress(),
                    );
            },
          ),
        ),
      ),
    );
  }
}
