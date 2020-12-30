import 'package:flutter/material.dart';
import 'package:vimopay_application/ui/SplashScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Colors.white,
        fontFamily: 'Roboto',
        primarySwatch: Colors.blue,
        primaryColor: Color(0xff00A2E7),
        // primaryColor: Color(0xff9C8AA5),
        primaryColorLight: Color(0xffcc99cc),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}
