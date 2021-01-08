import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vimopay_application/apptheme.dart';
import 'package:vimopay_application/ui/SplashScreen.dart';
import 'package:vimopay_application/ui/app_state_notifier.dart';

void main() {
  runApp(
    ChangeNotifierProvider<AppStateNotifier>(
      create: (context) => AppStateNotifier(),
      builder: (context, widget) => MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateNotifier>(builder: (context, appState, child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        theme: AppTheme.lightTheme, // ThemeData(primarySwatch: Colors.blue),
        darkTheme: AppTheme.darkTheme,
        // theme: ThemeData(
        //   backgroundColor: Colors.white,
        //   fontFamily: 'Roboto',
        //   primarySwatch: Colors.blue,
        //   primaryColor: Color(0xff00A2E7),
        //   // primaryColor: Color(0xff9C8AA5),
        //   primaryColorLight: Color(0xffcc99cc),
        //   visualDensity: VisualDensity.adaptivePlatformDensity,
        // ),
        home: SplashScreen(),
      );
    });
  }
}
