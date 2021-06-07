import 'package:ecommerce_application/main.dart';
import 'package:ecommerce_application/pages/Address/addAddress.dart';
import 'package:ecommerce_application/pages/Config/config.dart';
import 'package:ecommerce_application/pages/Order/myOder.dart';
import 'package:ecommerce_application/pages/Store/cart.dart';
import 'package:ecommerce_application/pages/Store/search.dart';
import 'package:ecommerce_application/pages/myhomepage/myhomePage.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(
              top: 25.0,
              bottom: 10.0,
            ),
            // color: Colors.grey.shade500,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.black26, Colors.white],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0, left: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Material(
                      borderRadius: BorderRadius.all(Radius.circular(80.0)),
                      elevation: 8.0,
                      child: Container(
                        height: 70.0,
                        width: 70.0,
                        child: CircleAvatar(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0, left: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      EcommerceApp.sharedPreferences
                          .getString(EcommerceApp.phoneNumber),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 12.0,
          ),
          Container(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.home,
                    color: Colors.black45,
                  ),
                  title: Text(
                    "Home",
                    style: TextStyle(color: Colors.black45),
                  ),
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (c) => MyHomePage());

                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(
                  height: 0.1,
                  color: Colors.black45,
                  // thickness: 6.0,
                ),

                ///////////////////////////////////////////////////////////////////////
                ListTile(
                  leading: Icon(
                    Icons.reorder,
                    color: Colors.black45,
                  ),
                  title: Text(
                    "My Orders",
                    style: TextStyle(color: Colors.black45),
                  ),
                  onTap: () {
                    Route route = MaterialPageRoute(builder: (c) => MyOrders());

                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(
                  height: 0.1,
                  color: Colors.black45,
                  // thickness: 6.0,
                ),
                ListTile(
                  leading: Icon(
                    Icons.shopping_cart,
                    color: Colors.black45,
                  ),
                  title: Text(
                    "My Cart",
                    style: TextStyle(color: Colors.black45),
                  ),
                  onTap: () {
                    Route route = MaterialPageRoute(builder: (c) => CartPage());

                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(
                  height: 0.1,
                  color: Colors.black45,
                  // thickness: 6.0,
                ),
                ListTile(
                  leading: Icon(
                    Icons.search,
                    color: Colors.black45,
                  ),
                  title: Text(
                    "Search",
                    style: TextStyle(color: Colors.black45),
                  ),
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (c) => SearchProduct());

                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(
                  height: 0.1,
                  color: Colors.black45,
                  // thickness: 6.0,
                ),
                ListTile(
                  leading: Icon(
                    Icons.add_location,
                    color: Colors.black45,
                  ),
                  title: Text(
                    "Add New Address",
                    style: TextStyle(color: Colors.black45),
                  ),
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (c) => AddAddress());

                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(
                  height: 0.1,
                  color: Colors.black45,
                  // thickness: 6.0,
                ),

                ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Colors.black45,
                  ),
                  title: Text(
                    "Logout",
                    style: TextStyle(color: Colors.black45),
                  ),
                  onTap: () {
                    EcommerceApp.auth.signOut().then((value) {
                      Route route =
                          MaterialPageRoute(builder: (c) => SplashScreen());

                      Navigator.pushReplacement(context, route);
                    });
                  },
                ),
                Divider(
                  height: 0.1,
                  color: Colors.black45,
                  // thickness: 6.0,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
