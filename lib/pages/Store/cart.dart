import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_application/pages/Address/address.dart';
import 'package:ecommerce_application/pages/Config/config.dart';
import 'package:ecommerce_application/pages/Counter/cartItemCounter.dart';
import 'package:ecommerce_application/pages/Counter/totalMoney.dart';
import 'package:ecommerce_application/pages/Model/item.dart';
import 'package:ecommerce_application/pages/Store/productPage.dart';
import 'package:ecommerce_application/pages/Widgets/loadingWidget.dart';
import 'package:async/async.dart';
import 'package:ecommerce_application/pages/Widgets/wideButton.dart';
import 'package:ecommerce_application/pages/myhomepage/myhomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';


class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double totalAmount;
  TextEditingController _numberCtrl = new TextEditingController();

  int quantity;

  Stream streamA = EcommerceApp.firestore
      .collection("items")
      .where("shortInfo",
          whereIn: EcommerceApp.sharedPreferences
              .getStringList(EcommerceApp.userCartList))
      .snapshots();
  Stream streamB = EcommerceApp.firestore
      .collection("flash")
      .where("shortInfo",
          whereIn: EcommerceApp.sharedPreferences
              .getStringList(EcommerceApp.userCartList))
      .snapshots();

  List<QuerySnapshot> getList(QuerySnapshot list1) {
    List<QuerySnapshot> result = [];

    (list1 as List).forEach((element) {
      result.add(element);
    });
    return result;
  }

  List<QuerySnapshot> combineLists(
      List<QuerySnapshot> list1, List<QuerySnapshot> list2) {
    List<QuerySnapshot> result = [];
    list1.forEach((element) {
      result.add(element);
    });
    list2.forEach((element) {
      result.add(element);
    });
    return result;
  }

  @override
  void initState() {
    super.initState();

    quantity = 1;
    _numberCtrl.text = "0720778156";
    totalAmount = 0;

    Provider.of<TotalAmount>(context, listen: false).displayAmount(0);
  }

  // Observable<List<QuerySnapshot>> combineStream = Observable.combineLatest2()

  Stream<List<QuerySnapshot>> getData() {
    Stream stream1 = EcommerceApp.firestore
        .collection("items")
        .where("shortInfo",
            whereIn: EcommerceApp.sharedPreferences
                .getStringList(EcommerceApp.userCartList))
        .snapshots();
    Stream stream2 = EcommerceApp.firestore
        .collection("flash")
        .where("shortInfo",
            whereIn: EcommerceApp.sharedPreferences
                .getStringList(EcommerceApp.userCartList))
        .snapshots();

    return StreamZip([stream1, stream2]);
  }

  _onWillPop(BuildContext context) {
    Route route = MaterialPageRoute(builder: (c) => MyHomePage());

    Navigator.pushReplacement(context, route);
  }

  @override
  Widget build(BuildContext context) {
    // Stream combineStream =
    //     Rx.combineLatest2(streamA, streamB, (a, b) => [a, b]);
    return WillPopScope(
      onWillPop: () {
        _onWillPop(context);
      },
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
            "Cart",
            style: TextStyle(
                fontSize: 35.0, color: Colors.white, fontFamily: "Signatra"),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Route route = MaterialPageRoute(builder: (c) => MyHomePage());

              Navigator.pushReplacement(context, route);
            },
          ),
          actions: [
            Container(
              padding: EdgeInsets.only(right: 5.0, top: 5.0),
              child: Stack(children: [
                IconButton(
                    icon: Icon(
                      Icons.shopping_cart,
                      // size: 30.0,
                      color: Colors.black26,
                    ),
                    onPressed: () {
                      Route route =
                          MaterialPageRoute(builder: (c) => CartPage());

                      Navigator.pushReplacement(context, route);
                    }),
                Positioned(
                    child: Stack(
                  children: [
                    Icon(
                      Icons.brightness_1,
                      size: 20.0,
                      color: Colors.black45,
                    ),
                    Positioned(
                      top: 3.0,
                      bottom: 4.0,
                      left: 6.0,
                      child: Consumer<CartItemCounter>(
                        builder: (context, counter, _) {
                          return Text(
                              (EcommerceApp.sharedPreferences
                                          .getStringList(
                                              EcommerceApp.userCartList)
                                          .length -
                                      1)
                                  .toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500));
                        },
                      ),
                    )
                  ],
                )),
              ]),
            )
          ],
        ),
        // drawer: MyDrawer(),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                height: 10.0,
              ),
            ),
            // StreamBuilder<QuerySnapshot>(
            //     stream: streamA,
            //     builder: (BuildContext context,
            //         AsyncSnapshot<QuerySnapshot> itemSnapshot) {
            //       return StreamBuilder(
            //         stream: streamB,
            //         builder: (context, flashSnapShot) {
            //           if (itemSnapshot.hasError ||
            //               flashSnapShot.hasError ||
            //               !flashSnapShot.hasData)
            //             return Text(
            //                 "Error: ${itemSnapshot.error}, ${flashSnapShot.error}");
            //           switch (itemSnapshot.connectionState) {
            //             case ConnectionState.waiting:
            //               return Text("Loading...");
            //             default:
            //               return ListView(children: itemSnapshot.data.docs
            //                   .map((DocumentSnapshot doc) {
            //                 var item = "";
            //                 if (doc['uid'] != null &&
            //                     itemSnapshot.data != null) {
            //                   item = doc['uid'];
            //                   item = itemSnapshot.data.docs
            //                       .firstWhere((element) => element.id == item)
            //                       .data();
            //                 }
            //               }).toList()
            //               );
            //           }
            //         },
            //       );
            //     }),
            StreamBuilder(
              stream: streamA,
              builder: (context, snapshot) {
                return !snapshot.hasData
                    ? SliverToBoxAdapter(
                        child: Center(
                          child: circularProgress(),
                        ),
                      )
                    : snapshot.data.docs.length == 0
                        ? beginBuildingCart()
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                ItemModel model = ItemModel.fromJson(
                                    snapshot.data.docs[index].data());

                                if (index == 0) {
                                  totalAmount = 0;
                                  totalAmount = model.price + totalAmount;
                                } else {
                                  totalAmount = model.price + totalAmount;
                                }
                                if (snapshot.data.docs.length - 1 == index) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((t) {
                                    Provider.of<TotalAmount>(context,
                                            listen: false)
                                        .displayAmount(totalAmount);
                                  });
                                }

                                return cartSourceInfo(model, context,
                                    removeCartFunction: () =>
                                        removeItemFromUserCart(
                                            model.shortInfo));
                              },
                              childCount: snapshot.hasData
                                  ? snapshot.data.docs.length
                                  : 0,
                            ),
                          );
              },
            ),
            // StreamBuilder(
            //     stream: getData(),
            //     builder:
            //         (context, AsyncSnapshot<List<QuerySnapshot>> snapshot) {
            //       List<QuerySnapshot> querySnapshotData =
            //           snapshot.data.toList();

            //       //copy document snapshots from second stream to first so querySnapshotData[0].documents will have all documents from both query snapshots
            //       querySnapshotData[0].docs.addAll(querySnapshotData[1].docs);

            //       if (querySnapshotData[0].docs.isEmpty) {
            //         return SliverToBoxAdapter(
            //           child: Center(
            //             child: circularProgress(),
            //           ),
            //         );
            //       } else {
            //         // List<QuerySnapshot> _list = [];
            //         // _list.addAll(getList(snapshot.data[0]));
            //         // _list.addAll(getList(snapshot.data[1]));
            //         if (querySnapshotData[0].docs.length == 0) {
            //           return beginBuildingCart();
            //         } else {
            //           // return ListView(
            //           //   children: List.generate(
            //           //       querySnapshotData[0].docs.length, (index) {
            //           //     DocumentSnapshot documentSnapshot =
            //           //         querySnapshotData[0].docs[index];

            //           //     return Text(documentSnapshot["title"]);
            //           //   }),
            //           //   // children: querySnapshotData[0]
            //           //   //     .docs
            //           //   //     .map((DocumentSnapshot documentSnapshot) {
            //           //   //   var userDocument = documentSnapshot;
            //           //   //   print(userDocument['title']);
            //           //   //   // return Text(userDocument["items"]);
            //           //   // }),
            //           // );
            //           return SliverList(
            //             delegate: SliverChildBuilderDelegate(
            //               (context, index) {
            //                 ItemModel model = ItemModel.fromJson(
            //                     querySnapshotData[0].docs[index].data());

            //                 if (index == 0) {
            //                   totalAmount = 0;
            //                   totalAmount = model.price + totalAmount;
            //                 } else {
            //                   totalAmount = model.price + totalAmount;
            //                 }
            //                 if ( querySnapshotData[0].docs.length - 1 == index) {
            //                   WidgetsBinding.instance.addPostFrameCallback((t) {
            //                     Provider.of<TotalAmount>(context, listen: false)
            //                         .displayAmount(totalAmount);
            //                   });
            //                 }
            //                 print(snapshot.data[0].docs.length +
            //                     snapshot.data[1].docs.length);

            //                 return cartSourceInfo(model, context,
            //                     removeCartFunction: () =>
            //                         removeItemFromUserCart(model.shortInfo));
            //               },
            //               childCount: snapshot.hasData ?  querySnapshotData[0].docs.length : 0,
            //             ),
            //           );
            //         }
            //       }
            //     }),

            // StreamBuilder(
            //     stream: getData(),
            //     builder: (BuildContext context,
            //         AsyncSnapshot<List<QuerySnapshot>> snapshot) {
            //       List<QuerySnapshot> querySnapshotData =
            //           snapshot.data.toList();

            //       querySnapshotData[0].docs.addAll(querySnapshotData[1].docs);

            //       if (querySnapshotData[0].docs.isEmpty)
            //         return SliverToBoxAdapter(
            //             child: Center(
            //           child: circularProgress(),
            //         ));

            //       if (querySnapshotData[0].docs.length == 0) {
            //         return beginBuildingCart();
            //       } else {
            //         return SliverList(delegate: SliverChildBuilderDelegate((context, index){

            //             ItemModel model = ItemModel.fromJson(
            //                           snapshot.data.docs[index].data());

            //                       if (index == 0) {
            //                         totalAmount = 0;
            //                         totalAmount = model.price + totalAmount;
            //                       } else {
            //                         totalAmount = model.price + totalAmount;
            //                       }
            //                       if (snapshot.data.docs.length - 1 == index) {
            //                         WidgetsBinding.instance
            //                             .addPostFrameCallback((t) {
            //                           Provider.of<TotalAmount>(context,
            //                                   listen: false)
            //                               .displayAmount(totalAmount);
            //                         });
            //                       }

            //         })
            //         );

            //       }
            //       // return ListView(
            //       //   children: querySnapshotData[0]
            //       //       .docs
            //       //       .map((DocumentSnapshot documentSnapshot) {
            //       //     return Text(documentSnapshot.id);
            //       //   }).toList(),
            //       // );
            //     }),

            // StreamBuilder(
            //     stream: Rx.combineLatest2(
            //         streamA, streamB, (a, b) => a != null || b != null),
            //     builder: (context, snapshot) {}),
            // StreamBuilder<QuerySnapshot>(
            //     // stream: EcommerceApp.firestore
            //     //     .collection("items")
            //     //     .where("shortInfo",
            //     //         whereIn: EcommerceApp.sharedPreferences
            //     //             .getStringList(EcommerceApp.userCartList))
            //     //     .snapshots(),
            //     stream: streamA,
            //     //  stream: StreamGroup.merge(streamA,streamB),

            //     // final item = a.docs.first.data();
            //     // final flash = b.docs.first.data();

            //     // return (item["shortInfo"] as List<String>)
            //     //     .where((element) => element == flash["shortInfo"])
            //     //     .toList();
            //     // stream: getData(),
            //     // stream: Rx.combineLatest2(streamA, streamB, (a, b) {
            //     //   streamB.where((event) => event.startWith(streamA));
            //     // }),
            //     // stream: Rx.combineLatest([streamA], (values) => true),
            //     builder: (context, snapshot) {
            //       StreamBuilder(
            //         stream: streamB,
            //         builder: (context, snapshot) {
            //             return !snapshot.hasData
            //           ? SliverToBoxAdapter(
            //               child: Center(
            //                 child: circularProgress(),
            //               ),
            //             )
            //           : snapshot.data.docs.length == 0
            //               ? beginBuildingCart()
            //               : SliverList(
            //                   delegate: SliverChildBuilderDelegate(
            //                     (context, index) {
            //                       ItemModel model = ItemModel.fromJson(
            //                           snapshot.data.docs[index].data());

            //                       if (index == 0) {
            //                         totalAmount = 0;
            //                         totalAmount = model.price + totalAmount;
            //                       } else {
            //                         totalAmount = model.price + totalAmount;
            //                       }
            //                       if (snapshot.data.docs.length - 1 == index) {
            //                         WidgetsBinding.instance
            //                             .addPostFrameCallback((t) {
            //                           Provider.of<TotalAmount>(context,
            //                                   listen: false)
            //                               .displayAmount(totalAmount);
            //                         });
            //                       }

            //                       return cartSourceInfo(model, context,
            //                           removeCartFunction: () =>
            //                               removeItemFromUserCart(
            //                                   model.shortInfo));
            //                     },
            //                     childCount: snapshot.hasData
            //                         ? snapshot.data.docs.length
            //                         : 0,
            //                   ),
            //                 );

            //         },
            //       );

            //     }),
            SliverToBoxAdapter(
              child: Container(
                height: 20,
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Consumer2<TotalAmount, CartItemCounter>(
                        builder: (context, amountProvider, cartProvider, c) {
                          return Padding(
                            padding: EdgeInsets.all(8.0),
                            child: cartProvider.count == 0
                                ? Container(
                                    padding:
                                        EdgeInsets.only(left: 20, right: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Total Amount: ",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          "Ksh.${amountProvider.totalAmount.toString()}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
                                  )
                                : Container(
                                    padding:
                                        EdgeInsets.only(left: 20, right: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Total Amount: ",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          "Ksh.${amountProvider.totalAmount.toString()}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
                                  ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10.0),
                      child: WideButton(
                        onPressed: () {
                          if (EcommerceApp.sharedPreferences
                                  .getStringList(EcommerceApp.userCartList)
                                  .length ==
                              1) {
                            Fluttertoast.showToast(msg: "Your cart is empty");
                          } else {
                            Route route = MaterialPageRoute(
                                builder: (c) =>
                                    Address(totalAmount: totalAmount));

                            Navigator.pushReplacement(context, route);
                          }
                        },
                        msg: "CHECK OUT",
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10.0),
                      child: WideButton(
                        onPressed: () async {
                          await FlutterPhoneDirectCaller.callNumber(
                              _numberCtrl.text);
                        },
                        msg: "CALL TO ORDER",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cartSourceInfo(
    ItemModel model,
    BuildContext context, {
    Color backgroud,
    removeCartFunction,
  }) {
    return InkWell(
      onTap: () {
        Route route =
            MaterialPageRoute(builder: (c) => ProductPage(itemModel: model));

        Navigator.pushReplacement(context, route);
      },
      splashColor: Colors.black26,
      child: Container(
        height: 120.0,
        child: Card(
          child: Container(
            child: Stack(
              children: [
                Row(
                  children: [
                    Container(
                      child: Center(
                        child: Image.network(
                          model.thumbnailUrl,
                          height: 80.0,
                          width: 120.0,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // SizedBox(height: 15.0,),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                model.shortInfo,
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 12.0),
                              )),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                                child: Text(
                              model.title,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12.0),
                            )),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Ksh.",
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        (model.price).toString(),
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.black,
                                        ),
                                      )
                                    ],
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        IconButton(
                                            icon: Icon(
                                              Icons.remove,
                                              color: Colors.black26,
                                              size: 18,
                                            ),
                                            onPressed: () {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "You can order one item only for now");
                                            }),
                                        Text(
                                          quantity.toString(),
                                          style: TextStyle(
                                              color: Colors.black26,
                                              fontSize: 12),
                                        ),
                                        IconButton(
                                            icon: Icon(
                                              Icons.add,
                                              color: Colors.black26,
                                              size: 18,
                                            ),
                                            onPressed: () {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "You can order one item only for now");
                                            })
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  // padding: EdgeInsets.only(right: 2.0, top: 2.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      iconSize: 20,
                      color: Colors.black45,
                      icon: Icon(Icons.remove_shopping_cart),
                      onPressed: () {
                        removeCartFunction();

                        Route route =
                            MaterialPageRoute(builder: (c) => MyHomePage());

                        Navigator.pushReplacement(context, route);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    ;
  }

  beginBuildingCart() {
    return SliverToBoxAdapter(
      child: Card(
          child: Container(
            height: 100.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Cart is Empty",
                    style: TextStyle(
                      color: Colors.white,
                    )),
                SizedBox(
                  height: 10,
                ),
                Text("Start adding items to your Cart.",
                    style: TextStyle(
                      color: Colors.white,
                    ))
              ],
            ),
          ),
          color: Colors.grey.shade400),
    );
  }

  removeItemFromUserCart(String shortInfoID) {
    List tempCartList =
        EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);

    tempCartList.remove(shortInfoID);

    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .update({
      EcommerceApp.userCartList: tempCartList,
    }).then((value) {
      Fluttertoast.showToast(msg: "Item Removed Successfully");

      EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userCartList, tempCartList);

      Provider.of<CartItemCounter>(context, listen: false).displayResult();

      totalAmount = 0;
    });
  }
}
