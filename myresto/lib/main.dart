import 'package:flutter/material.dart';
import 'package:myresto/ui/screens/home_screen.dart';

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
        home: HomeScreen(),
        routes: {"/home": (context) => HomeScreen()});
  }
}
