/*
 * Created by Sujoy Datta. Copyright (c) 2021. All rights reserved.
 *
 * To the person who is reading this..
 * When you finally understand how this works, please do explain it to me too at sujoydatta26@gmail.com
 * P.S.: In case you are planning to use this without mentioning me, you will be met with mean judgemental looks and sarcastic comments.
 */
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vimopay_application/customs/constants.dart';
import 'package:vimopay_application/customs/custom_dialog.dart';
import 'package:vimopay_application/customs/utility_methods.dart';
import 'package:vimopay_application/network/http_service.dart';
import 'package:vimopay_application/network/models/basic_response_model.dart';
import 'package:vimopay_application/network/models/dmt_report_response_model.dart';
import 'package:vimopay_application/network/models/dmt_transaction_report_response_model.dart';

class DMTReportScreen extends StatefulWidget {
  @override
  _DMTReportScreenState createState() => _DMTReportScreenState();
}

class _DMTReportScreenState extends State<DMTReportScreen> {
  int _pageState = 1;
  String? authToken = "";
  bool _showProgress = false;
  List<VerifiedAccountsResponseData>? listOfVerifiedAccounts = [];
  List<DMTReportResponseData>? listOfReports = [];

  String currentDateAsString = "";
  DateTime? currentDate;
  String fromDateAsString = "";
  String toDateAsString = "";
  DateTime? fromDate;
  DateTime? toDate;

  List<String> listOfStatus = ['Success', 'Fail', 'Pending'];
  String? selectedStatus = "Success";

  String? complainStatus = "Please Refund";
  String complainDescription = "";
  TextEditingController? descController;
  bool _showComplaintProgress = false;
  List<String> listComplainStatus = [
    'Please Refund',
    'Recharge Error',
    'IP Address Wrong',
    'Show Low Balance',
    'Customize'
  ];

  @override
  void initState() {
    super.initState();

    complainStatus = listComplainStatus[0];
    descController = TextEditingController();

    currentDate = DateTime.now();
    currentDateAsString =
        '${currentDate!.day}-${currentDate!.month}-${currentDate!.year}';
    fromDateAsString = currentDateAsString;
    toDateAsString = currentDateAsString;
    fromDate = currentDate;
    toDate = currentDate;

    _pageState = 1;

    getUserDetails();
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
                      'DMT Report',
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
                                                initialDate: fromDate!,
                                                firstDate: fromDate!.subtract(
                                                    Duration(days: 365)),
                                                lastDate: currentDate!)
                                            .then((selectedDate) {
                                          if (selectedDate != null) {
                                            setState(() {
                                              fromDate = selectedDate;
                                              fromDateAsString =
                                                  '${selectedDate.day}-${selectedDate.month}-${selectedDate.year}';

                                              listOfVerifiedAccounts!.clear();
                                            });

                                            if (_pageState == 1) {
                                              fetchVerifiedAccounts();
                                            } else if (_pageState == 2) {
                                              fetchReports();
                                            }
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
                                                initialDate: toDate!,
                                                firstDate: toDate!.subtract(
                                                    Duration(days: 365)),
                                                lastDate: toDate!)
                                            .then((selectedDate) {
                                          if (selectedDate != null) {
                                            setState(() {
                                              toDate = selectedDate;
                                              toDateAsString =
                                                  '${selectedDate.day}-${selectedDate.month}-${selectedDate.year}';

                                              listOfVerifiedAccounts!.clear();
                                            });

                                            if (_pageState == 1) {
                                              fetchVerifiedAccounts();
                                            } else if (_pageState == 2) {
                                              fetchReports();
                                            }
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
                            items: listOfStatus.map((status) {
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
                            onChanged: (dynamic value) {
                              setState(() {
                                selectedStatus = value;

                                listOfVerifiedAccounts!.clear();
                              });

                              if (_pageState == 1) {
                                fetchVerifiedAccounts();
                              } else if (_pageState == 2) {
                                fetchReports();
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Material(
                        borderRadius: BorderRadius.circular(12),
                        color:
                            _pageState == 1 ? Colors.lightBlue : Colors.white,
                        child: InkWell(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                'Verifications',
                                style: TextStyle(
                                    color: _pageState == 1
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _pageState = 1;

                              fetchVerifiedAccounts();
                            });
                          },
                        ),
                      ),
                      VerticalDivider(
                        color: Colors.grey,
                      ),
                      Material(
                        borderRadius: BorderRadius.circular(12),
                        color:
                            _pageState == 2 ? Colors.lightBlue : Colors.white,
                        child: InkWell(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Text(
                                'Transactions',
                                style: TextStyle(
                                    color: _pageState == 2
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _pageState = 2;

                              fetchReports();
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    child: _showProgress
                        ? Center(
                            child: Container(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : _pageState == 1
                            ? listOfVerifiedAccounts!.isNotEmpty
                                ? ListView.builder(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    itemBuilder: (context, index) {
                                      return Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.all(15),
                                          child: Material(
                                              elevation: 10,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                padding: EdgeInsets.all(20),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            'Account Number',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            '${listOfVerifiedAccounts![index].accNumber}',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16),
                                                          ),
                                                        ),
                                                      ],
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            'Holder Name',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            '${listOfVerifiedAccounts![index].accName}',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16),
                                                          ),
                                                        ),
                                                      ],
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            'IFSC Code',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            '${listOfVerifiedAccounts![index].ifsc}',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16),
                                                          ),
                                                        ),
                                                      ],
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            'Date',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            UtilityMethods()
                                                                .beautifyDateTime(
                                                                    listOfVerifiedAccounts![
                                                                            index]
                                                                        .createDate!),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16),
                                                          ),
                                                        ),
                                                      ],
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        MaterialButton(
                                                          onPressed: () {
                                                            printReceipt(
                                                                listOfVerifiedAccounts![
                                                                    index]);
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Image.asset(
                                                                'images/ic_printer.png',
                                                                height: 20,
                                                                width: 20,
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Text(
                                                                'Print',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          color: Colors.white,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        MaterialButton(
                                                          onPressed: () {
                                                            showComplainDialog(
                                                                index);
                                                          },
                                                          child: Text(
                                                            'Complain',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          color:
                                                              Colors.redAccent,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              )));
                                    },
                                    shrinkWrap: true,
                                    itemCount: listOfVerifiedAccounts!.length,
                                  )
                                : Container(
                                    child: Center(
                                      child: Text(
                                        'Nothing to show',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                    ),
                                  )
                            : listOfReports!.isNotEmpty
                                ? ListView.builder(
                                    itemBuilder: (context, index) {
                                      return Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.all(15),
                                          child: Material(
                                              elevation: 10,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                padding: EdgeInsets.all(10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            'Beneficiary Name',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontSize: 14),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            '${listOfReports![index].beneficiaryName}',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16),
                                                          ),
                                                        ),
                                                      ],
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Column(
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            'Account Number',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontSize: 14),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            '${listOfReports![index].accName}',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16),
                                                          ),
                                                        ),
                                                      ],
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Column(
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            'Beneficiary IFSC',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontSize: 14),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            '${listOfReports![index].beneficiaryIFSC}',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16),
                                                          ),
                                                        ),
                                                      ],
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Column(
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            'Transaction Mode',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontSize: 14),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            '${listOfReports![index].pMode}',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16),
                                                          ),
                                                        ),
                                                      ],
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            'Date',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontSize: 14),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            UtilityMethods()
                                                                .beautifyDateTime(
                                                                    listOfReports![
                                                                            index]
                                                                        .createDate!),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16),
                                                          ),
                                                        ),
                                                      ],
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        MaterialButton(
                                                          onPressed: () {
                                                            printReceiptForReport(
                                                                listOfReports![
                                                                    index]);
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Image.asset(
                                                                'images/ic_printer.png',
                                                                height: 20,
                                                                width: 20,
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Text(
                                                                'Print',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          color: Colors.white,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        MaterialButton(
                                                          onPressed: () {
                                                            showComplainDialog(
                                                                index);
                                                          },
                                                          child: Text(
                                                            'Complain',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          color:
                                                              Colors.redAccent,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              )));
                                    },
                                    shrinkWrap: true,
                                    itemCount: listOfReports!.length,
                                  )
                                : Container(
                                    child: Center(
                                      child: Text(
                                        'Nothing to show',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                    ),
                                  ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      onWillPop: onBackPressed,
    );
  }

  Future<bool> onBackPressed() async {
    Navigator.of(context).pop();
    return true;
  }

  void getUserDetails() {
    SharedPreferences.getInstance().then((sharedPrefs) {
      authToken = sharedPrefs.getString(Constants.SHARED_PREF_TOKEN);

      if (_pageState == 1) {
        fetchVerifiedAccounts();
      } else if (_pageState == 2) {
        fetchReports();
      }
    });
  }

  void fetchVerifiedAccounts() {
    setState(() {
      _showProgress = true;
      listOfVerifiedAccounts!.clear();
    });
    HTTPService()
        .getVerifiedAccounts(
            authToken!, fromDateAsString, toDateAsString, selectedStatus)
        .then((response) {
      setState(() {
        _showProgress = false;
      });
      if (response.statusCode == 200) {
        VerifiedAccountResponseModel responseModel =
            VerifiedAccountResponseModel.fromJson(json.decode(response.body));
        setState(() {
          listOfVerifiedAccounts = responseModel.data;
        });
      } else {}
    });
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
                            onChanged: (dynamic value) {
                              setState(() {
                                complainStatus = value;
                              });
                            },
                            value: complainStatus,
                            items: listComplainStatus.map((e) {
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
                                        descController!.text.trim();
                                    if (listComplainStatus
                                            .contains(complainStatus) &&
                                        complainDescription.isNotEmpty) {
                                      setState(() {
                                        _showComplaintProgress = true;
                                      });

                                      HTTPService()
                                          .sendReportComplain(
                                              authToken!,
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
                                          if (responseModel.status!) {
                                            setState(() {
                                              descController!.text = "";
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
                                      borderRadius: BorderRadius.circular(10)),
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

  void showSuccessDialog(BuildContext buildContext, String? message) {
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
                          message!,
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

  void showErrorDialog(String? message) {
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
                        message!,
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
        },
      );
    }
  }

  void fetchReports() {
    setState(() {
      _showProgress = true;
      listOfVerifiedAccounts!.clear();
    });
    HTTPService()
        .getDMTReports(
            authToken!, fromDateAsString, toDateAsString, selectedStatus)
        .then((response) {
      setState(() {
        _showProgress = false;
      });
      if (response.statusCode == 200) {
        DMTTransactionsResponseModel responseModel =
            DMTTransactionsResponseModel.fromJson(json.decode(response.body));
        if (responseModel.status!) {
          setState(() {
            listOfReports = responseModel.data;
          });
        } else {}
      } else {}
    });
  }

  void printReceipt(
      VerifiedAccountsResponseData verifiedAccountsResponseData) async {
    final doc = pw.Document();
    // ImageProvider image = Image.asset('images/').image;
    ImageProvider image = AssetImage('images/ic_logo.png');

    doc.addPage(pw.Page(build: (context) {
      return pw.Center(
        child: pw.Text('Hello'),
      );
    }));

    await Printing.layoutPdf(onLayout: (pdfPageFormat) {
      return doc.save();
    });
  }

  void printReceiptForReport(DMTReportResponseData report) async {
    final doc = pw.Document();
    // ImageProvider image = Image.asset('images/').image;
    ImageProvider image = AssetImage('images/ic_logo.png');

    doc.addPage(pw.Page(build: (context) {
      return pw.Center(
        child: pw.Text('Hello'),
      );
    }));

    await Printing.layoutPdf(onLayout: (pdfPageFormat) {
      return doc.save();
    });
  }
}
