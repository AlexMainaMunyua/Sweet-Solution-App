import 'package:ecommerce_application/pages/Model/item.dart';
import 'package:ecommerce_application/pages/Widgets/customAppBar.dart';
import 'package:ecommerce_application/pages/Widgets/mydrawer.dart';
import 'package:ecommerce_application/pages/myhomepage/myhomePage.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  final ItemModel itemModel;

  const ProductPage({Key key, this.itemModel}) : super(key: key);
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {


  _onWillPop(BuildContext context) {
    Route route = MaterialPageRoute(builder: (c) => MyHomePage());

    Navigator.pushReplacement(context, route);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        _onWillPop(context);
      },
      child: SafeArea(
        child: Scaffold(
          appBar: MyAppBar(),
          drawer: MyDrawer(),
          body: ListView(
            children: [
              Container(
                padding: EdgeInsets.all(15.0),
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 300.0,
                          child: Center(
                            child: Image.network(widget.itemModel.thumbnailUrl),
                          ),
                        ),
                        Container(
                          color: Colors.grey[300],
                          child: SizedBox(
                            height: 0.5,
                            width: double.infinity,
                          ),
                        )
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(20.0),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.itemModel.title,
                              style: boldTextStyle,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              widget.itemModel.longDescription,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              "Ksh. " + widget.itemModel.price.toString(),
                              style: boldTextStyle,
                            ),
                            SizedBox(
                              height: 10.0,
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            checkItemInCart(
                                widget.itemModel.shortInfo, context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [Colors.black26, Colors.white],
                                    begin: const FractionalOffset(0.0, 0.0),
                                    end: const FractionalOffset(1.0, 0.0),
                                    stops: [0.0, 1.0],
                                    tileMode: TileMode.clamp)),
                            width: MediaQuery.of(context).size.width - 40.0,
                            height: 50.0,
                            child: Center(
                              child: Text(
                                "Add to Cart",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

const boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);
