import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vimopay_application/customs/constants.dart';
import 'package:vimopay_application/customs/custom_dialog.dart';
import 'package:vimopay_application/customs/utility_methods.dart';
import 'package:vimopay_application/network/http_service.dart';
import 'package:vimopay_application/network/models/atm_report_response_data.dart';
import 'package:vimopay_application/network/models/atm_report_response_model.dart';

class ATMTransactionReportScreen extends StatefulWidget {
  @override
  _ATMTransactionReportScreenState createState() =>
      _ATMTransactionReportScreenState();
}

class _ATMTransactionReportScreenState
    extends State<ATMTransactionReportScreen> {
  bool _showProgress = false;
  String authToken = "";
  List<ATMRechargeReportData> atmTransactionsList = List();

  List<String> listOfTxnStatus = ['Pending', 'Success', 'Fail'];
  String txnStatus = "1";
  String selectedStatus = "Pending";

  String currentDateAsString = "";
  DateTime currentDate;
  String fromDateAsString = "";
  String toDateAsString = "";
  DateTime fromDate;
  DateTime toDate;

  @override
  void initState() {
    super.initState();

    currentDate = DateTime.now();
    currentDateAsString =
        '${currentDate.day}/${currentDate.month}/${currentDate.year}';
    fromDateAsString = currentDateAsString;
    toDateAsString = currentDateAsString;
    fromDate = currentDate;
    toDate = currentDate;

    SharedPreferences.getInstance().then((sharedPrefs) {
      authToken = sharedPrefs.getString(Constants.SHARED_PREF_TOKEN);

      fetchATMTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size(double.infinity, 100),
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        'images/header_bg.png',
                      ))),
              child: Row(
                children: [
                  Container(
                      width: 60,
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
                  Expanded(
                    child: Text(
                      'ATM Wallet Transaction Report',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Container(
              child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 150,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('From Date'),
                              Container(
                                  height: 35,
                                  margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.black54,
                                    ),
                                  ),
                                  child: InkWell(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.calendar_today_outlined,
                                          size: 20,
                                          color: Colors.black54,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          fromDateAsString,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      showDatePicker(
                                              context: context,
                                              initialDate: fromDate,
                                              firstDate: fromDate.subtract(
                                                  Duration(days: 365)),
                                              lastDate: currentDate)
                                          .then((selectedDate) {
                                        if (selectedDate != null) {
                                          setState(() {
                                            fromDate = selectedDate;
                                            fromDateAsString =
                                                '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';

                                            atmTransactionsList.clear();
                                          });

                                          fetchATMTransactions();
                                        }
                                      });
                                    },
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('To Date'),
                              Container(
                                  height: 35,
                                  margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.black54,
                                    ),
                                  ),
                                  child: InkWell(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.calendar_today_outlined,
                                          size: 20,
                                          color: Colors.black54,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          toDateAsString,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      showDatePicker(
                                              context: context,
                                              initialDate: toDate,
                                              firstDate: toDate.subtract(
                                                  Duration(days: 365)),
                                              lastDate: toDate)
                                          .then((selectedDate) {
                                        if (selectedDate != null) {
                                          setState(() {
                                            toDate = selectedDate;
                                            toDateAsString =
                                                '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';

                                            atmTransactionsList.clear();
                                          });

                                          fetchATMTransactions();
                                        }
                                      });
                                    },
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.black54,
                        ),
                      ),
                      width: 120,
                      height: 40,
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          isExpanded: true,
                          elevation: 10,
                          value: selectedStatus,
                          items: listOfTxnStatus.map((status) {
                            return DropdownMenuItem<String>(
                              child: Text(
                                status,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              value: status,
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              if (value == "Pending")
                                txnStatus = '1';
                              else if (value == "Success")
                                txnStatus = '2';
                              else if (value == "Fail") txnStatus = '3';

                              atmTransactionsList.clear();
                            });

                            fetchATMTransactions();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _showProgress
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : atmTransactionsList.isEmpty
                      ? Expanded(
                          child: Container(
                            height: MediaQuery.of(context).size.height,
                            child: Center(
                              child: Text(
                                'No transactions to show',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemBuilder: (context, index) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: Material(
                                elevation: 8,
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: EdgeInsets.all(12),
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
                                              atmTransactionsList[index]
                                                          .trxnId ==
                                                      null
                                                  ? ''
                                                  : atmTransactionsList[index]
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
                                              atmTransactionsList[index]
                                                          .mobileNo ==
                                                      null
                                                  ? ''
                                                  : atmTransactionsList[index]
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
                                              atmTransactionsList[index]
                                                          .amount ==
                                                      null
                                                  ? ''
                                                  : '\u20B9${atmTransactionsList[index].amount}',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
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
                                              atmTransactionsList[index]
                                                          .createDate ==
                                                      null
                                                  ? ''
                                                  : '${atmTransactionsList[index].createDate.substring(0, 10)} ${UtilityMethods().beautifyTime(atmTransactionsList[index].createDate.substring(12))}',
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
                                          atmTransactionsList[index].status ==
                                                  '2'
                                              ? 'Success'
                                              : 'Failed',
                                          style: TextStyle(
                                              color: atmTransactionsList[index]
                                                          .status
                                                          .toLowerCase() ==
                                                      '2'
                                                  ? Colors.green
                                                  : Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerRight,
                                        child: MaterialButton(
                                          onPressed: () {},
                                          child: Text(
                                            'Complain',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          color: Colors.redAccent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          itemCount: atmTransactionsList.length,
                          shrinkWrap: true,
                        ),
            ],
          )),
        )),
        onWillPop: onBackPressed);
  }

  Future<bool> onBackPressed() async {
    Navigator.of(context).pop();
    return true;
  }

  void fetchATMTransactions() {
    setState(() {
      _showProgress = true;
    });

    HTTPService()
        .getATMReportsScreen(
            authToken, fromDateAsString, toDateAsString, txnStatus)
        .then((response) {
      setState(() {
        _showProgress = false;
      });
      if (response.statusCode == 200) {
        ATMReportResponseModel responseModel =
            ATMReportResponseModel.fromJson(json.decode(response.body));
        if (responseModel.status) {
          setState(() {
            atmTransactionsList = responseModel.data;
          });
        } else {
          showErrorDialog(responseModel.message);
        }
      } else {
        showErrorDialog('Error occurred ${response.statusCode}');
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
                        child: Icon(
                          Icons.error_outline_rounded,
                          size: 40,
                          color: Colors.red,
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
}