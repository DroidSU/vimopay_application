import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.white,
      fontFamily: 'Roboto',
      appBarTheme: AppBarTheme(
        // color: Colors.blue[400],
        color: Color(0xFFd3d3d3),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      colorScheme: ColorScheme.light(
        primary: Colors.blue,
        onPrimary: Colors.blueAccent,
        primaryVariant: Color(0xff00A2E7),
        secondary: Colors.deepPurple[400],
      ),
      cardTheme: CardTheme(
        color: Colors.white,
      ),
      iconTheme: IconThemeData(
        color: Colors.white54,
      ),
      textTheme: TextTheme(
          caption: TextStyle(color: Colors.black, fontSize: 20),
          headline1: TextStyle(color: Colors.blue[900], fontSize: 26),
          headline2: TextStyle(color: Colors.black, fontSize: 20),
          subtitle1: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)));

  static final ThemeData darkTheme = ThemeData(
      scaffoldBackgroundColor: Colors.deepPurple[900],
      fontFamily: 'Roboto',
      appBarTheme: AppBarTheme(
        // color: Colors.deepPurple[700],
        color: Color(0xFFacacac),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      colorScheme: ColorScheme.light(
        primary: Colors.black,
        onPrimary: Colors.black87,
        primaryVariant: Colors.black87,
        secondary: Color(0xFFFF6600),
      ),
      cardTheme: CardTheme(
        color: Colors.black,
      ),
      iconTheme: IconThemeData(
        color: Colors.white54,
      ),
      textTheme: TextTheme(
          caption: TextStyle(color: Colors.white, fontSize: 20),
          headline1: TextStyle(color: Color(0xFFFF6600), fontSize: 26),
          headline2: TextStyle(color: Colors.white, fontSize: 20),
          subtitle1: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)));
}
