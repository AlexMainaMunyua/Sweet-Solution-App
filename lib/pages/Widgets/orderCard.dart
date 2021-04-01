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
        Route route;

        if (counter == 0) {
          counter = counter + 1;
          route =
              MaterialPageRoute(builder: (c) => OrderDetails(orderID: orderID));
        }

        Navigator.push(context, route);
      },
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.black26, Colors.white],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp)),
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.all(10.0),
        height: itemCount * 190.0,
        child: ListView.builder(
            itemCount: itemCount,
            itemBuilder: (c, index) {
              ItemModel model = ItemModel.fromJson(data[index].data());
              return sourceInfo(model, context);
            }),
      ),
    );
  }
}

Widget sourceInfo(ItemModel model, BuildContext context, {Color background}) {
  var width = MediaQuery.of(context).size.width;

  return Container(
    height: 170.0,
    // width: width,
    color: Colors.grey,

    child: Row(
      children: [
        Image.network(
          model.thumbnailUrl,
          width: 140.0,
        ),
        SizedBox(
          width: 10.0,
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
            )
          ],
        ))
      ],
    ),
  );
}
