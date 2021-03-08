import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vimopay_application/customs/custom_dialog.dart';
import 'package:vimopay_application/network/http_service.dart';
import 'package:vimopay_application/network/models/bbps_login_failed_model.dart';
import 'package:vimopay_application/network/models/bbps_login_response_model.dart';

class BBPSPrepaidRechargeScreen extends StatefulWidget {
  @override
  _BBPSPrepaidRechargeScreenState createState() =>
      _BBPSPrepaidRechargeScreenState();
}

class _BBPSPrepaidRechargeScreenState extends State<BBPSPrepaidRechargeScreen> {
  String authToken = "";
  String agentToken = "";

  @override
  void initState() {
    super.initState();

    generateAgentToken();
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
                            'Mobile Prepaid Recharge',
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
          body: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Operator',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                  ),
                ),
                // DropdownButton(
                //     isExpanded: true,
                //     value: selectedOperator,
                //     onChanged: (value) {
                //       setState(() {
                //         selectedOperator = value;
                //       });
                //     },
                //     items: operatorList.map((operator) {
                //       return DropdownMenuItem(
                //         child: Text(
                //           operator,
                //           style: TextStyle(
                //               fontWeight: FontWeight.normal,
                //               color: Colors.black),
                //         ),
                //         value: operator,
                //       );
                //     }).toList()),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        )),
        onWillPop: onBackPressed);
  }

  Future<bool> onBackPressed() async {
    Navigator.of(context).pop();
    return true;
  }

  void generateAgentToken() {
    HTTPService().bbpsAgentLogin().then((response) {
      if (response.statusCode == 200) {
        BBPSLoginResponseModel responseModel =
            BBPSLoginResponseModel.fromJson(json.decode(response.body));
        agentToken = responseModel.token;
      } else {
        BBPSLoginFailedModel loginFailedModel =
            BBPSLoginFailedModel.fromJson(json.decode(response.body));
        showErrorDialog(loginFailedModel.message);
      }
    });
  }

  void showErrorDialog(String message) {
    if (mounted) {
      showDialog(
          context: context,
          builder: (buildContext) {
            return CustomAlertDialog(
              contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              content: Container(
                height: 170,
                decoration: new BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: const Color(0xFFFFFF),
                  borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Icon(
                        Icons.error_outline_rounded,
                        size: 40,
                        color: Colors.red,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Text(
                        message,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'OK',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            );
          });
    }
  }

  void showSuccess(String message) {
    if (mounted) {
      showDialog(
          context: context,
          builder: (buildContext) {
            return CustomAlertDialog(
              contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              content: Container(
                height: 200,
                decoration: new BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: const Color(0xFFFFFF),
                  borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: Image.asset(
                        'images/ic_like.png',
                        height: 60,
                        width: 60,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Text(
                        message,
                        style: TextStyle(fontSize: 18, fontFamily: ''),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'OK',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            );
          });
    }
  }
}
