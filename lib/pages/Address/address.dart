import 'package:ecommerce_application/pages/Widgets/customAppBar.dart';
import 'package:flutter/material.dart';

import 'addAddress.dart';

class Address extends StatefulWidget {
  final double totalAmount;

  const Address({Key key, this.totalAmount}) : super(key: key);

  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
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
    );
  }

  noAddressCard() {
    return Card();
  }
}

class AddressCard extends StatefulWidget {
  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell();
  }
}

class KeyText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("");
  }
}
