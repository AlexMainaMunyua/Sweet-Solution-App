import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_application/pages/Categories/chocolates/chocolatepage.dart';
import 'package:ecommerce_application/pages/Categories/flashsales/flashsales.dart';
import 'package:ecommerce_application/pages/Categories/bubblegums/gumpage.dart';
import 'package:ecommerce_application/pages/Categories/fruitdrops/fruitdroppage.dart';
import 'package:ecommerce_application/pages/Categories/lollipops/lollipoppage.dart';
import 'package:ecommerce_application/pages/Categories/toffees/toffeepage.dart';
import 'package:ecommerce_application/pages/Categories/toys/toypage.dart';
import 'package:ecommerce_application/pages/Config/config.dart';
import 'package:ecommerce_application/pages/Counter/cartItemCounter.dart';
import 'package:ecommerce_application/pages/Model/item.dart';
import 'package:ecommerce_application/pages/Store/cart.dart';
import 'package:ecommerce_application/pages/Store/productPage.dart';
import 'package:ecommerce_application/pages/Widgets/loadingWidget.dart';
import 'package:ecommerce_application/pages/Widgets/mydrawer.dart';
import 'package:ecommerce_application/pages/Widgets/searchBox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Scaffold(
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
            "Sweet Solutions",
            style: TextStyle(
                fontSize: 35.0, color: Colors.white, fontFamily: "Signatra"),
          ),
          centerTitle: true,
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
        drawer: MyDrawer(),
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(pinned: true, delegate: SearchBoxDelegate()),
            SliverToBoxAdapter(
              child: _createCarousel(),
            ),
            SliverToBoxAdapter(
              child: _createCategories(context),
            ),
            SliverToBoxAdapter(
              child: _createFlashSalesHeader(context),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("items")
                  .where("shortInfo", isEqualTo: "Flash Sales")
                  .limit(4)
                  .snapshots(),
              builder: (context, dataSnapshot) {
                return !dataSnapshot.hasData
                    ? SliverToBoxAdapter(
                        child: Center(
                          child: circularProgress(),
                        ),
                      )
                    : SliverStaggeredGrid.countBuilder(
                        crossAxisCount: 2,
                        staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                        itemBuilder: (context, index) {
                          ItemModel model = ItemModel.fromJson(
                              dataSnapshot.data!.docs[index].data()!);
                          return sourceInfo(model, context);
                        },
                        itemCount: dataSnapshot.data!.docs.length,
                      );
              },
            ),
            SliverToBoxAdapter(
              child: _createBanner(),
            ),
            SliverToBoxAdapter(
              child: _createStreamBuilderHeader(),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("items")
                  .orderBy("publishedDate", descending: false)
                  .snapshots(),
              builder: (context, dataSnapshot) {
                return !dataSnapshot.hasData
                    ? SliverToBoxAdapter(
                        child: Center(
                          child: circularProgress(),
                        ),
                      )
                    : SliverStaggeredGrid.countBuilder(
                        crossAxisCount: 2,
                        staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                        itemBuilder: (context, index) {
                          ItemModel model = ItemModel.fromJson(
                              dataSnapshot.data!.docs[index].data()!);
                          return sourceInfo(model, context);
                        },
                        itemCount: dataSnapshot.data!.docs.length,
                      );
              },
            ),
          ],
        ),
      )
    );
  }
}

Widget _createBanner() {
  return Container(
    height: 180,
    padding: EdgeInsets.all(15.0),
    child: Image(
      fit: BoxFit.cover,
      image: NetworkImage(
          "https://firebasestorage.googleapis.com/v0/b/loan-app-6d0b2.appspot.com/o/ecommerceImages%2Fbanner.jpeg?alt=media&token=d4a80868-686c-405b-b293-014f2d340f29"),
    ),
  );
}

Widget _createFlashSalesHeader(context) {
  return Container(
    padding: EdgeInsets.only(left: 5.0, right: 5.0),
    margin: EdgeInsets.only(left: 5.0, right: 5.0),
    height: 40,
    decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.black26, Colors.white],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("FLASH SALES", style: TextStyle(fontWeight: FontWeight.w700)),
        GestureDetector(
          onTap: () {
            Route route = MaterialPageRoute(builder: (context) => FlashSale());

            Navigator.pushReplacement(context, route);
          },
          child: Row(
            children: [
              Text(
                "See All",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 12,
              )
            ],
          ),
        )
      ],
    ),
  );
}

Widget _createStreamBuilderHeader() {
  return Container(
    padding: EdgeInsets.only(left: 5.0, right: 5.0),
    margin: EdgeInsets.only(left: 5.0, right: 5.0),
    height: 40,
    decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.black26, Colors.white],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Recently Added Items",
            style: TextStyle(fontWeight: FontWeight.w700)),
        Row(
          children: [],
        )
      ],
    ),
  );
}

Widget _createCategories(BuildContext context) {
  return Container(
    color: Colors.white,
    height: 100.0,
    padding: EdgeInsets.only(top: 15),
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: [
        Container(
          width: 70,
          child: GestureDetector(
            onTap: () {
              Route route = MaterialPageRoute(builder: (context) => GumPage());

              Navigator.pushReplacement(context, route);
            },
            child: Column(
              children: [
                CircleAvatar(
                  radius: 20.0,
                  backgroundImage: NetworkImage(
                      "https://firebasestorage.googleapis.com/v0/b/loan-app-6d0b2.appspot.com/o/ecommerceImages%2Fgum.jpeg?alt=media&token=69325cc3-ad9a-4280-be32-51a219022963"),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "Gums",
                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
        Container(
          width: 70,
          child: GestureDetector(
            onTap: () {
              Route route =
                  MaterialPageRoute(builder: (context) => ToffeePage());

              Navigator.pushReplacement(context, route);
            },
            child: Column(
              children: [
                CircleAvatar(
                    radius: 20.0,
                    backgroundImage: NetworkImage(
                        "https://firebasestorage.googleapis.com/v0/b/loan-app-6d0b2.appspot.com/o/ecommerceImages%2Ftoffee.jpeg?alt=media&token=2ef31932-a2fd-4d56-b7e4-538474b93827")),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "Toffees",
                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
        Container(
          width: 70,
          child: GestureDetector(
            onTap: () {
              Route route =
                  MaterialPageRoute(builder: (context) => ChocolatePage());

              Navigator.pushReplacement(context, route);
            },
            child: Column(
              children: [
                CircleAvatar(
                  radius: 20.0,
                  backgroundImage: NetworkImage(
                      "https://firebasestorage.googleapis.com/v0/b/loan-app-6d0b2.appspot.com/o/ecommerceImages%2Fchocolates.jpeg?alt=media&token=c99dd0e9-4ed8-4bfd-9c60-a2d4df3cfad0"),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "Chocolates",
                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
        Container(
          width: 70,
          child: GestureDetector(
            onTap: () {
              Route route =
                  MaterialPageRoute(builder: (context) => LollipopPage());

              Navigator.pushReplacement(context, route);
            },
            child: Column(
              children: [
                CircleAvatar(
                  radius: 20.0,
                  backgroundImage: NetworkImage(
                      "https://firebasestorage.googleapis.com/v0/b/loan-app-6d0b2.appspot.com/o/ecommerceImages%2Flollipops.jpeg?alt=media&token=bff83178-9479-4bde-a7c0-1681671702cd"),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "Lollipops",
                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
        Container(
          width: 70,
          child: GestureDetector(
            onTap: () {
              Route route =
                  MaterialPageRoute(builder: (context) => FruitDropPage());

              Navigator.pushReplacement(context, route);
            },
            child: Column(
              children: [
                CircleAvatar(
                  radius: 20.0,
                  backgroundImage: NetworkImage(
                      "https://firebasestorage.googleapis.com/v0/b/loan-app-6d0b2.appspot.com/o/ecommerceImages%2Ffruitdrops.jpeg?alt=media&token=7f3bbfb6-12d0-4e90-afcd-f1874b05a187"),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "Fruit Drops",
                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
        Container(
          width: 70,
          child: GestureDetector(
            onTap: () {
              Route route = MaterialPageRoute(builder: (context) => ToyPage());

              Navigator.pushReplacement(context, route);
            },
            child: Column(
              children: [
                CircleAvatar(
                  radius: 20.0,
                  backgroundImage: NetworkImage(
                      "https://firebasestorage.googleapis.com/v0/b/loan-app-6d0b2.appspot.com/o/ecommerceImages%2Ftoys.jpeg?alt=media&token=5799e1c5-cd24-4ef0-a35b-8b329a13912d"),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "Toys",
                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _createCarousel() {
  return Column(
    children: [
      CarouselSlider(
        items: [
          //1st Image of Slider
          Container(
            margin: EdgeInsets.only(top: 6.0, bottom: 6.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: NetworkImage(
                    "https://firebasestorage.googleapis.com/v0/b/loan-app-6d0b2.appspot.com/o/ecommerceImages%2FJumboTron%2Fjumbo1.png?alt=media&token=628b3a16-eada-48d1-a7f5-0ed3b95accf4"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          //3rd Image of Slider
          Container(
            margin: EdgeInsets.only(top: 6.0, bottom: 6.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: NetworkImage(
                    "https://firebasestorage.googleapis.com/v0/b/loan-app-6d0b2.appspot.com/o/ecommerceImages%2FJumboTron%2Fjumbo3.png?alt=media&token=35a8f8c5-8f7f-442a-ab85-c7b27644d6d7"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          //4th Image of Slider
          Container(
            margin: EdgeInsets.only(top: 6.0, bottom: 6.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: NetworkImage(
                    "https://firebasestorage.googleapis.com/v0/b/loan-app-6d0b2.appspot.com/o/ecommerceImages%2FJumboTron%2Fbanner4.png?alt=media&token=66df1029-84e7-4480-89fb-9347b356a490"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
        options: CarouselOptions(
          height: 150.0,
          enlargeCenterPage: true,
          autoPlay: true,
          aspectRatio: 16 / 9,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          viewportFraction: 0.95,
        ),
      )
    ],
  );
}

Widget sourceInfo(ItemModel model, BuildContext context,
    {Color? background, removeCartFunction}) {
  return InkWell(
    onTap: () {
      Route route =
          MaterialPageRoute(builder: (c) => ProductPage(itemModel: model));

      Navigator.pushReplacement(context, route);
    },
    splashColor: Colors.black26,
    child: Container(
      height: 190.0,
      child: Card(
        child: Container(
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Image.network(
                    model.thumbnailUrl!,
                    height: 100.0,
                    width: 120.0,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Expanded(
                      child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      model.title!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 12.0),
                    ),
                  )),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Ksh.",
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          (model.price).toString(),
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(right: 10.0, top: 10.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 30,
                    height: 20,
                    color: Colors.black12,
                    child: Center(
                        child: Text(
                      model.discount.toString()+"%",
                      style: TextStyle(fontSize: 10, color: Colors.black38),
                    )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget card({Color primaryColor = Colors.redAccent, required String imgPath}) {
  return Container(
    height: 150.0,
    // width:  width * .34,
    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
              offset: Offset(0, 5), blurRadius: 10.0, color: Colors.grey[200]!)
        ]),
    child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      child: Image.network(
        imgPath,
        height: 150.0,
        fit: BoxFit.fill,
      ),
    ),
  );
}

void checkItemInCart(String? productID, BuildContext context) {
  EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartList)!
          .contains(productID)
      ? Fluttertoast.showToast(msg: "Item already in Cart")
      : addItemToCart(productID, context);
}

addItemToCart(String? productID, BuildContext context) {
  List tempCartList =
      EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList)!;

  tempCartList.add(productID);

  print(
      EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList));

  EcommerceApp.firestore
      .collection(EcommerceApp.collectionUser)
      .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
      .update({
    EcommerceApp.userCartList: tempCartList,
  }).then((value) {
    Fluttertoast.showToast(msg: "Item Added to Cart Successfully");

    EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartList, tempCartList as List<String>);

    Provider.of<CartItemCounter>(context, listen: false).displayResult();
  });
}
