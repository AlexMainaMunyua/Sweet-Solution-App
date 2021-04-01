import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_application/pages/Config/config.dart';
import 'package:ecommerce_application/pages/Counter/cartItemCounter.dart';
import 'package:ecommerce_application/pages/Model/item.dart';
import 'package:ecommerce_application/pages/Store/cart.dart';
import 'package:ecommerce_application/pages/Store/productPage.dart';
import 'package:ecommerce_application/pages/Widgets/loadingWidget.dart';
import 'package:ecommerce_application/pages/Widgets/mydrawer.dart';
import 'package:ecommerce_application/pages/Widgets/searchBox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
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
          "p-shop",
          style: TextStyle(
              fontSize: 55.0, color: Colors.white, fontFamily: "Signatra"),
        ),
        centerTitle: true,
        actions: [
          Stack(children: [
            IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  // size: 30.0,
                  color: Colors.black26,
                ),
                onPressed: () {
                  Route route = MaterialPageRoute(builder: (c) => CartPage());

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
                                      .getStringList(EcommerceApp.userCartList)
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
          ])
        ],
      ),
      drawer: MyDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(pinned: true, delegate: SearchBoxDelegate()),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("items")
                .limit(15)
                .orderBy("publishedDate", descending: true)
                .snapshots(),
            builder: (context, dataSnapshot) {
              return !dataSnapshot.hasData
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: circularProgress(),
                      ),
                    )
                  : SliverStaggeredGrid.countBuilder(
                      crossAxisCount: 1,
                      staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                      itemBuilder: (context, index) {
                        ItemModel model = ItemModel.fromJson(
                            dataSnapshot.data.docs[index].data());
                        return sourceInfo(model, context);
                      },
                      itemCount: dataSnapshot.data.docs.length,
                    );
            },
          )
        ],
      ),
    ));
  }
}

Widget sourceInfo(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  return InkWell(
    onTap: () {
      Route route =
          MaterialPageRoute(builder: (c) => ProductPage(itemModel: model));

      Navigator.pushReplacement(context, route);
    },
    splashColor: Colors.black26,
    child: Padding(
      padding: EdgeInsets.all(9.0),
      child: Container(
        height: 190.0,
        // width: width,

        child: Row(
          children: [
            Image.network(
              model.thumbnailUrl,
              height: 140.0,
              width: 140.0,
            ),
            SizedBox(
              width: 4.0,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                          child: Text(
                        model.title,
                        style: TextStyle(color: Colors.black45, fontSize: 14.0),
                      ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                          child: Text(
                        model.shortInfo,
                        style: TextStyle(color: Colors.black38, fontSize: 12.0),
                      ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      width: 40.0,
                      height: 43.0,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "50%",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.normal),
                            ),
                            Text(
                              "OFF%",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.normal),
                            )
                          ],
                        ),
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.black26,
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 0.0),
                          child: Row(
                            children: [
                              Text(
                                "Original price: Ksh.",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                (model.price + model.price).toString(),
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5.0),
                          child: Row(
                            children: [
                              Text(
                                "New price: Ksh.",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                (model.price).toString(),
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
                Flexible(
                  child: Container(),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: removeCartFunction == null
                      ? IconButton(
                          onPressed: () {
                            checkItemInCart(model.shortInfo, context);
                          },
                          icon: Icon(
                            Icons.add_shopping_cart,
                            color: Colors.black26,
                          ))
                      : IconButton(
                          icon: Icon(Icons.remove_shopping_cart),
                          onPressed: () {
                            removeCartFunction();
                            Route route =
                                MaterialPageRoute(builder: (c) => MyHomePage());

                            Navigator.pushReplacement(context, route);
                          }),
                ),
                Divider(
                  height: 5.0,
                  color: Colors.black26,
                )
              ],
            ))
          ],
        ),
      ),
    ),
  );
}

Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
  return Container(
    height: 150.0,
    // width:  width * .34,
    margin:  EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    decoration: BoxDecoration(
      color: primaryColor,
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      boxShadow: <BoxShadow>[
        BoxShadow(offset: Offset(0, 5), blurRadius: 10.0, color: Colors.grey[200])
      ]
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      child: Image.network(
        imgPath,
        height: 150.0,
        fit: BoxFit.fill,

      ),

    ),

  );
}

void checkItemInCart(String shortInfoID, BuildContext context) {
  EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartList)
          .contains(shortInfoID)
      ? Fluttertoast.showToast(msg: "Item already in Cart")
      : addItemToCart(shortInfoID, context);
}

addItemToCart(String shortInfoID, BuildContext context) {
  List tempCartList =
      EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);

  tempCartList.add(shortInfoID);

  EcommerceApp.firestore
      .collection(EcommerceApp.collectionUser)
      .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
      .update({
    EcommerceApp.userCartList: tempCartList,
  }).then((value) {
    Fluttertoast.showToast(msg: "Item Added to Cart Successfully");

    EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartList, tempCartList);

    Provider.of<CartItemCounter>(context, listen: false).displayResult();
  });
}
