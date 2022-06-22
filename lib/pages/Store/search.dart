import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_application/pages/Model/item.dart';
import 'package:ecommerce_application/pages/Store/productPage.dart';
import 'package:ecommerce_application/pages/Widgets/customAppBar.dart';
import 'package:ecommerce_application/pages/myhomepage/myhomePage.dart';
import 'package:flutter/material.dart';

class SearchProduct extends StatefulWidget {
  @override
  _SearchProductState createState() => new _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  Future<QuerySnapshot>? docList;

  Future<bool> _onWillPop() async {
    Route route = MaterialPageRoute(builder: (c) => MyHomePage());

    Navigator.pushReplacement(context, route);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: SafeArea(
        child: Scaffold(
          appBar: MyAppBar(
            bottom: PreferredSize(
              child: searchWidget(),
              preferredSize: Size(56.0, 56.0),
            ),
          ),
          body: FutureBuilder<QuerySnapshot>(
            future: docList,
            builder: (context, snap) {
              return snap.hasData
                  ? ListView.builder(
                      itemBuilder: (context, index) {
                        ItemModel model =
                            ItemModel.fromJson(snap.data!.docs[index].data());

                        return searchSourceInfo(model, context);
                      },
                      itemCount: snap.data!.docs.length,
                    )
                  : Center(child: Text("Search items"));
            },
          ),
        ),
      ),
    );
  }

  Widget searchSourceInfo(ItemModel model, BuildContext context,
      {Color? background, removeCartFunction}) {
    return InkWell(
      onTap: () {
        Route route =
            MaterialPageRoute(builder: (c) => ProductPage(itemModel: model));

        Navigator.pushReplacement(context, route);
      },
      splashColor: Colors.black26,
      child: Container(
        height: 130.0,
        child: Card(
          child: Container(
            child: Stack(
              children: [
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.30,
                      child: Image.network(
                        model.thumbnailUrl!,
                        height: 80.0,
                        width: 120.0,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.60,
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  model.title!,
                                  style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 14.0),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  model.longDescription!,
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12.0),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Ksh." + model.price.toString(),
                              style: TextStyle(
                                  color: Colors.grey.shade700, fontSize: 14.0),
                            ),
                          ),
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
                        model.discount.toString() + "%",
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

  Widget searchWidget() {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: 80.0,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.black12, Colors.black12],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp)),
      child: Container(
        width: MediaQuery.of(context).size.width - 40.0,
        height: 50.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Icon(Icons.search, color: Colors.black45),
            ),
            Flexible(
                child: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: TextField(
                onChanged: (value) {
                  startSearching(value);
                },
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration.collapsed(
                    hintText: "Search here",
                    hintStyle: TextStyle(fontSize: 14, color: Colors.black38)),
              ),
            ))
          ],
        ),
      ),
    );
  }

  Future startSearching(String query) async {
    docList = FirebaseFirestore.instance
        .collection("items")
        .where("title", isGreaterThanOrEqualTo: query)
        .get();
  }
}
