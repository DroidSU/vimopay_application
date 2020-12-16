import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vimopay_application/customs/constants.dart';
import 'package:vimopay_application/customs/scale_route_transition.dart';
import 'package:vimopay_application/ui/DashboardScreen.dart';
import 'package:vimopay_application/ui/LoginScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  String authToken = "";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceInOut,
    );

    SharedPreferences.getInstance().then((sharedPrefs) {
      authToken = sharedPrefs.getString(Constants.SHARED_PREF_TOKEN);
      startTimer(authToken);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Image.asset(
            'images/ic_logo.png',
            height: 120,
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  void startTimer(String authToken) {
    Timer(Duration(milliseconds: 3000), () {
      if (authToken != null && authToken.isNotEmpty) {
        Navigator.of(context)
            .pushReplacement(ScaleRoute(page: DashboardScreen()));
      } else {
        Navigator.of(context).pushReplacement(ScaleRoute(page: LoginScreen()));
      }
    });
  }
}
