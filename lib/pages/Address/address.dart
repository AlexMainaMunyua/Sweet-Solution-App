import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_application/pages/Config/config.dart';
import 'package:ecommerce_application/pages/Counter/addressChanger.dart';
import 'package:ecommerce_application/pages/Model/address.dart';
import 'package:ecommerce_application/pages/Order/placeOrder.dart';
import 'package:ecommerce_application/pages/Store/cart.dart';
import 'package:ecommerce_application/pages/Widgets/customAppBar.dart';
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
          appBar: MyAppBar(),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Select Address",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                ),
              ),
              Consumer<AddressChanger>(builder: (context, address, c) {
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
              })
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Route route = MaterialPageRoute(builder: (c) => AddAddress());

              Navigator.pushReplacement(context, route);
            },
            label: Text("Add new address"),
            backgroundColor: Colors.black26,
            icon: Icon(Icons.add_location),
          ),
        ),
      ),
    );
  }

  noAddressCard() {
    return Card(
      color: Colors.black26.withOpacity(0.5),
      child: Container(
        height: 100.0,
        alignment: Alignment.center,
        child: Column(
          children: [
            Icon(
              Icons.add_location,
              color: Colors.white,
            ),
            Text("No shipment address has been saved"),
            Text(
                "Please add your shipment address so that we can deliver products")
          ],
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
      child: Card(
        color: Colors.black12,
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
                      padding: EdgeInsets.all(10.0),
                      width: screenWidth * 0.8,
                      child: Table(
                        children: [
                          TableRow(children: [
                            KeyText(
                              msg: "Name",
                            ),
                            Text(widget.model.name),
                          ]),
                          TableRow(children: [
                            KeyText(
                              msg: "Phone Number",
                            ),
                            Text(widget.model.phoneNumber),
                          ]),
                          TableRow(children: [
                            KeyText(
                              msg: "Flat Number",
                            ),
                            Text(widget.model.flatNumber),
                          ]),
                          TableRow(children: [
                            KeyText(
                              msg: "City",
                            ),
                            Text(widget.model.city),
                          ]),
                          TableRow(children: [
                            KeyText(
                              msg: "Pin Code",
                            ),
                            Text(widget.model.pincode),
                          ])
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
            widget.value == Provider.of<AddressChanger>(context).count
                ? WideButton(
                    msg: " Proceed",
                    onPressed: () {
                      Route route = MaterialPageRoute(
                          builder: (c) => PaymentPage(
                                addressId: widget.addressId,
                                totalAmount: widget.totalAmount,
                              ));
                      Navigator.push(context, route);
                    },
                  )
                : Container()
          ],
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
    return Text(
      msg,
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
    );
  }
}
