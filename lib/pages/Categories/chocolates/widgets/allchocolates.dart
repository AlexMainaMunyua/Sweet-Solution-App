import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_application/pages/Model/item.dart';
import 'package:ecommerce_application/pages/Store/productPage.dart';
import 'package:ecommerce_application/pages/Widgets/loadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class AllChocolates extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: _createCarousel(),
          ),
        ),
        StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("items")
                .where("shortInfo", isEqualTo: "Chocolate")
                .snapshots(),
            builder: (context,AsyncSnapshot snapshot) {
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
            }),
      ],
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
                      "https://firebasestorage.googleapis.com/v0/b/loan-app-6d0b2.appspot.com/o/ecommerceImages%2FJumboTron%2FchocolateJumbo.png?alt=media&token=4c27eda4-a459-4feb-9cd8-6b72af379a45"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
          options: CarouselOptions(
            height: 120.0,
            enlargeCenterPage: true,
            autoPlay: false,
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

  Widget categorySourceInfo(ItemModel model, BuildContext context,
      {Color? background, removeCartFunction}) {
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
}
