import 'package:ecommerce_application/pages/Config/config.dart';
import 'package:ecommerce_application/pages/Counter/cartItemCounter.dart';
import 'package:ecommerce_application/pages/Store/cart.dart';
import 'package:ecommerce_application/pages/myhomepage/myhomePage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  final PreferredSizeWidget? bottom;
  MyAppBar({this.bottom});

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
        "Sweet Solutions",
        style: TextStyle(
            fontSize: 35.0, color: Colors.white, fontFamily: "Signatra"),
      ),
      bottom: bottom,
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
                  Route route = MaterialPageRoute(builder: (c) => CartPage());

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
                          (SweetSolution.sharedPreferences
                                      .getStringList(
                                          SweetSolution.userCartList)!
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
    );
  }

  Size get preferredSize => bottom == null
      ? Size(56, AppBar().preferredSize.height)
      : Size(56, 80 + AppBar().preferredSize.height);
}
