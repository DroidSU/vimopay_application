import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vimopay_application/customs/constants.dart';
import 'package:vimopay_application/customs/scale_route_transition.dart';
import 'package:vimopay_application/ui/DashboardScreen.dart';

class BBPSRechargeScreen extends StatefulWidget {
  @override
  _BBPSRechargeScreenState createState() => _BBPSRechargeScreenState();
}

class _BBPSRechargeScreenState extends State<BBPSRechargeScreen> {
  String authToken = "";

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((sharedPrefs) {
      authToken = sharedPrefs.getString(Constants.SHARED_PREF_TOKEN);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: SafeArea(
            child: Scaffold(
          backgroundColor: Color(0xffd3d3d3),
          appBar: PreferredSize(
            preferredSize: Size(double.infinity, 100),
            child: Container(
                height: 60,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          'images/header_bg.png',
                        ))),
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Electricity',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    Container(
                        padding: EdgeInsets.all(15),
                        child: InkWell(
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 26,
                          ),
                          onTap: () {
                            onBackPressed();
                          },
                        )),
                  ],
                )),
          ),
        )),
        onWillPop: onBackPressed);
  }

  Future<bool> onBackPressed() async {
    Navigator.of(context).pushReplacement(ScaleRoute(page: DashboardScreen()));
    return true;
  }
}
