import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_application/pages/Address/address.dart';
import 'package:ecommerce_application/pages/Config/config.dart';
import 'package:ecommerce_application/pages/Counter/cartItemCounter.dart';
import 'package:ecommerce_application/pages/Counter/totalMoney.dart';
import 'package:ecommerce_application/pages/Model/item.dart';
import 'package:ecommerce_application/pages/Store/cartBody.dart';
import 'package:ecommerce_application/pages/Store/checkOutCard.dart';
import 'package:ecommerce_application/pages/Widgets/customAppBar.dart';
import 'package:ecommerce_application/pages/Widgets/loadingWidget.dart';
import 'package:ecommerce_application/pages/Widgets/mydrawer.dart';
import 'package:ecommerce_application/pages/myhomepage/myhomePage.dart';
// import 'package:ecommerce_application/pages/Widgets/orderCard.dart';
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

  @override
  void initState() {
    super.initState();

    totalAmount = 0;
    Provider.of<TotalAmount>(context, listen: false).displayAmount(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Check out"),
        backgroundColor: Colors.black26,
        icon: Icon(Icons.navigate_next),
        onPressed: () {
          if (EcommerceApp.sharedPreferences
                  .getStringList(EcommerceApp.userCartList)
                  .length ==
              1) {
            Fluttertoast.showToast(msg: "Your cart is empty");
          } else {
            Route route = MaterialPageRoute(
                builder: (c) => Address(totalAmount: totalAmount));

            Navigator.pushReplacement(context, route);
          }
        },
      ),
      drawer: MyDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Consumer2<TotalAmount, CartItemCounter>(
              builder: (context, amountProvider, cartProvider, c) {
                return Padding(
                    child: Center(
                      child: cartProvider.count == 0
                          ? Container()
                          : Text(
                              "Total Price: Ksh ${amountProvider.totalAmount.toString()}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500),
                            ),
                    ),
                    padding: EdgeInsets.all(8.0));
              },
            ),
          ),
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

                                return sourceInfo(model, context,
                                     removeCartFunction: () =>
                                        removeItemFromUserCart(
                                            model.shortInfo));
                              },
                              childCount: snapshot.hasData
                                  ? snapshot.data.docs.length
                                  : 0,
                            ),
                          );
              })
        ],
      ),
    );
  }

  beginBuildingCart() {
    return SliverToBoxAdapter(
      child: Card(
          child: Container(
            height: 100.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.insert_emoticon,
                  color: Colors.white,
                ),
                Text("Cart is Empty"),
                Text("Start adding items to your Cart.")
              ],
            ),
          ),
          color: Theme.of(context).primaryColor.withOpacity(0.5)),
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
