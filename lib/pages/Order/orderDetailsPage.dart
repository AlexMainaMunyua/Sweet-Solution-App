import 'package:flutter/material.dart';

String getOrderId = "";

class OrderDetails extends StatelessWidget {
  final String orderID;

  const OrderDetails({Key key, this.orderID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(),
    );
  }
}

class StatusBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class PaymentDetailsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ShippingDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column();
  }
}

class KeyText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("");
  }
}
