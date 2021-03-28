import 'package:ecommerce_application/pages/Counter/cartItemCounter.dart';
import 'package:ecommerce_application/pages/Store/cart.dart';
import 'package:ecommerce_application/pages/Widgets/mydrawer.dart';
import 'package:flutter/material.dart';
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
          "p-shop",
          style: TextStyle(
              fontSize: 55.0, color: Colors.white, fontFamily: "Signatra"),
        ),
        centerTitle: true,
        actions: [
          Stack(children: [
            IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.black26,
                ),
                onPressed: () {
                  Route route = MaterialPageRoute(builder: (c) => CartPage());

                  Navigator.pushReplacement(context, route);
                }),
            Positioned(
                child: Stack(
              children: [
                Icon(
                  Icons.brightness_1,
                  size: 20.0,
                  color: Colors.green,
                ),
                Positioned(
                  top: 3.0,
                  bottom: 4.0,
                  child: Consumer<CartItemCounter>(
                    builder: (context, counter, _) {
                      return Text(counter.count.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500));
                    },
                  ),
                )
              ],
            )),
          ])
        ],
      ),
      drawer: MyDrawer(),
    ));
  }
}

// Widget sourceInfo(ItemModel model, BuildContext context,
//     {Color background, removeCartFunction}) {
//   return InkWell();
// }

Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
  return Container();
}

void checkItemInCart(String productID, BuildContext context) {}

// class _MyHomePageState extends State<MyHomePage> {
//   int _selectedIndex = 0;
//   static const TextStyle optionStyle =
//       TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
//   static const List<Widget> _widgetOptions = <Widget>[
//     Text(
//       'Index 0: Home',
//       style: optionStyle,
//     ),
//     Text(
//       'Index 1: Chat',
//       style: optionStyle,
//     ),
//     Text(
//       'Index 2: My Cart',
//       style: optionStyle,
//     ),
//     Text(
//       'Index 3: My Account',
//       style: optionStyle,
//     ),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 6,
//       child: Scaffold(
//         appBar: AppBar(
//           elevation: 0,
//           backgroundColor: Colors.white,
//           title: Container(
//             height: 40,
//             child: TextField(
//               decoration: InputDecoration(
//                   prefixIcon: Icon(
//                     Icons.search,
//                     color: Colors.grey[900],
//                   ),
//                   border: OutlineInputBorder(borderSide: new BorderSide())
//                   // prefixText: "Search",
//                   ),
//             ),
//           ),
//           actions: [
//             IconButton(
//               padding: EdgeInsets.only(right: 20),
//               icon: Icon(
//                 Icons.favorite_border,
//                 color: Colors.grey[800],
//               ),
//               onPressed: () {},
//               iconSize: 30,
//             )
//           ],
//           bottom: TabBar(
//             labelColor: Colors.grey[900],
//             labelStyle: TextStyle(fontWeight: FontWeight.w600),
//             indicatorColor: Colors.grey[900],
//             unselectedLabelColor: Colors.grey[500],
//             isScrollable: true,
//             tabs: [
//               Tab(
//                 text: "All",
//               ),
//               Tab(text: "Sweets"),
//               Tab(text: "Beauty"),
//               Tab(
//                 text: "Consumerbles",
//               ),
//               Tab(
//                 text: "Stationaries",
//               ),
//               Tab(
//                 text: "Detagents and Sanitary",
//               ),
//             ],
//           ),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[],
//           ),
//         ),

//         bottomNavigationBar: BottomNavigationBar(
//           type: BottomNavigationBarType.fixed,
//           unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
//           items: const <BottomNavigationBarItem>[
//             BottomNavigationBarItem(
//               icon: Icon(Icons.home),
//               label: 'Home',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.chat),
//               label: 'Message',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.shopping_cart),
//               label: 'My Cart',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.person),
//               label: 'My Account',
//             ),
//           ],
//           currentIndex: _selectedIndex,
//           selectedItemColor: Colors.grey[900],
//           unselectedItemColor: Colors.grey[500],
//           showUnselectedLabels: true,
//           selectedLabelStyle:
//               TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//           onTap: _onItemTapped,
//         ),
//         // This trailing comma makes auto-formatting nicer for build methods.
//       ),
//     );
//   }
// }
