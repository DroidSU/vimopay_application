import 'package:flutter/material.dart';

class SlideInTransition extends PageRouteBuilder {
  final Widget page;

  SlideInTransition({this.page})
      : super(pageBuilder: (BuildContext buildContext,
            Animation<double> animation, Animation<double> secondAnimation) {
          return page;
        }, transitionsBuilder: (BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child) {
          var begin = Offset(1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.easeInCubic;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        });
}
