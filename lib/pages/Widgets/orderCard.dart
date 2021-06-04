import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_application/pages/Model/item.dart';
import 'package:ecommerce_application/pages/Order/orderDetailsPage.dart';
import 'package:flutter/material.dart';

int counter = 0;

class OrderCard extends StatelessWidget {
  final int itemCount;
  final List<DocumentSnapshot> data;
  final String orderID;

  const OrderCard({Key key, this.itemCount, this.data, this.orderID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Route route = MaterialPageRoute(
            builder: (c) => OrderDetails(
                  orderID: orderID,
                ));

        Navigator.push(context, route);
      },
      child: Container(
        padding:
            EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 20),
        color: Colors.grey.shade200,
        margin: EdgeInsets.only(top: 10.0, left: 30.0, right: 30.0, bottom: 20),
        height: itemCount * 120.0,
        child: ListView.builder(
            itemCount: itemCount,
            itemBuilder: (c, index) {
              ItemModel model = ItemModel.fromJson(data[index].data());
              return Column(
                children: [
                  sourceInfo(model, context),
                ],
              );
            }),
      ),
    );
  }
}

Widget sourceInfo(ItemModel model, BuildContext context, {Color background}) {
  // ignore: unused_local_variable
  var width = MediaQuery.of(context).size.width;

  return Container(
    height: 100.0,
    // width: width,
    color: Colors.grey.shade200,

    child: Row(
      children: [
        Image.network(
          model.thumbnailUrl,
          width: 100.0,
          height: 60,
        ),
        // SizedBox(
        //   width: 10.0,
        // ),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: Row(
                        children: [
                          Text(
                            "Total price: Ksh.",
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
            Divider(
              height: 5.0,
              color: Colors.black26,
            ),
          ],
        ))
      ],
    ),
  );
}
