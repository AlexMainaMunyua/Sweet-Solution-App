import 'package:ecommerce_application/pages/Config/config.dart';
import 'package:ecommerce_application/pages/Counter/cartItemCounter.dart';
import 'package:ecommerce_application/pages/Model/item.dart';
import 'package:ecommerce_application/pages/Store/cart.dart';
import 'package:ecommerce_application/pages/Widgets/wideButton.dart';
import 'package:ecommerce_application/pages/myhomepage/myhomePage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  final ItemModel? itemModel;

  const ProductPage({Key? key, this.itemModel}) : super(key: key);
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  Future<bool> _onWillPop() async {
    Route route = MaterialPageRoute(builder: (c) => MyHomePage());

    Navigator.pushReplacement(context, route);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    Size screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => _onWillPop(),
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
            title: Text(
              "Product",
              style: TextStyle(
                  fontSize: 35.0, color: Colors.white, fontFamily: "Signatra"),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Route route = MaterialPageRoute(builder: (c) => MyHomePage());

                Navigator.pushReplacement(context, route);
              },
            ),
            actions: [
              Container(
                padding: EdgeInsets.only(right: 5.0, top: 5.0),
                child: Stack(children: [
                  IconButton(
                      icon: Icon(
                        Icons.shopping_cart,
                        // size: 30.0,
                        color: Colors.black26,
                      ),
                      onPressed: () {
                        Route route =
                            MaterialPageRoute(builder: (c) => CartPage());

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
                                            .getStringList(
                                                EcommerceApp.userCartList)!
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
                ]),
              )
            ],
          ),
          // drawer: MyDrawer(),
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
                            child: Image.network(widget.itemModel!.thumbnailUrl!),
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
                              widget.itemModel!.title!,
                              style: boldTextStyle,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              widget.itemModel!.longDescription!,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              "Ksh. " + widget.itemModel!.price.toString(),
                              style: boldTextStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Center(
                        child: WideButton(
                          onPressed: () {
                            checkItemInCart(
                                widget.itemModel!.productId, context);
                          },
                          msg: "ADD TO CART",
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
