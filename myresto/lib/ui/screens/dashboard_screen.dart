import 'package:flutter/material.dart';
import 'package:myresto/ui/screens/cart_screen.dart';
import 'package:myresto/ui/screens/foods/home_screen.dart';
import 'package:myresto/ui/screens/profile/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  //Selected index page
  int selectedIndex = 0;

  //List screen page
  List<Widget> pageList = [
    HomeScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  //Navbar Item
  final _bottomNavbarItem = <BottomNavigationBarItem>[
    BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
    BottomNavigationBarItem(
        icon: Icon(Icons.shopping_cart), title: Text("Cart")),
    BottomNavigationBarItem(
        icon: Icon(Icons.account_circle), title: Text("Profile")),
  ];

  void _onNavBarTapped(int index) {
    if (index >= 0 && index < pageList.length) {
      setState(() {
        selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageList[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomNavbarItem,
        currentIndex: selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.4),
        backgroundColor: Colors.pinkAccent,
        onTap: _onNavBarTapped,
      ),
    );
  }
}
