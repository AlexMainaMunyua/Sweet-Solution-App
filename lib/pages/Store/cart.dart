import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_application/pages/Address/address.dart';
import 'package:ecommerce_application/pages/Config/config.dart';
import 'package:ecommerce_application/pages/Counter/cartItemCounter.dart';
import 'package:ecommerce_application/pages/Counter/itemQuantity.dart';
import 'package:ecommerce_application/pages/Counter/totalMoney.dart';
import 'package:ecommerce_application/pages/Model/item.dart';
import 'package:ecommerce_application/pages/Store/productPage.dart';
import 'package:ecommerce_application/pages/Widgets/customAppBar.dart';
import 'package:ecommerce_application/pages/Widgets/loadingWidget.dart';
import 'package:ecommerce_application/pages/Widgets/mydrawer.dart';
import 'package:ecommerce_application/pages/myhomepage/myhomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double totalAmount;

  int _itemCount;

  @override
  void initState() {
    super.initState();

    totalAmount = 0;
    _itemCount = 1;

    Provider.of<ItemQuantity>(context, listen: false).display(1);

    Provider.of<TotalAmount>(context, listen: false).displayAmount(0);
  }

  _onWillPop(BuildContext context) {
    Route route = MaterialPageRoute(builder: (c) => MyHomePage());

    Navigator.pushReplacement(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _onWillPop(context);
      },
      child: Scaffold(
        appBar: MyAppBar(),
        // floatingActionButton: FloatingActionButton.extended(
        //   label: Text("Check out"),
        //   backgroundColor: Colors.black12,
        //   icon: Icon(Icons.navigate_next),
        //   onPressed: () {
        //     if (EcommerceApp.sharedPreferences
        //             .getStringList(EcommerceApp.userCartList)
        //             .length ==
        //         1) {
        //       Fluttertoast.showToast(msg: "Your cart is empty");
        //     } else {
        //       Route route = MaterialPageRoute(
        //           builder: (c) => Address(totalAmount: totalAmount));

        //       Navigator.pushReplacement(context, route);
        //     }
        //   },
        // ),
        drawer: MyDrawer(),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          child: Container(
            height: 100.0,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 5.0),
                  child: Consumer2<TotalAmount, CartItemCounter>(
                    builder: (context, amountProvider, cartProvider, c) {
                      return Padding(
                        padding: EdgeInsets.all(8.0),
                        child: cartProvider.count == 0
                            ? Container()
                            : Container(
                                child: Row(
                                  children: [
                                    Text(
                                      "Total Amt: ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
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
                  margin: EdgeInsets.only(right: 5.0),
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  color: Colors.black12,
                  child: MaterialButton(
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
                      child: Text(
                        "Check out",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )),
                )
              ],
            ),
          ),
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                height: 10.0,
              ),
            ),
            // SliverToBoxAdapter(
            //   child: Consumer2<TotalAmount, CartItemCounter>(
            //     builder: (context, amountProvider, cartProvider, c) {
            //       return Align(
            //         alignment: Alignment.bottomCenter,
            //         child: Padding(
            //             child: Center(
            //               child: cartProvider.count == 0
            //                   ? Container()
            //                   : Text(
            //                       "Total Price: Ksh. ${amountProvider.totalAmount.toString()}",
            //                       style: TextStyle(
            //                           color: Colors.black,
            //                           fontSize: 18.0,
            //                           fontWeight: FontWeight.w500),
            //                     ),
            //             ),
            //             padding: EdgeInsets.all(8.0)),
            //       );
            //     },
            //   ),
            // ),
            StreamBuilder<QuerySnapshot>(
                stream: EcommerceApp.firestore
                    .collection("items")
                    .where("shortInfo",
                        whereIn: EcommerceApp.sharedPreferences
                            .getStringList(EcommerceApp.userCartList))
                    .snapshots(),
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
                }),
          ],
        ),
      ),
    );
  }

  Widget cartSourceInfo(ItemModel model, BuildContext context,
      {Color backgroud,
      removeCartFunction,
      increseItemQuantityFunction,
      decreaseItemQuantityFunction}) {
    final myCounter = context.watch<ItemQuantity>();
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
                                            icon: Icon(Icons.remove),
                                            onPressed: () {
                                              decreaseItemQuantityFunction();
                                            }),

                                        Text(
                                            myCounter.numberOfItems.toString()),
                                        IconButton(
                                            icon: Icon(Icons.add),
                                            onPressed: () {
                                       

                                              myCounter.increment();
                                            })

                                        // IconButton(
                                        //     icon: Icon(Icons.remove),
                                        //     onPressed: () {
                                        //       setState(() {
                                        //         if (_quantity > 1) {
                                        //           _quantity--;
                                        //         }
                                        //       });
                                        //     }),
                                        // Text("$_quantity".toString()),
                                        // IconButton(
                                        //     icon: Icon(Icons.add),
                                        //     onPressed: () {
                                        //       setState(() {
                                        //         _quantity++;
                                        //       });
                                        //     })
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
                      onPressed: () async {
                        removeCartFunction();

                        Route route =
                            MaterialPageRoute(builder: (c) => MyHomePage());

                        await Navigator.pushReplacement(context, route);
                      },
                    ),
                    // child: Container(
                    //   width: 30,
                    //   height: 20,
                    //   color: Colors.black12,
                    //   child: Center(
                    //       child: Text(
                    //     "5%",
                    //     style: TextStyle(fontSize: 10, color: Colors.black38),
                    //   )),
                    // ),
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

  increaseQuantity() {
    setState(() {
      _itemCount++;
    });
  }

  decreaseQuantity(String shortInfoID) {
    setState(() {
      if (_itemCount > 1) {
        _itemCount--;
      }
    });
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
