import 'package:bitset/screens/home_screen.dart';
import 'package:bitset/utils.dart';
import 'package:flutter/material.dart';
import 'package:bitset/screens/portfolio.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<NavigatorState> myNavigatorKey = GlobalKey<NavigatorState>();
  MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      navigatorKey: myNavigatorKey,
      routes: {
        '/Cryptocurrencies': (context) => HomeScreen(),
        '/Portfolio': (context) => PortfolioViewPage(),
      },
      builder: (context, child) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 44, 45, 44),
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
          ),
          drawer: Drawer(
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 44, 45, 44),
              ),
              child: ListView(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset("assets/logo/BitAssetLogo.jpg"),
                  ),
                  ListTile(
                    title: Text(
                      'View Cryptocurrencies',
                      style: textStyle(
                        MediaQuery.of(context).size.width * 0.04,
                        Colors.white,
                        FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      // Use myNavigatorKey instead of context
                      myNavigatorKey.currentState!.pop();
                      myNavigatorKey.currentState!
                          .pushNamed('/Cryptocurrencies');
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Portfolio',
                      style: textStyle(
                        MediaQuery.of(context).size.width * 0.04,
                        Colors.white,
                        FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      // Use myNavigatorKey instead of context
                      myNavigatorKey.currentState!.pop();
                      myNavigatorKey.currentState!.pushNamed('/Portfolio');
                    },
                  ),
                ],
              ),
            ),
          ),
          body: child,
        );
      },
    );
  }
}
