import 'package:ecommerce_application/pages/Address/address.dart';
import 'package:ecommerce_application/pages/Config/config.dart';
import 'package:ecommerce_application/pages/Counter/cartItemCounter.dart';
import 'package:ecommerce_application/pages/Model/address.dart';
import 'package:ecommerce_application/pages/Store/cart.dart';
import 'package:ecommerce_application/pages/Widgets/wideButton.dart';
import 'package:ecommerce_application/pages/myhomepage/myhomePage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddAddress extends StatefulWidget {
  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final formKey = GlobalKey<FormState>();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final cName = TextEditingController();

  final cPhoneNumber = TextEditingController();

  final cFlatHomeNumber = TextEditingController();

  final cCity = TextEditingController();

  final cState = TextEditingController();

  final cPinCode = TextEditingController();

  Future<bool> _onWillPop() async {
    Route route = MaterialPageRoute(builder: (c) => Address());

    Navigator.pushReplacement(context, route);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: SafeArea(
        child: Scaffold(
          key: scaffoldKey,
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
            actions: [
              Container(
                padding: EdgeInsets.only(right: 5.0, top: 5.0),
                child: Stack(children: [
                  IconButton(
                      icon: Icon(
                        Icons.shopping_cart,
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
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Route route = MaterialPageRoute(builder: (c) => MyHomePage());

                Navigator.pushReplacement(context, route);
              },
            ),
            title: Text(
              "Location",
              style: TextStyle(
                  fontSize: 35.0, color: Colors.white, fontFamily: "Signatra"),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 45,
                  color: Colors.grey.shade300,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text(
                              "Add new Address",
                              style: TextStyle(
                                  color: Colors.black38,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0),
                            ),
                          ),
                          Text(
                            "All fields required*",
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 10.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Form(
                    key: formKey,
                    child: Column(
                      children: [
                        MyTextField(
                          hint: "Full name",
                          textEditingController: cName,
                          textCapitalization: TextCapitalization.words,
                        ),
                        MyTextField(
                          hint: "Phone Number",
                          textEditingController: cPhoneNumber,
                          textCapitalization: TextCapitalization.words,
                          keyboardType: TextInputType.number,
                        ),
                        MyTextField(
                          hint: "Business/shop name",
                          textEditingController: cFlatHomeNumber,
                          textCapitalization: TextCapitalization.words,
                        ),
                        MyTextField(
                          hint: "Area",
                          textEditingController: cCity,
                          textCapitalization: TextCapitalization.words,
                        ),
                        MyTextField(
                          hint: "Next to",
                          textEditingController: cState,
                          textCapitalization: TextCapitalization.words,
                        ),
                        MyTextField(
                          hint: "County",
                          textEditingController: cPinCode,
                          textCapitalization: TextCapitalization.words,
                        ),
                      ],
                    )),
                WideButton(
                  msg: "SAVE DETAILS",
                  // key: formKey,
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      final model = AddressModel(
                        name: cName.text.trim(),
                        state: cState.text.trim(),
                        pincode: cPinCode.text.trim(),
                        phoneNumber: cPhoneNumber.text,
                        flatNumber: cFlatHomeNumber.text,
                        city: cCity.text.trim(),
                      ).toJson();

                      SweetSolution.firestore
                          .collection(SweetSolution.collectionUser)
                          .doc(SweetSolution.sharedPreferences
                              .getString(SweetSolution.userUID))
                          .collection(SweetSolution.subCollectionAddress)
                          .doc(DateTime.now().millisecondsSinceEpoch.toString())
                          .set(model)
                          .then((value) {
                        final snack = SnackBar(
                          content: Text("New Address added successfully."),
                        );
                        // ignore: deprecated_member_use
                        scaffoldKey.currentState!.showSnackBar(snack);
                        FocusScope.of(context).requestFocus(FocusNode());

                        formKey.currentState!.reset();
                      });

                      Route route =
                          MaterialPageRoute(builder: (c) => MyHomePage());

                      Navigator.pushReplacement(context, route);
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final String? hint;
  final TextEditingController? textEditingController;
  final TextCapitalization? textCapitalization;
  final TextInputType? keyboardType;

  const MyTextField(
      {Key? key,
      this.hint,
      this.textEditingController,
      this.textCapitalization,
      this.keyboardType})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0, bottom: 20.0),
      child: TextFormField(
        controller: textEditingController,
        textCapitalization: textCapitalization!,
        keyboardType: keyboardType,
        decoration: InputDecoration.collapsed(
            border: UnderlineInputBorder(),
            hintText: hint,
            hintStyle: TextStyle(color: Colors.black38)),
        validator: (val) => val!.isEmpty ? "Field cannot be empty." : null,
      ),
    );
  }
}
