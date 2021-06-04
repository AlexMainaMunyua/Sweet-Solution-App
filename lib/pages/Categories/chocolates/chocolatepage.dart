import 'package:ecommerce_application/pages/Categories/chocolates/widgets/allchocolates.dart';
import 'package:ecommerce_application/pages/Config/config.dart';
import 'package:ecommerce_application/pages/Counter/cartItemCounter.dart';
import 'package:ecommerce_application/pages/Store/cart.dart';
import 'package:ecommerce_application/pages/myhomepage/myhomePage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChocolatePage extends StatelessWidget {
  _onWillPop(BuildContext context) {
    Route route = MaterialPageRoute(builder: (c) => MyHomePage());

    Navigator.pushReplacement(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        _onWillPop(context);
      },
      child: DefaultTabController(
        length: 1,
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
                Route route = MaterialPageRoute(builder: (c) => MyHomePage());

                Navigator.pushReplacement(context, route);
              },
            ),
            title: Text(
              "Chocolates",
              style: TextStyle(
                  fontSize: 35.0, color: Colors.white, fontFamily: "Signatra"),
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
                                                EcommerceApp.userCartList)
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
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(40),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TabBar(
                  isScrollable: true,
                  indicator: UnderlineTabIndicator(
                      borderSide:
                          BorderSide(width: 4, color: Colors.grey.shade700),
                      insets:
                          EdgeInsets.only(left: 0, right: 4.0, bottom: 0.0)),

                  tabs: [
                    Tab(
                      child: Text(
                        "All Chocolates",
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: "Signatra",
                            color: Colors.white,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              Center(
                child: AllChocolates(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
