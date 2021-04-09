import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Are you sure?"),
              content: Text("Do you want to exit the application."),
              actions: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(false),
                  child: Text(
                    "No",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                SizedBox(width: 30.0, height: 30),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(true),
                  child: Text(
                    "Yes",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                SizedBox(width: 10.0),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
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
            "Cady",
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
        ),
        drawer: MyDrawer(),
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(pinned: true, delegate: SearchBoxDelegate()),
            SliverToBoxAdapter(
              child: _createCarousel(),
            ),
            SliverToBoxAdapter(
              child: _createCategories(),
            ),
            SliverToBoxAdapter(
              child: _createFlashSalesHeader(),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("items")
                  .limit(4)
                  .orderBy("publishedDate", descending: true)
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
                              dataSnapshot.data.docs[index].data());
                          return sourceInfo(model, context);
                        },
                        itemCount: dataSnapshot.data.docs.length,
                      );
              },
            ),
            SliverToBoxAdapter(
              child: _createBanner(),
            ),
            // SliverToBoxAdapter(
            //   child: _createOfficialBrands(),
            // ),
            SliverToBoxAdapter(
              child: _createStreamBuilderHeader(),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("items")
                  .limit(15)
                  .orderBy("publishedDate", descending: true)
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
                              dataSnapshot.data.docs[index].data());
                          return sourceInfo(model, context);
                        },
                        itemCount: dataSnapshot.data.docs.length,
                      );
              },
            )
          ],
        ),
      )),
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
          "https://images.unsplash.com/photo-1519087318609-bfb5c04c27f5?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&auto=format&fit=crop&w=1350&q=80"),
    ),
  );
}

// Widget _createOfficialBrands() {
//   return Container(
//     padding: EdgeInsets.only(right:15.0, left: 15.0, bottom: 15.0),
//     child: Column(
//       children: [
//         Container(
//           height: 40.0,
//           padding: EdgeInsets.all(8.0),
//           decoration: BoxDecoration(
//               gradient: LinearGradient(
//                   colors: [Colors.black26, Colors.white],
//                   begin: const FractionalOffset(0.0, 0.0),
//                   end: const FractionalOffset(1.0, 0.0),
//                   stops: [0.0, 1.0],
//                   tileMode: TileMode.clamp)),
//           child: Center(
//             child: Align(alignment: Alignment.centerLeft,
//                           child: Text(
//                 "OFFICIAL BRANDS",
//                 style: TextStyle(color: Colors.black54),
//               ),
//             ),
//           ),
//         )
//       ],
//     ),
//   );
// }

Widget _createFlashSalesHeader() {
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
        Row(
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
        )
      ],
    ),
  );
}

Widget _createCategories() {
  return Container(
    color: Colors.white,
    height: 100.0,
    padding: EdgeInsets.only(top: 15),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          child: Column(
            children: [
              CircleAvatar(
                radius: 20.0,
                backgroundImage: NetworkImage(
                    "https://images.unsplash.com/photo-1576644461179-ddd318c669e4?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=700&q=80"),
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
        Container(
          child: Column(
            children: [
              CircleAvatar(
                  radius: 20.0,
                  backgroundImage: NetworkImage(
                      "https://images.unsplash.com/photo-1610112908715-bfb038058815?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=675&q=80")),
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
        Container(
          child: Column(
            children: [
              CircleAvatar(
                radius: 20.0,
                backgroundImage: NetworkImage(
                    "https://images.unsplash.com/photo-1599599810769-bcde5a160d32?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1489&q=80"),
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
        Container(
          child: Column(
            children: [
              CircleAvatar(
                radius: 20.0,
                backgroundImage: NetworkImage(
                    "https://images.unsplash.com/photo-1575729853435-c3aac6ca37df?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80"),
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
        Container(
          child: Column(
            children: [
              CircleAvatar(
                radius: 20.0,
                backgroundImage: NetworkImage(
                    "https://images.unsplash.com/photo-1584609973729-4a8bc988e2e2?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80"),
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
                    "https://images.unsplash.com/photo-1517683551739-7f3f08efba84?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          //2nd Image of Slider
          Container(
            margin: EdgeInsets.only(top: 6.0, bottom: 6.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: NetworkImage(
                    "https://images.unsplash.com/photo-1611250503393-9424f314d265?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1266&q=80"),
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
                    "https://images.unsplash.com/photo-1594243968753-6a0fc79e86dd?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80"),
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
                    "https://images.unsplash.com/photo-1597892822997-309a4f7223d3?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          //5th Image of Slider
          Container(
            margin: EdgeInsets.only(top: 6.0, bottom: 6.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: NetworkImage(
                    "https://images.unsplash.com/photo-1511348398635-8efff213a280?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80"),
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
          viewportFraction: 0.8,
        ),
      )
    ],
  );
}

Widget sourceInfo(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
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
                    model.thumbnailUrl,
                    height: 100.0,
                    width: 120.0,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Expanded(
                      child: Text(
                    model.shortInfo,
                    style: TextStyle(color: Colors.grey, fontSize: 12.0),
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
                      "5%",
                      style: TextStyle(fontSize: 10, color: Colors.black38),
                    )),
                  ),
                ),
              ),
            ],
          ),
        ),      ),
    ),
  );
}


        // child: Row(
        //   children: [
        //     Image.network(
        //       model.thumbnailUrl,
        //       height: 140.0,
        //       width: 140.0,
        //     ),
        //     SizedBox(
        //       width: 4.0,
        //     ),
        //     // Expanded(
        //     //     child: Column(
        //     //   crossAxisAlignment: CrossAxisAlignment.start,
        //     //   children: [
        //     //     SizedBox(height: 15),
        //     //     Container(
        //     //       child: Row(
        //     //         mainAxisSize: MainAxisSize.max,
        //     //         children: [
        //     //           Expanded(
        //     //               child: Text(
        //     //             model.title,
        //     //             style: TextStyle(color: Colors.black45, fontSize: 14.0),
        //     //           ))
        //     //         ],
        //     //       ),
        //     //     ),
        //     //     SizedBox(
        //     //       height: 5.0,
        //     //     ),
        //     //     Container(
        //     //       child: Row(
        //     //         mainAxisSize: MainAxisSize.max,
        //     //         children: [
        //     //           Expanded(
        //     //               child: Text(
        //     //             model.shortInfo,
        //     //             style: TextStyle(color: Colors.black38, fontSize: 12.0),
        //     //           ))
        //     //         ],
        //     //       ),
        //     //     ),
        //     //     SizedBox(
        //     //       height: 20.0,
        //     //     ),
        //     //     Row(
        //     //       children: [
        //     //         Container(
        //     //           alignment: Alignment.topLeft,
        //     //           width: 40.0,
        //     //           height: 43.0,
        //     //           child: Center(
        //     //             child: Column(
        //     //               mainAxisAlignment: MainAxisAlignment.center,
        //     //               children: [
        //     //                 Text(
        //     //                   "50%",
        //     //                   style: TextStyle(
        //     //                       color: Colors.white,
        //     //                       fontSize: 15.0,
        //     //                       fontWeight: FontWeight.normal),
        //     //                 ),
        //     //                 Text(
        //     //                   "OFF%",
        //     //                   style: TextStyle(
        //     //                       color: Colors.white,
        //     //                       fontSize: 12.0,
        //     //                       fontWeight: FontWeight.normal),
        //     //                 )
        //     //               ],
        //     //             ),
        //     //           ),
        //     //           decoration: BoxDecoration(
        //     //             shape: BoxShape.rectangle,
        //     //             color: Colors.black26,
        //     //           ),
        //     //         ),
        //     //         SizedBox(
        //     //           width: 10.0,
        //     //         ),
        //     //         Column(
        //     //           crossAxisAlignment: CrossAxisAlignment.start,
        //     //           children: [
        //     //             Padding(
        //     //               padding: EdgeInsets.only(top: 0.0),
        //     //               child: Row(
        //     //                 children: [
        //     //                   Text(
        //     //                     "Original price: Ksh.",
        //     //                     style: TextStyle(
        //     //                       fontSize: 12.0,
        //     //                       decoration: TextDecoration.lineThrough,
        //     //                       color: Colors.grey,
        //     //                     ),
        //     //                   ),
        //     //                   Text(
        //     //                     (model.price + model.price).toString(),
        //     //                     style: TextStyle(
        //     //                         fontSize: 12.0,
        //     //                         color: Colors.grey,
        //     //                         decoration: TextDecoration.lineThrough),
        //     //                   )
        //     //                 ],
        //     //               ),
        //     //             ),
        //     //             Padding(
        //     //               padding: EdgeInsets.only(top: 5.0),
        //     //               child: Row(
        //     //                 children: [
        //     //                   Text(
        //     //                     "New price: Ksh.",
        //     //                     style: TextStyle(
        //     //                       fontSize: 12.0,
        //     //                       color: Colors.grey,
        //     //                     ),
        //     //                   ),
        //     //                   Text(
        //     //                     (model.price).toString(),
        //     //                     style: TextStyle(
        //     //                       fontSize: 12.0,
        //     //                       color: Colors.grey,
        //     //                     ),
        //     //                   )
        //     //                 ],
        //     //               ),>
        //     //             )
        //     //           ],
        //     //         )
        //     //       ],
        //     //     ),
        //     //     Flexible(
        //     //       child: Container(),
        //     //     ),
        //     //     Align(
        //     //       alignment: Alignment.centerRight,
        //     //       child: removeCartFunction == null
        //     //           ? IconButton(
        //     //               onPressed: () {
        //     //                 checkItemInCart(model.shortInfo, context);
        //     //               },
        //     //               icon: Icon(
        //     //                 Icons.add_shopping_cart,
        //     //                 color: Colors.black26,
        //     //               ))
        //     //           : IconButton(
        //     //               icon: Icon(Icons.remove_shopping_cart),
        //     //               onPressed: () {
        //     //                 removeCartFunction();
        //     //                 Route route =
        //     //                     MaterialPageRoute(builder: (c) => MyHomePage());

        //     //                 Navigator.pushReplacement(context, route);
        //     //               }),
        //     //     ),
        //     //     Divider(
        //     //       height: 5.0,
        //     //       color: Colors.black26,
        //     //     )
        //     //   ],
        //     // ))
        //   ],
        // ),

Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
  return Container(
    height: 150.0,
    // width:  width * .34,
    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
              offset: Offset(0, 5), blurRadius: 10.0, color: Colors.grey[200])
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

void checkItemInCart(String shortInfoID, BuildContext context) {
  EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartList)
          .contains(shortInfoID)
      ? Fluttertoast.showToast(msg: "Item already in Cart")
      : addItemToCart(shortInfoID, context);
}

addItemToCart(String shortInfoID, BuildContext context) {
  List tempCartList =
      EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);

  tempCartList.add(shortInfoID);

  EcommerceApp.firestore
      .collection(EcommerceApp.collectionUser)
      .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
      .update({
    EcommerceApp.userCartList: tempCartList,
  }).then((value) {
    Fluttertoast.showToast(msg: "Item Added to Cart Successfully");

    EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartList, tempCartList);

    Provider.of<CartItemCounter>(context, listen: false).displayResult();
  });
}
