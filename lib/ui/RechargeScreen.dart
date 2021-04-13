import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vimopay_application/customs/constants.dart';
import 'package:vimopay_application/customs/custom_dialog.dart';
import 'package:vimopay_application/customs/recharge_types.dart';
import 'package:vimopay_application/customs/scale_route_transition.dart';
import 'package:vimopay_application/customs/utility_methods.dart';
import 'package:vimopay_application/network/http_service.dart';
import 'package:vimopay_application/network/models/PrepaidRecharResponse.dart';
import 'package:vimopay_application/network/models/basic_response_model.dart';
import 'package:vimopay_application/network/models/prepaid_recharge_response_model.dart';
import 'package:vimopay_application/network/models/recharge_report_response_data.dart';
import 'package:vimopay_application/network/models/recharge_report_response_model.dart';
import 'package:vimopay_application/ui/DashboardScreen.dart';

class RechargeScreen extends StatefulWidget {
  final String rechargeType;

  RechargeScreen({@required this.rechargeType});

  @override
  _RechargeScreenState createState() => _RechargeScreenState();
}

class _RechargeScreenState extends State<RechargeScreen> {
  String rechargeType = "";
  String authToken = "";
  List<RechargeReportResponseData> rechargeReportList = List();

  String complainStatus = "";
  String complainDescription = "";
  TextEditingController descController;
  bool _showComplaintProgress = false;

  List<String> listOfStatus = [
    'Please Refund',
    'Recharge Error',
    'IP Address Wrong',
    'Show Low Balance',
    'Customize'
  ];

  String currentDateAsString = "";
  DateTime currentDate;
  String fromDateAsString = "";
  String toDateAsString = "";
  DateTime fromDate;
  DateTime toDate;

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
  String mainWalletBalance = "";
  String atmWalletBalance = "";

  @override
  void initState() {
    super.initState();
    rechargeType = widget.rechargeType;

    currentDate = DateTime.now();
    currentDateAsString =
        '${currentDate.day}/${currentDate.month}/${currentDate.year}';
    fromDateAsString = currentDateAsString;
    toDateAsString = currentDateAsString;
    fromDate = currentDate;
    toDate = currentDate;

    SharedPreferences.getInstance().then((sharedPrefs) {
      authToken = sharedPrefs.getString(Constants.SHARED_PREF_TOKEN);
      mainWalletBalance =
          sharedPrefs.getString(Constants.SHARED_PREF_MAIN_WALLET_BALANCE);
      atmWalletBalance =
          sharedPrefs.getString(Constants.SHARED_PREF_ATM_BALANCE);

      if (rechargeType == RechargeTypes.PREPAID) {
        fetchRechargeReports();
        getPrepaidList();
      } else if (rechargeType == RechargeTypes.DTH) {
        getDTHOperators();
      }
    });

    mobileNumberController = TextEditingController();
    amountController = TextEditingController();
    subscriberIdController = TextEditingController();
  }

  void fetchRechargeReports() {
    HTTPService().getRechargeReport(authToken, '', '', '').then((response) {
      setState(() {
        _showProgress = false;
      });

      if (response.statusCode == 200) {
        RechargeReportResponseModel responseModel =
            RechargeReportResponseModel.fromJson(json.decode(response.body));
        if (responseModel.status) {
          setState(() {
            rechargeReportList = responseModel.data;
          });
        } else {
          // showErrorDialog('Error occurred ${response.statusCode}');
        }
      } else {
        // showErrorDialog('Error occurred ${response.statusCode}');
      }
    });
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
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
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
                        height: 10,
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
                              height: 10,
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
                        height: 10,
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
                        height: 20,
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
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.all(5),
                              child: Material(
                                elevation: 8,
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: EdgeInsets.fromLTRB(12, 12, 12, 5),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'Txn Id: ',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              rechargeReportList[index]
                                                          .trxnId ==
                                                      null
                                                  ? ''
                                                  : rechargeReportList[index]
                                                      .trxnId,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'Mob Number: ',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              rechargeReportList[index]
                                                          .mobileNo ==
                                                      null
                                                  ? ''
                                                  : rechargeReportList[index]
                                                      .mobileNo,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'Amount: ',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              rechargeReportList[index]
                                                          .amount ==
                                                      null
                                                  ? ''
                                                  : '\u20B9${rechargeReportList[index].amount}',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'Date: ',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              rechargeReportList[index]
                                                          .createDate ==
                                                      null
                                                  ? ''
                                                  : '${rechargeReportList[index].createDate.substring(0, 10)} ${UtilityMethods().beautifyTime(rechargeReportList[index].createDate.substring(12))}',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        padding:
                                            EdgeInsets.fromLTRB(5, 10, 5, 0),
                                        child: Text(
                                          rechargeReportList[index].status,
                                          style: TextStyle(
                                              color: rechargeReportList[index]
                                                          .status
                                                          .toLowerCase() ==
                                                      'fail'
                                                  ? Colors.red
                                                  : Colors.green,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                      // Container(
                                      //     width: double.infinity,
                                      //     child: Row(
                                      //       mainAxisAlignment:
                                      //           MainAxisAlignment.center,
                                      //       children: [
                                      //         MaterialButton(
                                      //           onPressed: () {
                                      //             printReceipt(
                                      //                 rechargeReportList[
                                      //                     index]);
                                      //           },
                                      //           child: Row(
                                      //             children: [
                                      //               Image.asset(
                                      //                 'images/ic_printer.png',
                                      //                 height: 20,
                                      //                 width: 20,
                                      //               ),
                                      //               SizedBox(
                                      //                 width: 10,
                                      //               ),
                                      //               Text(
                                      //                 'Print',
                                      //                 style: TextStyle(
                                      //                   color: Colors.black,
                                      //                   fontSize: 16,
                                      //                 ),
                                      //               ),
                                      //             ],
                                      //           ),
                                      //           color: Colors.white,
                                      //           shape: RoundedRectangleBorder(
                                      //             borderRadius:
                                      //                 BorderRadius.circular(12),
                                      //           ),
                                      //         ),
                                      //         SizedBox(
                                      //           width: 10,
                                      //         ),
                                      //         MaterialButton(
                                      //           onPressed: () {
                                      //             showComplainDialog(index);
                                      //           },
                                      //           child: Text(
                                      //             'Complain',
                                      //             style: TextStyle(
                                      //               color: Colors.white,
                                      //             ),
                                      //           ),
                                      //           color: Colors.redAccent,
                                      //           shape: RoundedRectangleBorder(
                                      //             borderRadius:
                                      //                 BorderRadius.circular(12),
                                      //           ),
                                      //         ),
                                      //       ],
                                      //     ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          itemCount: rechargeReportList.length,
                          shrinkWrap: true,
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
    Navigator.of(context).pushReplacement(ScaleRoute(page: DashboardScreen()));
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
                height: 190,
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
      int balance = double.parse(mainWalletBalance).toInt();
      if (amount <= balance) {
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

            try {
              PrepaidRechargeResponseModel model =
                  PrepaidRechargeResponseModel.fromJson(
                      json.decode(responseModel.message));

              PrepaidRechargeResponseData responseData = model.data;

              if (responseData.status.toLowerCase() != "failure") {
                showSuccess('Your recharge of Rs.$amount is successful');
              } else {
                showErrorDialog('Recharge request failed');
              }
            } catch (exception) {
              showErrorDialog('Recharge request failed');
            }
            // PrepaidRechargeResponseData.fromJson(
            //     json.decode((model.data).toString()));
          } else {
            showServerError(
                'Our servers encountered an error. Please try again later');
            print(response.statusCode);
          }
        });
      } else {
        showErrorDialog('Not enough balance in main wallet');
      }
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

          try {
            PrepaidRechargeResponseModel model =
                PrepaidRechargeResponseModel.fromJson(
                    json.decode(responseModel.message));

            PrepaidRechargeResponseData responseData = model.data;

            // PrepaidRechargeResponseData.fromJson(
            //     json.decode((model.data).toString()));

            if (responseData.status.toLowerCase() != "failure") {
              showSuccess('Your recharge of Rs.$amount is successful');
            } else {
              showErrorDialog('Recharge request failed');
            }
          } catch (exception) {
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

  void showComplainDialog(int index) {
    showDialog(
        context: context,
        builder: (buildContext) {
          return StatefulBuilder(builder: (context, setState) {
            return CustomAlertDialog(
              content: Container(
                  height: 220,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Color(0xfffffff1)),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: DropdownButton(
                            isExpanded: true,
                            onChanged: (value) {
                              setState(() {
                                complainStatus = value;
                              });
                            },
                            value: complainStatus,
                            items: listOfStatus.map((e) {
                              return DropdownMenuItem(
                                child: Text(
                                  e,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                                ),
                                value: e,
                              );
                            }).toList(),
                          ),
                          margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: 'Complain Description',
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.normal),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.3),
                          ),
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                          controller: descController,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        _showComplaintProgress
                            ? CircularProgressIndicator()
                            : Container(
                                alignment: Alignment.center,
                                child: MaterialButton(
                                  onPressed: () {
                                    complainDescription =
                                        descController.text.trim();
                                    if (listOfStatus.contains(complainStatus) &&
                                        complainDescription.isNotEmpty) {
                                      setState(() {
                                        _showComplaintProgress = true;
                                      });

                                      HTTPService()
                                          .sendReportComplain(
                                              authToken,
                                              complainStatus,
                                              complainDescription,
                                              index.toString())
                                          .then((response) {
                                        setState(() {
                                          _showComplaintProgress = false;
                                        });

                                        Navigator.of(context).pop();

                                        if (response.statusCode == 200) {
                                          BasicResponseModel responseModel =
                                              BasicResponseModel.fromJson(
                                                  json.decode(response.body));
                                          if (responseModel.status) {
                                            setState(() {
                                              descController.text = "";
                                            });
                                            showSuccessDialog(
                                                context, responseModel.message);
                                          } else {
                                            showErrorDialog(
                                                responseModel.message);
                                          }
                                        } else {
                                          showErrorDialog(
                                              'Error occurred ${response.statusCode}');
                                        }
                                      });
                                    }
                                  },
                                  color: Color(0xff133374),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'Submit',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  )),
            );
          });
        });
  }

  void showSuccessDialog(BuildContext buildContext, String message) {
    if (mounted) {
      showDialog(
          context: buildContext,
          builder: (buildContext) {
            return CustomAlertDialog(
              contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              content: Container(
                width: 80,
                height: 200,
                decoration: new BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: const Color(0xFFFFFF),
                  borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Image.asset(
                          'images/ic_success.png',
                          height: 40,
                          width: 40,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                        child: Text(
                          message,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
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
                    )
                  ],
                ),
              ),
            );
          });
    }
  }

  void printReceipt(RechargeReportResponseData rechargeReportList) async {
    final doc = pw.Document();
    // ImageProvider image = Image.asset('images/').image;
    ImageProvider image = AssetImage('images/ic_logo.png');

    doc.addPage(pw.Page(build: (pw.Context context) {
      return pw.Center(
        child: pw.SizedBox(
          height: 400,
          width: 500,
          child: pw.Container(
            width: 500,
            alignment: pw.Alignment.center,
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text('Transaction Receipt',
                    style: pw.TextStyle(
                      fontSize: 20,
                    )),
                pw.SizedBox(height: 10),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text('Transaction Id'),
                      pw.Text(
                          rechargeReportList.trxnId != null
                              ? rechargeReportList.trxnId
                              : '',
                          style: pw.TextStyle(
                            fontSize: 18,
                          )),
                    ]),
                pw.SizedBox(height: 10),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text('Transaction Amount'),
                      pw.Text(
                          rechargeReportList.amount != null
                              ? rechargeReportList.amount
                              : '',
                          style: pw.TextStyle(
                            fontSize: 18,
                          )),
                    ]),
                pw.SizedBox(height: 10),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text('Transaction Date'),
                      pw.Text(
                          rechargeReportList.createDate != null
                              ? UtilityMethods().beautifyDateTime(
                                  rechargeReportList.createDate)
                              : '',
                          style: pw.TextStyle(
                            fontSize: 18,
                          )),
                    ]),
                pw.SizedBox(height: 10),
                pw.Container(
                  child: pw.Text('Thank You',
                      style: pw.TextStyle(
                        fontSize: 30,
                      )),
                ),
              ],
            ),
          ),
        ),
      );
    })); // Page

    await Printing.layoutPdf(onLayout: (pdfPageFormat) {
      return doc.save();
    });
  }
}
