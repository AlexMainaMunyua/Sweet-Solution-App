import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ecommerce_application/pages/Authentication/loginwithphone.dart';
import 'package:ecommerce_application/pages/Config/config.dart';
import 'package:ecommerce_application/pages/Counter/addressChanger.dart';
import 'package:ecommerce_application/pages/Counter/cartItemCounter.dart';
import 'package:ecommerce_application/pages/Counter/itemQuantity.dart';
import 'package:ecommerce_application/pages/Counter/totalMoney.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

import 'pages/myhomepage/myhomePage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  EcommerceApp.auth = FirebaseAuth.instance;

  EcommerceApp.sharedPreferences = await SharedPreferences.getInstance();

  EcommerceApp.firestore = FirebaseFirestore.instance;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (c) => CartItemCounter()),
        ChangeNotifierProvider(create: (c) => ItemQuantity()),
        ChangeNotifierProvider(create: (c) => AddressChanger()),
        ChangeNotifierProvider(create: (c) => TotalAmount()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sweet solutions',
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
        home: SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    displaySplash();
  }

  displaySplash() {
    Timer(Duration(seconds: 5), () async {
      if (EcommerceApp.auth?.currentUser != null) {
        Route route = MaterialPageRoute(builder: (_) => MyHomePage());

        Navigator.pushReplacement(context, route);
      } else {
        Route route = MaterialPageRoute(builder: (_) => LoginScreen());

        Navigator.pushReplacement(context, route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                  alignment: Alignment.center,
                  child: const SpinKitRipple(color: Colors.red,size: 100,)),
              SizedBox(
                height: 30,
              ),
              Center(
                child: Text("Fast Delivery, Low Prices, Vast Selection",
                    style: TextStyle(
                        fontFamily: "Signatra",
                        fontSize: 24,
                        color: Colors.black45)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
