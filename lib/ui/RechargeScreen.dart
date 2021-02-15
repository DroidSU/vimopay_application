import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vimopay_application/customs/constants.dart';
import 'package:vimopay_application/customs/custom_dialog.dart';
import 'package:vimopay_application/customs/recharge_types.dart';
import 'package:vimopay_application/network/http_service.dart';
import 'package:vimopay_application/network/models/PrepaidRecharResponse.dart';
import 'package:vimopay_application/network/models/prepaid_recharge_response_model.dart';

class RechargeScreen extends StatefulWidget {
  final String rechargeType;

  RechargeScreen({@required this.rechargeType});

  @override
  _RechargeScreenState createState() => _RechargeScreenState();
}

class _RechargeScreenState extends State<RechargeScreen> {
  String rechargeType = "";
  String authToken = "";

  String mobileNumber = "";
  String subscriberId = "";
  int amount = 0;
  TextEditingController mobileNumberController;
  TextEditingController amountController;
  TextEditingController subscriberIdController;

  Map<String, String> operatorsMap = Map();
  List<String> operatorList = List();
  String selectedOperator = "";

  bool _showProgress = false;

  @override
  void initState() {
    super.initState();
    rechargeType = widget.rechargeType;

    SharedPreferences.getInstance().then((sharedPrefs) {
      authToken = sharedPrefs.getString(Constants.SHARED_PREF_TOKEN);
    });

    if (rechargeType == RechargeTypes.PREPAID) {
      getPrepaidList();
    } else if (rechargeType == RechargeTypes.DTH) {
      getDTHOperators();
    }

    mobileNumberController = TextEditingController();
    amountController = TextEditingController();
    subscriberIdController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    mobileNumberController.dispose();
    amountController.dispose();
    subscriberIdController.dispose();
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
                                rechargeType,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
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
              body: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  padding: EdgeInsets.fromLTRB(10, 40, 10, 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
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
                      DropdownButton(
                          isExpanded: true,
                          value: selectedOperator,
                          onChanged: (value) {
                            setState(() {
                              selectedOperator = value;
                            });
                          },
                          items: operatorList.map((operator) {
                            return DropdownMenuItem(
                              child: Text(
                                operator,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black),
                              ),
                              value: operator,
                            );
                          }).toList()),
                      SizedBox(
                        height: 20,
                      ),
                      rechargeType == RechargeTypes.DTH
                          ? Text(
                              'Subscriber ID',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 18,
                              ),
                            )
                          : Container(),
                      rechargeType == RechargeTypes.DTH
                          ? TextField(
                              keyboardType: TextInputType.number,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                              decoration: InputDecoration(
                                  hintText: 'Subscriber ID',
                                  hintStyle: TextStyle(
                                      color: Colors.black54, fontSize: 16)),
                            )
                          : Container(),
                      rechargeType == RechargeTypes.DTH
                          ? SizedBox(
                              height: 20,
                            )
                          : Container(),
                      Text(
                        'Mobile Number',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 18,
                        ),
                      ),
                      TextField(
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: Colors.black, fontSize: 18),
                        controller: mobileNumberController,
                        inputFormatters: [LengthLimitingTextInputFormatter(10)],
                        decoration: InputDecoration(
                            hintText: 'Mobile number',
                            hintStyle:
                                TextStyle(color: Colors.black54, fontSize: 16)),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Amount',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 18,
                        ),
                      ),
                      TextField(
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: Colors.black, fontSize: 18),
                        controller: amountController,
                        decoration: InputDecoration(
                            hintText: 'Amount',
                            hintStyle: TextStyle(
                              color: Colors.black54,
                            )),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: _showProgress
                            ? CircularProgressIndicator()
                            : MaterialButton(
                                onPressed: () {
                                  mobileNumber =
                                      mobileNumberController.text.trim();
                                  subscriberId =
                                      subscriberIdController.text.trim();
                                  String amountString =
                                      amountController.text.trim();
                                  if (amountString != null &&
                                      amountString.isNotEmpty)
                                    amount = int.parse(amountString);

                                  if (((rechargeType == RechargeTypes.PREPAID &&
                                              mobileNumber.length == 10) ||
                                          rechargeType == RechargeTypes.DTH) &&
                                      amount >= 10) {
                                    if (rechargeType == RechargeTypes.PREPAID)
                                      startPrepaidRecharge();
                                    else if (rechargeType == RechargeTypes.DTH)
                                      startDTHRecharge();
                                  } else {
                                    if (mobileNumber.length != 10)
                                      showErrorDialog('Invalid mobile number!');
                                    else if (amount < 10)
                                      showErrorDialog(
                                          'Amount should be more than 10');
                                  }
                                },
                                minWidth: 300,
                                color: Colors.blue[900],
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  'Recharge',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              )),
        ),
        onWillPop: onBackPressed);
  }

  Future<bool> onBackPressed() async {
    Navigator.of(context).pop();
    return true;
  }

  void showServerError(String message) {
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
                        'images/ic_server_error.png',
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

  void startPrepaidRecharge() {
    if (mounted) {
      setState(() {
        _showProgress = true;
      });

      HTTPService()
          .prepaidRecharge(authToken, mobileNumber,
              operatorsMap[selectedOperator], amount.toString())
          .then((response) {
        setState(() {
          _showProgress = false;
        });

        if (response.statusCode == 200) {
          PrepaidRechargeResponse responseModel =
              PrepaidRechargeResponse.fromJson(json.decode(response.body));

          PrepaidRechargeResponseModel model =
              PrepaidRechargeResponseModel.fromJson(
                  json.decode(responseModel.message));

          PrepaidRechargeResponseData responseData = model.data;
          // PrepaidRechargeResponseData.fromJson(
          //     json.decode((model.data).toString()));

          if (responseData.status.toLowerCase() != "failure") {
            showSuccess('Recharge requested');
          } else {
            showErrorDialog('Recharge request failed');
          }
        } else {
          showServerError(
              'Our servers encountered an error. Please try again later');
          print(response.statusCode);
        }
      });
    }
  }

  void getPrepaidList() {
    operatorsMap['Airtel'] = 'A';
    operatorsMap['BSNL'] = 'B';
    operatorsMap['DOCOMO'] = 'D';
    operatorsMap['IDEA'] = 'I';
    operatorsMap['JIO'] = 'JO';
    operatorsMap['Vodafone'] = 'V';
    operatorList = ['Airtel', 'BSNL', 'DOCOMO', 'IDEA', 'JIO', 'Vodafone'];
    setState(() {
      selectedOperator = operatorList[0];
    });
  }

  void getDTHOperators() {
    operatorsMap['VIDECON DTH'] = 'VTV';
    operatorsMap['TATA SKY'] = 'TTV';
    operatorsMap['DISH TV'] = 'DTV';
    operatorsMap['AIRTEL TV'] = 'ATV';
    operatorsMap['SUN TV'] = 'STV';
    operatorsMap['BIG TV'] = 'BTV';
    operatorList = [
      'VIDECON DTH',
      'TATA SKY',
      'DISH TV',
      'AIRTEL TV',
      'SUN TV',
      'BIG TV'
    ];
    setState(() {
      selectedOperator = operatorList[0];
    });
  }

  void startDTHRecharge() {
    if (mounted) {
      setState(() {
        _showProgress = true;
      });

      HTTPService()
          .dthRecharge(authToken, subscriberId, operatorsMap[selectedOperator],
              amount.toString())
          .then((response) {
        setState(() {
          _showProgress = false;
        });

        if (response.statusCode == 200) {
          PrepaidRechargeResponse responseModel =
              PrepaidRechargeResponse.fromJson(json.decode(response.body));

          PrepaidRechargeResponseModel model =
              PrepaidRechargeResponseModel.fromJson(
                  json.decode(responseModel.message));

          PrepaidRechargeResponseData responseData = model.data;
          // PrepaidRechargeResponseData.fromJson(
          //     json.decode((model.data).toString()));

          if (responseData.status.toLowerCase() != "failure") {
            showSuccess('Recharge requested');
          } else {
            showErrorDialog('Recharge request failed');
          }
        } else {
          showServerError(
              'Our servers encountered an error. Please try again later');
          print(response.statusCode);
        }
      });
    }
  }
}
