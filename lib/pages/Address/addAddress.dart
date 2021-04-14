import 'package:ecommerce_application/pages/Address/address.dart';
import 'package:ecommerce_application/pages/Config/config.dart';
import 'package:ecommerce_application/pages/Model/address.dart';
import 'package:ecommerce_application/pages/Widgets/customAppBar.dart';
import 'package:ecommerce_application/pages/Widgets/wideButton.dart';
import 'package:ecommerce_application/pages/myhomepage/myhomePage.dart';
import 'package:flutter/material.dart';

class AddAddress extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final cName = TextEditingController();
  final cPhoneNumber = TextEditingController();
  final cFlatHomeNumber = TextEditingController();
  final cCity = TextEditingController();
  final cState = TextEditingController();
  final cPinCode = TextEditingController();

  _onWillPop(BuildContext context) {
    Route route = MaterialPageRoute(builder: (c) => Address());

    Navigator.pushReplacement(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _onWillPop(context);
      },
      child: SafeArea(
        child: Scaffold(
          key: scaffoldKey,
          appBar: MyAppBar(),
       
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Colors.grey.shade300,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Add new Address",
                            style: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0),
                          ),
                          Text(
                            "All fields required",
                            style: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.bold,
                                fontSize: 13.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Form(
                    key: formKey,
                    child: Column(
                      children: [
                        MyTextField(
                          hint: "Name",
                          textEditingController: cName,
                        ),
                        MyTextField(
                          hint: "Phone number",
                          textEditingController: cPhoneNumber,
                        ),
                        MyTextField(
                          hint: "Flat number / House Number",
                          textEditingController: cFlatHomeNumber,
                        ),
                        MyTextField(
                          hint: "City",
                          textEditingController: cCity,
                        ),
                        MyTextField(
                          hint: "State / Country",
                          textEditingController: cState,
                        ),
                        MyTextField(
                          hint: "Pin Code",
                          textEditingController: cPinCode,
                        ),
                      ],
                    )),
                WideButton(
                  msg: "Save",
                  // key: formKey,
                  onPressed: () {
                    if (formKey.currentState.validate()) {
                      final model = AddressModel(
                        name: cName.text.trim(),
                        state: cState.text.trim(),
                        pincode: cPinCode.text.trim(),
                        phoneNumber: cPhoneNumber.text,
                        flatNumber: cFlatHomeNumber.text,
                        city: cCity.text.trim(),
                      ).toJson();

                      EcommerceApp.firestore
                          .collection(EcommerceApp.collectionUser)
                          .doc(EcommerceApp.sharedPreferences
                              .getString(EcommerceApp.userUID))
                          .collection(EcommerceApp.subCollectionAddress)
                          .doc(DateTime.now().millisecondsSinceEpoch.toString())
                          .set(model)
                          .then((value) {
                        final snack = SnackBar(
                          content: Text("New Address added successfully."),
                        );
                        scaffoldKey.currentState.showSnackBar(snack);
                        FocusScope.of(context).requestFocus(FocusNode());

                        formKey.currentState.reset();
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
  final String hint;
  final TextEditingController textEditingController;

  const MyTextField({Key key, this.hint, this.textEditingController})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: TextFormField(
        
        controller: textEditingController,
        decoration: InputDecoration.collapsed(
            border: UnderlineInputBorder(),
            hintText: hint,
            hintStyle: TextStyle(color: Colors.black38)),
        validator: (val) => val.isEmpty ? "Field cannot be empty." : null,
      ),
    );
  }
}
