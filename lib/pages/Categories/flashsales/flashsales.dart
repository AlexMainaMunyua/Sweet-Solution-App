import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_application/pages/Config/config.dart';
import 'package:ecommerce_application/pages/Counter/cartItemCounter.dart';
import 'package:ecommerce_application/pages/Model/item.dart';
import 'package:ecommerce_application/pages/Store/cart.dart';
import 'package:ecommerce_application/pages/Store/productPage.dart';
import 'package:ecommerce_application/pages/Widgets/loadingWidget.dart';
import 'package:ecommerce_application/pages/myhomepage/myhomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class FlashSale extends StatefulWidget {
  @override
  _FlashSaleState createState() => _FlashSaleState();
}

class _FlashSaleState extends State<FlashSale> {
  _onWillPop(BuildContext context) {
    Route route = MaterialPageRoute(builder: (c) => MyHomePage());

    Navigator.pushReplacement(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          _onWillPop(context);
        },
        child: DefaultTabController(
          length: 1,
          child: Scaffold(
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
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Route route = MaterialPageRoute(builder: (c) => MyHomePage());

                  Navigator.pushReplacement(context, route);
                },
              ),
              title: Text(
                "Flash Sales",
                style: TextStyle(
                    fontSize: 35.0,
                    color: Colors.white,
                    fontFamily: "Signatra"),
              ),
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
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(40),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TabBar(
                    // indicatorWeight: 5,
                    isScrollable: true,
                    indicator: UnderlineTabIndicator(
                        borderSide:
                            BorderSide(width: 4, color: Colors.grey.shade700),
                        insets:
                            EdgeInsets.only(left: 0, right: 4.0, bottom: 0.0)),
                    // labelPadding:  EdgeInsets.only(left: 0, right: 0),

                    tabs: [
                      Tab(
                        child: Text(
                          "All",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // body: CustomScrollView(slivers: [
            //   SliverToBoxAdapter(
            //     child: Padding(
            //       padding: const EdgeInsets.only(left: 10.0),
            //       child: TabBar(
            //         indicatorWeight: 5,
            //         isScrollable: true,
            //         tabs: [
            //           Tab(
            //             child: Text(
            //               "All",
            //               style: TextStyle(
            //                   fontSize: 16,
            //                   color: Colors.grey.shade700,
            //                   fontWeight: FontWeight.bold),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            //   SliverToBoxAdapter(
            //     child: Padding(
            //       padding: const EdgeInsets.only(top: 8.0),
            //       child: _createCarousel(),
            //     ),
            //   ),
            //   StreamBuilder(
            //       stream: FirebaseFirestore.instance
            //           .collection("items")
            //           .where("shortInfo", isEqualTo: "Flash Sales")
            //           .limit(4)
            //           // .orderBy("publishedDate", descending: true)
            //           .snapshots(),
            //       builder: (context, snapshot) {
            //         return !snapshot.hasData
            //             ? SliverToBoxAdapter(
            //                 child: Center(child: circularProgress()),
            //               )
            //             : SliverStaggeredGrid.countBuilder(
            //                 crossAxisCount: 2,
            //                 staggeredTileBuilder: (c) => StaggeredTile.fit(1),
            //                 itemBuilder: (context, index) {
            //                   ItemModel model = ItemModel.fromJson(
            //                       snapshot.data.docs[index].data());

            //                   return categorySourceInfo(model, context);
            //                 },
            //                 itemCount: snapshot.data.docs.length);
            //       })
            // ]),
          ),
        ));
  }

  Widget categorySourceInfo(ItemModel model, BuildContext context,
      {Color background, removeCartFunction}) {
    return InkWell(
      onTap: () {
        Route route =
            MaterialPageRoute(builder: (c) => ProductPage(itemModel: model));

        Navigator.pushReplacement(context, route);
      },
      splashColor: Colors.black26,
      child: Container(
        height: 200.0,
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
                        child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        model.shortInfo,
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
                        "5%",
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
            height: 120.0,
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
}
