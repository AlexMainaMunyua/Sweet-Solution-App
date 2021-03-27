import 'dart:async';

import 'package:ecommerce_application/pages/Config/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'pages/Authentication/authenication.dart';
import 'pages/myhomepage/myhomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pros Enterise',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: SplashScreen(),
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
        Route route = MaterialPageRoute(builder: (_) => AuthenticScreen());

        Navigator.pushReplacement(context, route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.black, Colors.white],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("images/welcome.png"),
              SizedBox(
                height: 20.0,
              ),
              Text("Kenya's largest fast moving good online store",
                  style: TextStyle(color: Colors.white))
            ],
          ),
        ),
      ),
    );
  }
}
