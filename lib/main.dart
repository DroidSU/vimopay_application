import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vimopay_application/apptheme.dart';
import 'package:vimopay_application/ui/SplashScreen.dart';

import 'app_state_notifier.dart';
import 'customs/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true);
  await Firebase.initializeApp();
  handleNotifs();
  runApp(
    ChangeNotifierProvider<AppStateNotifier>(
      create: (context) => AppStateNotifier(),
      builder: (context, widget) => MyApp(),
    ),
  );
}

Future<void> handleNotifs() async {
  String? fcmToken = await FirebaseMessaging.instance.getToken();
  print('FCM Token: $fcmToken');

  SharedPreferences.getInstance().then((sharedPrefs) {
    sharedPrefs.setString(Constants.SHARED_PREF_FCM_TOKEN, fcmToken!);
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

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
