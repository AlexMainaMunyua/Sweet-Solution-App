import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_application/pages/Config/config.dart';
import 'package:ecommerce_application/pages/Counter/addressChanger.dart';
import 'package:ecommerce_application/pages/Counter/totalMoney.dart';
import 'package:ecommerce_application/pages/Model/address.dart';
import 'package:ecommerce_application/pages/Model/item.dart';
import 'package:ecommerce_application/pages/Order/placeOrder.dart';
import 'package:ecommerce_application/pages/Store/cart.dart';
import 'package:ecommerce_application/pages/Widgets/loadingWidget.dart';
import 'package:ecommerce_application/pages/Widgets/wideButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'addAddress.dart';

class Address extends StatefulWidget {
  final double totalAmount;

  const Address({Key key, this.totalAmount}) : super(key: key);

  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  double totalAmount;

  @override
  void initState() {
    super.initState();

    totalAmount = 0;

    Provider.of<TotalAmount>(context, listen: false).displayAmount(0);
  }

  _onWillPop(BuildContext context) {
    Route route = MaterialPageRoute(builder: (c) => CartPage());

    Navigator.pushReplacement(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _onWillPop(context);
      },
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
                Route route = MaterialPageRoute(builder: (c) => CartPage());

                Navigator.pushReplacement(context, route);
              },
            ),
            title: Text(
              "Check out",
              style: TextStyle(
                  fontSize: 35.0, color: Colors.white, fontFamily: "Signatra"),
            ),
          ),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  height: 50,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 15),
                            child: Text(
                              "Select Address",
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Route route = MaterialPageRoute(
                                  builder: (c) => AddAddress());

                              Navigator.pushReplacement(context, route);
                            },
                            child: Text(
                              "Add new Address",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Consumer<AddressChanger>(builder: (context, address, c) {
                  return Flexible(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: EcommerceApp.firestore
                          .collection(EcommerceApp.collectionUser)
                          .doc(EcommerceApp.sharedPreferences
                              .getString(EcommerceApp.userUID))
                          .collection(EcommerceApp.subCollectionAddress)
                          .snapshots(),
                      builder: (context, snapshot) {
                        return !snapshot.hasData
                            ? Center(
                                child: circularProgress(),
                              )
                            : snapshot.data.docs.length == 0
                                ? noAddressCard()
                                : ListView.builder(
                                    itemCount: snapshot.data.docs.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return AddressCard(
                                        currentIndex: address.count,
                                        value: index,
                                        addressId: snapshot.data.docs[index].id,
                                        totalAmount: widget.totalAmount,
                                        model: AddressModel.fromJson(
                                            snapshot.data.docs[index].data()),
                                      );
                                    },
                                  );
                      },
                    ),
                  );
                }),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 50,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 15),
                            child: Text(
                              "Order summary",
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0),
                            ),
                          ),
                          Consumer<TotalAmount>(
                              builder: (context, amountProvider, child) {
                            return Container(
                              margin: EdgeInsets.only(top: 15),
                              child: Text(
                                "Ksh.${amountProvider.totalAmount.toString()}",
                                style: TextStyle(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
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
                            ? Container()
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
                                    if (snapshot.data.docs.length - 1 ==
                                        index) {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((t) {
                                        Provider.of<TotalAmount>(context,
                                                listen: false)
                                            .displayAmount(totalAmount);
                                      });
                                    }

                                    return cartSourceInfo(model, context);
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
      ),
    );
  }

  Widget cartSourceInfo(ItemModel model, BuildContext context,
      {Color backgroud,
      removeCartFunction,
      increseItemQuantityFunction,
      decreaseItemQuantityFunction}) {
    return Container(
      color: Colors.grey.shade200,
      child: Column(
        children: [
          Container(
            height: 100.0,
            child: Container(
              child: Row(
                children: [
                  Container(
                    child: Center(
                      child: Image.network(
                        model.thumbnailUrl,
                        height: 50.0,
                        width: 80.0,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
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
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12.0),
                                )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            thickness: 1.0,
            indent: 5.0,
            endIndent: 5.0,
          )
        ],
      ),
    );
  }

  noAddressCard() {
    return Container(
      margin: EdgeInsets.only(left: 5.0, right: 5.0),
      child: Card(
        color: Colors.grey.shade300,
        child: Container(
          height: 130.0,
          alignment: Alignment.center,
          child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              Icon(
                Icons.add_location,
                color: Colors.white,
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                  child: Text("No shipment address has been saved.",
                      textAlign: TextAlign.center)),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  "Please add your shipment address so that we can deliver products.",
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AddressCard extends StatefulWidget {
  final AddressModel model;
  final int currentIndex;
  final int value;
  final String addressId;
  final double totalAmount;

  const AddressCard(
      {Key key,
      this.model,
      this.currentIndex,
      this.value,
      this.addressId,
      this.totalAmount})
      : super(key: key);

  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        Provider.of<AddressChanger>(context, listen: false)
            .displayResults(widget.value);
      },
      child: Container(
        margin: EdgeInsets.only(left: 5.0, right: 5.0),
        child: Card(
          color: Colors.grey.shade300,
          child: Column(
            children: [
              Row(
                children: [
                  Radio(
                    groupValue: widget.currentIndex,
                    value: widget.value,
                    activeColor: Colors.white,
                    onChanged: (val) {
                      Provider.of<AddressChanger>(context, listen: false)
                          .displayResults(val);
                    },
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(4.0),
                        width: screenWidth * 0.8,
                        child: Table(
                          children: [
                            TableRow(children: [
                              KeyText(
                                msg: "Name",
                              ),
                              Text(
                                widget.model.name,
                                style: TextStyle(color: Colors.black45),
                              ),
                            ]),
                            TableRow(children: [
                              KeyText(
                                msg: "Phone Number",
                              ),
                              Text(
                                widget.model.phoneNumber,
                                style: TextStyle(color: Colors.black45),
                              ),
                            ]),
                            TableRow(children: [
                              KeyText(
                                msg: "Business Name",
                              ),
                              Text(
                                widget.model.flatNumber,
                                style: TextStyle(color: Colors.black45),
                              ),
                            ]),
                            TableRow(children: [
                              KeyText(
                                msg: "Area",
                              ),
                              Text(
                                widget.model.city,
                                style: TextStyle(color: Colors.black45),
                              ),
                            ]),
                            TableRow(children: [
                              KeyText(
                                msg: "Next to",
                              ),
                              Text(
                                widget.model.state,
                                style: TextStyle(color: Colors.black45),
                              ),
                            ]),
                            TableRow(children: [
                              KeyText(
                                msg: "County",
                              ),
                              Text(
                                widget.model.pincode,
                                style: TextStyle(color: Colors.black45),
                              ),
                            ])
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
              widget.value == Provider.of<AddressChanger>(context).count
                  ? Container(
                      padding: EdgeInsets.all(20),
                      child: WideButton(
                        msg: " PROCEED",
                        onPressed: () {
                          Route route = MaterialPageRoute(
                              builder: (c) => PaymentPage(
                                    addressId: widget.addressId,
                                    totalAmount: widget.totalAmount,
                                  ));
                          Navigator.push(context, route);
                        },
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}

class KeyText extends StatelessWidget {
  final String msg;

  const KeyText({Key key, this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Text(
        msg,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
      ),
    );
  }
}
