import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_application/main.dart';
import 'package:ecommerce_application/pages/Admin/shiftOrders.dart';
import 'package:ecommerce_application/pages/Widgets/loadingWidget.dart';
import 'package:ecommerce_application/pages/Widgets/wideButton.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>
    with AutomaticKeepAliveClientMixin<UploadPage> {
  bool get wantKeepAlive => true;

  File? file;

  TextEditingController _descriptionTextEditingController =
      TextEditingController();
  TextEditingController _priceTextEditingController = TextEditingController();
  TextEditingController _titleTextEditingController = TextEditingController();
  TextEditingController _shortTextEditingController = TextEditingController();
  TextEditingController _productIdTextEditingController =
      TextEditingController();
  TextEditingController _discont = TextEditingController();

  String productId = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false;

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return file == null
        ? displayAdminHomeScreen()
        : displayAdminUploadFormScreen();
  }



  displayAdminHomeScreen() {
    return Scaffold(
      body: getAdminHomeScreenBody(),
    );
  }

  getAdminHomeScreenBody() {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              height: 70,
              child: Align(
                alignment: Alignment.center,
                child: Text("Admin dashboad",
                    style: TextStyle(
                        fontSize: 45.0,
                        color: Colors.grey.shade500,
                        fontFamily: "Signatra")),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Icon(Icons.shop_two, color: Colors.grey.shade400, size: 200.0),
            Padding(
                padding: EdgeInsets.only(
                  top: 20.0,
                ),
                child: WideButton(
                    onPressed: () {
                      takeImage(context);
                    },
                    msg: "Add New Items")),
            Padding(
                padding: EdgeInsets.only(
                  top: 20.0,
                ),
                child: WideButton(
                    onPressed: () {
                      Route route =
                          MaterialPageRoute(builder: (c) => AdminShiftOrders());

                      Navigator.pushReplacement(context, route);
                    },
                    msg: "View Available Orders")),
            Padding(
                padding: EdgeInsets.only(
                  top: 20.0,
                ),
                child: WideButton(
                    onPressed: () {
                      Route route =
                          MaterialPageRoute(builder: (c) => SplashScreen());

                      Navigator.pushReplacement(context, route);
                    },
                    msg: "LOGOUT"))
          ],
        ),
      ),
    );
  }

  takeImage(mContext) {
    return showDialog(
        context: mContext,
        builder: (con) {
          return SimpleDialog(
            title: Text(
              "Item Image",
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  capturePhotowithCamera();
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.photo_camera,
                      color: Colors.black26,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Capture with Camera",
                      style: TextStyle(),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  pickPhotofromGallary();
                },
                child: Row(
                  children: [
                    Icon(Icons.photo_album, color: Colors.black26),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Select from Gallery",
                      style: TextStyle(),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.cancel,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      " Cancel",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }

  capturePhotowithCamera() async {
    Navigator.pop(context);

    final picker = ImagePicker();

    final imageFile = await picker.getImage(
        source: ImageSource.camera, maxHeight: 680.0, maxWidth: 970.0);

    setState(() {
      if (imageFile != null) {
        file = File(imageFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  pickPhotofromGallary() async {
    Navigator.pop(context);

    final picker = ImagePicker();

    final imageFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (imageFile != null) {
        file = File(imageFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  displayAdminUploadFormScreen() {
    return Scaffold(
      appBar: AppBar(
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
          "New Product",
          style: TextStyle(
              fontFamily: "Signatra",
              color: Colors.white,
              fontSize: 30.0,
              fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            clearFormInfo();
          },
        ),
      ),
      body: ListView(
        children: [
          uploading ? circularProgress() : Text(""),
          Container(
            height: 230.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: FileImage(file!), fit: BoxFit.cover)),
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 12.0)),
          ListTile(
            title: Container(
                width: 250.0,
                child: TextField(
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.black26),
                      hintText: "Product Id"),
                  controller: _productIdTextEditingController,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                )),
            leading: Icon(
              Icons.card_membership,
              color: Colors.black45,
            ),
          ),
          Divider(
            color: Colors.black26,
          ),
          ListTile(
            title: Container(
                width: 250.0,
                child: TextField(
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.black26),
                      hintText: "Short info"),
                  controller: _shortTextEditingController,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                )),
            leading: Icon(
              Icons.perm_device_information,
              color: Colors.black45,
            ),
          ),
          Divider(
            color: Colors.black26,
          ),
          ListTile(
            title: Container(
                width: 250.0,
                child: TextField(
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.black26),
                      hintText: "Title"),
                  controller: _titleTextEditingController,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                )),
            leading: Icon(
              Icons.title,
              color: Colors.black45,
            ),
          ),
          Divider(
            color: Colors.black26,
          ),
          ListTile(
            title: Container(
                width: 250.0,
                child: TextField(
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.black26),
                      hintText: "Description"),
                  controller: _descriptionTextEditingController,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                )),
            leading: Icon(
              Icons.description,
              color: Colors.black45,
            ),
          ),
          Divider(
            color: Colors.black26,
          ),
          ListTile(
            title: Container(
                width: 250.0,
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.black26),
                      hintText: "Price"),
                  controller: _priceTextEditingController,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                )),
            leading: Icon(
              Icons.money,
              color: Colors.black45,
            ),
          ),
          Divider(
            color: Colors.black26,
          ),
          ListTile(
            title: Container(
                width: 250.0,
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.black26),
                      hintText: "Discount"),
                  controller: _discont,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                )),
            leading: Icon(
              Icons.disc_full_outlined,
              color: Colors.black45,
            ),
          ),
          Divider(
            color: Colors.black26,
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              WideButton(
                onPressed: () {
                  // ignore: unnecessary_statements
                  uploading ? null : uploadImageAndSaveItemInfo();
                },
                msg: "Add Item",
              ),
            ],
          )
        ],
      ),
    );
  }

  clearFormInfo() {
    setState(() {
      file = null;
      _productIdTextEditingController.clear();
      _descriptionTextEditingController.clear();
      _priceTextEditingController.clear();
      _shortTextEditingController.clear();
      _titleTextEditingController.clear();
      _discont.clear();
    });
  }

  uploadFlashImageAndSaveItemInfo() async {
    setState(() {
      uploading = true;
    });
    String imageDownloadUrl = await uploadFlashItemImage(file);

    saveFlashItemInfo(imageDownloadUrl);
  }

  Future<String> uploadFlashItemImage(mFileImage) async {
    final Reference storageReference =
        FirebaseStorage.instance.ref().child("flash");

    TaskSnapshot taskSnapshot = await storageReference
        .child("product_$productId.jpg")
        .putFile(mFileImage);

    var downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  saveFlashItemInfo(String downloadUrl) {
    final itemsRef = FirebaseFirestore.instance.collection("flash");

    itemsRef.doc(productId).set({
      "shortInfo": _shortTextEditingController.text.trim(),
      "longDescription": _descriptionTextEditingController.text.trim(),
      "title": _titleTextEditingController.text.trim(),
      "productId": _productIdTextEditingController.text.trim(),
      "discount": int.parse(_discont.text),
      "publishedDate": DateTime.now(),
      "price": int.parse(_priceTextEditingController.text),
      "thumbnailUrl": downloadUrl,
      "status": "available",
    });
    setState(() {
      file = null;
      uploading = false;
      productId = DateTime.now().microsecondsSinceEpoch.toString();
      _descriptionTextEditingController.clear();
      _titleTextEditingController.clear();
      _discont.clear();
      _productIdTextEditingController.clear();
      _shortTextEditingController.clear();
      _priceTextEditingController.clear();
    });
  }

  uploadImageAndSaveItemInfo() async {
    setState(() {
      uploading = true;
    });
    String imageDownloadUrl = await uploadItemImage(file);

    saveItemInfo(imageDownloadUrl);
  }

  Future<String> uploadItemImage(mFileImage) async {
    final Reference storageReference =
        FirebaseStorage.instance.ref().child("Items");

    TaskSnapshot taskSnapshot = await storageReference
        .child("product_$productId.jpg")
        .putFile(mFileImage);

    var downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  saveItemInfo(String downloadUrl) {
    final itemsRef = FirebaseFirestore.instance.collection("items");

    itemsRef.doc(productId).set({
      "shortInfo": _shortTextEditingController.text.trim(),
      "longDescription": _descriptionTextEditingController.text.trim(),
      "title": _titleTextEditingController.text.trim(),
      "discount": int.parse(_discont.text),
      "productId": _productIdTextEditingController.text.trim(),
      "publishedDate": DateTime.now(),
      "price": int.parse(_priceTextEditingController.text),
      "thumbnailUrl": downloadUrl,
      "status": "available",
    });
    setState(() {
      file = null;
      uploading = false;
      productId = DateTime.now().microsecondsSinceEpoch.toString();
      _descriptionTextEditingController.clear();
      _titleTextEditingController.clear();
      _shortTextEditingController.clear();
      _discont.clear();
      _productIdTextEditingController.clear();
      _priceTextEditingController.clear();
    });
  }
}
