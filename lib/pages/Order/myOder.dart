import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_application/pages/Config/config.dart';
import 'package:ecommerce_application/pages/Widgets/loadingWidget.dart';
import 'package:ecommerce_application/pages/Widgets/orderCard.dart';
import 'package:ecommerce_application/pages/myhomepage/myhomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

_onWillPop(BuildContext context) {
  Route route = MaterialPageRoute(builder: (c) => MyHomePage());

  Navigator.pushReplacement(context, route);
}

class _MyOrdersState extends State<MyOrders> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
              style: TextStyle(
                  color: Colors.white, fontSize: 35.0, fontFamily: "Signatra"),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Route route = MaterialPageRoute(builder: (c) => MyHomePage());

                Navigator.pushReplacement(context, route);
              },
            ),
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: EcommerceApp.firestore
                .collection(EcommerceApp.collectionUser)
                .doc(EcommerceApp.sharedPreferences
                    .getString(EcommerceApp.userUID))
                .collection(EcommerceApp.collectionOrders)
                .snapshots(),
            builder: (c, snapshot) {
              return snapshot.hasData
                  ? ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (c, index) {
                        return FutureBuilder<QuerySnapshot>(
                            future: FirebaseFirestore.instance
                                .collection("items")
                                .where("shortInfo",
                                    whereIn: snapshot.data.docs[index]
                                        .data()[EcommerceApp.productID])
                                .get(),
                            builder: (c, snap) {
                              return snap.hasData
                                  ? OrderCard(
                                      itemCount: snap.data.docs.length,
                                      data: snap.data.docs,
                                      orderID: snapshot.data.docs[index].id,
                                    )
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
