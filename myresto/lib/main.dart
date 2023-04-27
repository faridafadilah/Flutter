import 'package:flutter/material.dart';
import 'package:myresto/ui/screens/cart_screen.dart';
import 'package:myresto/ui/screens/dashboard_screen.dart';
import 'package:myresto/ui/screens/auth/login_screen.dart';
import 'package:myresto/ui/screens/favorite_screen.dart';
import 'package:myresto/ui/screens/history/detail_history_screen.dart';
import 'package:myresto/ui/screens/history/history_screen.dart';
import 'package:myresto/ui/screens/profile/profile_screen.dart';
import 'package:myresto/ui/screens/auth/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'MyResto',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: Colors.pinkAccent, accentColor: Colors.pinkAccent),
        home: cekLogin(),
        routes: {
          "/dashboard": (context) => DashboardScreen(),
          "/login": (context) => LoginScreen(),
          "/register": (context) => RegisterScreen(),
          "/profile": (context) => ProfileScreen(),
          "/favorite": (context) => FavoriteScreen(),
          "/history": (context) => HistoryScreen(),
          "/carts": (context) => CartScreen(),
          "/detailHistory": (context) => DetailHistoryScreen()
        });
  }
}

class cekLogin extends StatefulWidget {
  cekLogin({Key key}) : super(key: key);

  @override
  _cekLoginState createState() => _cekLoginState();
}

class _cekLoginState extends State<cekLogin> {
  @override
  void initState() {
    super.initState();
    getPref();
  }

  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final username = pref.getString('username');

    if (username != null) {
      Future.delayed(const Duration(milliseconds: 2000), () {
        Navigator.pushNamedAndRemoveUntil(
            context, "/dashboard", (Route<dynamic> routes) => false);
      });
    } else {
      Future.delayed(const Duration(milliseconds: 2000), () {
        Navigator.pushNamedAndRemoveUntil(
            context, "/login", (Route<dynamic> routes) => false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: spashscreen(),
    );
  }

  Widget spashscreen() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.pinkAccent,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.fastfood, size: 40, color: Colors.white),
            SizedBox(height: 10),
            Text(
              "MyResto",
              style: TextStyle(
                  fontSize: 35,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
