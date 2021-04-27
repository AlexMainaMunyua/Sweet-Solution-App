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

class GumPage extends StatelessWidget {
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
                "Bubble Gums",
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
            ),
            body: CustomScrollView(slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: TabBar(
                    indicatorWeight: 5,
                    isScrollable: true,
                    tabs: [
                      Tab(
                        child: Text(
                          "All",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: _createCarousel(),
                ),
              ),
                      StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("items")
                      .where("shortInfo", isEqualTo: "Toys")
                      .limit(4)
                      // .orderBy("publishedDate", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    return !snapshot.hasData
                        ? SliverToBoxAdapter(
                            child: Center(child: circularProgress()),
                          )
                        : SliverStaggeredGrid.countBuilder(
                            crossAxisCount: 2,
                            staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                            itemBuilder: (context, index) {
                              ItemModel model = ItemModel.fromJson(
                                  snapshot.data.docs[index].data());

                              return categorySourceInfo(model, context);
                            },
                            itemCount: snapshot.data.docs.length);
                  })
            ]),
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
                      "https://firebasestorage.googleapis.com/v0/b/loan-app-6d0b2.appspot.com/o/ecommerceImages%2FGumJumboTron%2Fgumjumbo1.jpg?alt=media&token=db5bb208-d797-4de1-b7e4-e8d7e3dcc3f9"),
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
                      "https://firebasestorage.googleapis.com/v0/b/loan-app-6d0b2.appspot.com/o/ecommerceImages%2FGumJumboTron%2Fgumjumbo3.jpg?alt=media&token=73cd77a7-0802-4613-b8f7-b9f8d7194074"),
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
                      "https://firebasestorage.googleapis.com/v0/b/loan-app-6d0b2.appspot.com/o/ecommerceImages%2FGumJumboTron%2Fgumjumbo2.jpg?alt=media&token=296fc78c-e89e-4aec-83aa-2fc72d3eb6c6"),
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
                      "https://firebasestorage.googleapis.com/v0/b/loan-app-6d0b2.appspot.com/o/ecommerceImages%2FGumJumboTron%2Fgumjumbo4.jpg?alt=media&token=1f0d9e47-ae1e-4661-b882-34a2be8776fc"),
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
                      "https://firebasestorage.googleapis.com/v0/b/loan-app-6d0b2.appspot.com/o/ecommerceImages%2FGumJumboTron%2Fgumjumbo5.jpeg?alt=media&token=7d28b272-abf3-4493-8fce-06a4069cbba0"),
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
