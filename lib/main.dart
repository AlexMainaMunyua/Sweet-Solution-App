import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pros Enterise',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Chat',
      style: optionStyle,
    ),
    Text(
      'Index 2: My Cart',
      style: optionStyle,
    ),
    Text(
      'Index 3: My Account',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Container(
            height: 40,
            child: TextField(
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey[900],
                  ),
                  border: OutlineInputBorder(borderSide: new BorderSide())
                  // prefixText: "Search",
                  ),
            ),
          ),
          actions: [
            IconButton(
              padding: EdgeInsets.only(right: 20),
              icon: Icon(
                Icons.favorite_border_outlined,
                color: Colors.grey[800],
              ),
              onPressed: () {},
              iconSize: 30,
            )
          ],
          bottom: TabBar(
            labelColor: Colors.grey[900],
            labelStyle: TextStyle(fontWeight: FontWeight.w600),
            indicatorColor: Colors.grey[900],
            unselectedLabelColor: Colors.grey[500],
            isScrollable: true,
            tabs: [
              Tab(
                text: "All",
              ),
              Tab(text: "Sweets"),
              Tab(text: "Beauty"),
              Tab(
                text: "Consumerbles",
              ),
              Tab(
                text: "Stationaries",
              ),
              Tab(
                text: "Detagents and Sanitary",
              ),
            ],
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[],
          ),
        ),

        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Message',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'My Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'My Account',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.grey[900],
          unselectedItemColor: Colors.grey[500],
          showUnselectedLabels: true,
          selectedLabelStyle:
              TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          onTap: _onItemTapped,
        ),
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
