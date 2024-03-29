import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:ecommerce_application/main.dart';
import 'package:ecommerce_application/pages/Admin/adminSignInPage.dart';
import 'package:ecommerce_application/pages/Config/config.dart';
import 'package:ecommerce_application/pages/myhomepage/myhomePage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:firebase_auth/firebase_auth.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;

  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  late StreamController<ErrorAnimationType> errorController;

  FirebaseAuth _auth = FirebaseAuth.instance;

  late String verificationId;

  String currentText = "";

  bool showLoading = false;

  bool hasError = false;

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();

    super.initState();
  }

  @override
  void dispose() {
    errorController.close();

    super.dispose();
  }

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });

    try {
      User? firebaseUser;

      await _auth
          .signInWithCredential(phoneAuthCredential)
          .then((value) => firebaseUser = value.user);
      setState(() {
        showLoading = false;
      });

      final QuerySnapshot result =
          await FirebaseFirestore.instance.collection("userPhone").get();

      final List<DocumentSnapshot> documents = result.docs;

      if ((documents.singleWhereOrNull(
              (element) => element.id.toString() == firebaseUser!.uid)) !=
          null) {
        readData(firebaseUser!).then((value) {
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SplashScreen()));
        });
      } else {
        saveUserInfoToFirestore(firebaseUser!).then((value) {
          readData(firebaseUser!).then((value) {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SplashScreen()));
          });
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });

      _scaffoldKey.currentState!
          // ignore: deprecated_member_use
          .showSnackBar(SnackBar(content: Text(e.message!)));
    }
  }

  Future readData(User user) async {
    FirebaseFirestore.instance
        .collection("userPhone")
        .doc(user.uid)
        .get()
        .then((dataSnapshot) async {
      await SweetSolution.sharedPreferences.setString(
          SweetSolution.userUID, dataSnapshot.data()![SweetSolution.userUID]);
      await SweetSolution.sharedPreferences.setString(SweetSolution.phoneNumber,
          dataSnapshot.data()![SweetSolution.phoneNumber]);

      List<String> cartList =
          dataSnapshot.data()![SweetSolution.userCartList].cast<String>();
      await SweetSolution.sharedPreferences
          .setStringList(SweetSolution.userCartList, cartList);
    });
  }

  Future saveUserInfoToFirestore(User user) async {
    FirebaseFirestore.instance.collection("userPhone").doc(user.uid).set({
      "uid": user.uid,
      "Phone": user.phoneNumber,
      SweetSolution.userCartList: ["garbageValue"]
    });
    await SweetSolution.sharedPreferences
        .setString(SweetSolution.userUID, user.uid);
    await SweetSolution.sharedPreferences
        .setString(SweetSolution.userUID, user.phoneNumber!);
    await SweetSolution.sharedPreferences
        .setStringList(SweetSolution.userCartList, ["garbageValue"]);
  }

  getMobileFormWidget(context) {
    return Column(
      children: [
        SizedBox(
          height: 30,
        ),
        Center(
          child: Text(
            "Enter Phone No.",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          padding: EdgeInsets.only(left: 10),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text("Digit (0-9,+) 10 - 13",
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 11), 
            ),
          ),
        ),       
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.all(8.0),
          child: TextField(
            keyboardType: TextInputType.number,
            controller: phoneController,
            decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.phone,
                  color: Theme.of(context).primaryColor,
                ),
                focusColor: Theme.of(context).primaryColor,
                hintText: "XXXXXXXXXX",
                hintStyle: TextStyle(color: Colors.grey.shade300)),
          ),
        ),
        SizedBox(
          height: 40,
        ),
        MaterialButton(
          onPressed: () async {
            setState(() {
              showLoading = true;
            });

            await _auth.verifyPhoneNumber(
              phoneNumber: setPhoneNumber(phoneController.text),
              verificationCompleted: (phoneAuthCredential) async {
                setState(() {
                  showLoading = false;
                });
              },
              verificationFailed: (verificationFailed) async {
                setState(() {
                  showLoading = false;
                });
                // ignore: deprecated_member_use
                _scaffoldKey.currentState!.showSnackBar(
                    SnackBar(content: Text(verificationFailed.message!)));
              },
              codeSent: (verificationId, resendingToken) async {
                setState(() {
                  showLoading = false;
                  currentState = MobileVerificationState.SHOW_OTP_FORM_STATE;
                  this.verificationId = verificationId;
                });
              },
              codeAutoRetrievalTimeout: (verificationId) async {},
            );
          },
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(30)),
              height: 50,
              width: MediaQuery.of(context).size.width * 0.65,
              child: Center(
                  child: Text("SUBMIT",
                      style: TextStyle(fontWeight: FontWeight.bold)))),
          // color: Colors.blue,
          textColor: Colors.white,
        ),
        Spacer(),
      ],
    );
  }

  getOtpFormWidget(context) {
    return ListView(
      children: [
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
              child: Text(
            "We have texted OTP(One Time Pin) to your registed cell phone number."
            "  Please check and enter OTP below to verify your Sweets Solutions account.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          )),
        ),
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 30.0, left: 30.0),
          child: Form(
              key: formKey,
              child: PinCodeTextField(
                appContext: context,
                length: 6,
                autoDisposeControllers: false,
                onChanged: (String value) {
                  setState(() {
                    currentText = value;
                  });
                },
                enablePinAutofill: true,
                // errorAnimationController: errorController,
                controller: otpController,
                // enableActiveFill: true,
                keyboardType: TextInputType.number,
              )),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Didn't receive the code? ",
              style: TextStyle(color: Colors.black54, fontSize: 15),
            ),
            TextButton(
                onPressed: () {},
                child: Text(
                  "RESEND",
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ))
          ],
        ),
        SizedBox(
          height: 16,
        ),
        MaterialButton(
          onPressed: () async {
            PhoneAuthCredential phoneAuthCredential =
                PhoneAuthProvider.credential(
                    verificationId: verificationId,
                    smsCode: otpController.text);

            signInWithPhoneAuthCredential(phoneAuthCredential);
          },
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(30)),
              height: 50,
              width: MediaQuery.of(context).size.width * 0.65,
              child: Center(child: Text("VERIFY"))),
          textColor: Colors.white,
        ),
      ],
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
            "Sweets Solutions",
            style: TextStyle(
                fontSize: 35.0, color: Colors.white, fontFamily: "Signatra"),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                // Navigator.of(context).pop();
                exit(0);
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                    child: Text(
                  "Exit",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                )),
              ),
            )
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   child: Icon(
        //     Icons.dashboard,
        //     color: Colors.white,
        //   ),
        //   onPressed: () => Navigator.push(context,
        //       MaterialPageRoute(builder: (context) => AdminSignInPage())),
        // ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: showLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
                  ? getMobileFormWidget(context)
                  : getOtpFormWidget(context),
        ));
  }

  // A function that will allow user to enter local phone number that starts with zero.
  setPhoneNumber(String number) {
    if (number.startsWith("0") && number.length == 10) {
      var phoneNumber = number.substring(1);
      phoneNumber = "+254" + phoneNumber;
      return phoneNumber;
    } else if (number.startsWith("+254") && number.length == 12) {
      return number;
    } else {
      Fluttertoast.showToast(msg: "Number must be 10 digits or start with +254");
    }
  }
}
