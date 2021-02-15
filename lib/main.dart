import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vimopay_application/apptheme.dart';
import 'package:vimopay_application/ui/SplashScreen.dart';
import 'package:vimopay_application/ui/app_state_notifier.dart';

import 'customs/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  // if (Platform.isIOS) {
  //   iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
  //     // save the token  OR subscribe to a topic here
  //   });
  //
  //   _fcm.requestNotificationPermissions(IosNotificationSettings());
  // }

  String fcmToken = await _firebaseMessaging.getToken();
  print('FCM Token: $fcmToken');

  SharedPreferences.getInstance().then((sharedPrefs) {
    sharedPrefs.setString(Constants.SHARED_PREF_FCM_TOKEN, fcmToken);
  });

  _firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      print("onMessage: $message");
    },
    onLaunch: (Map<String, dynamic> message) async {
      print("onLaunch: $message");
    },
    onResume: (Map<String, dynamic> message) async {
      print("onResume: $message");
    },
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
