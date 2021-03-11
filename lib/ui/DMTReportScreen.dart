/*
 * Created by Sujoy Datta. Copyright (c) 2021. All rights reserved.
 *
 * To the person who is reading this..
 * When you finally understand how this works, please do explain it to me too at sujoydatta26@gmail.com
 * P.S.: In case you are planning to use this without mentioning me, you will be met with mean judgemental looks and sarcastic comments.
 */
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vimopay_application/customs/constants.dart';
import 'package:vimopay_application/network/http_service.dart';
import 'package:vimopay_application/network/models/dmt_report_response_model.dart';

class DMTReportScreen extends StatefulWidget {
  @override
  _DMTReportScreenState createState() => _DMTReportScreenState();
}

class _DMTReportScreenState extends State<DMTReportScreen> {
  int _pageState = 0;
  String authToken = "";
  bool _showProgress = false;
  List<VerifiedAccountsResponseData> listOfVerifiedAccounts = List();

  String currentDateAsString = "";
  DateTime currentDate;
  String fromDateAsString = "";
  String toDateAsString = "";
  DateTime fromDate;
  DateTime toDate;

  List<String> listOfStatus = ['Pending', 'Success', 'Fail'];
  String selectedStatus = "Pending";

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

                                              listOfVerifiedAccounts.clear();
                                            });

                                            if (_pageState == 1) {
                                              fetchVerifiedAccounts();
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

                                              listOfVerifiedAccounts.clear();
                                            });

                                            if (_pageState == 1) {
                                              fetchVerifiedAccounts();
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
                            onChanged: (value) {
                              setState(() {
                                selectedStatus = value;

                                listOfVerifiedAccounts.clear();
                              });

                              if (_pageState == 1) {
                                fetchVerifiedAccounts();
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 100,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Material(
                        child: InkWell(
                          child: Container(
                            child: Center(
                              child: Text(
                                'Verifications',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _pageState = 1;
                            });
                          },
                        ),
                      ),
                      Material(
                        child: InkWell(
                          child: Container(
                            child: Center(
                              child: Text(
                                'Transactions',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _pageState = 2;
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
                            ? listOfVerifiedAccounts.isNotEmpty
                                ? ListView.builder(
                                    itemBuilder: (context, index) {
                                      return Container(
                                        height: 200,
                                        child: Column(
                                          children: [
                                            Container(
                                              child: Text(
                                                'Account Number : ${listOfVerifiedAccounts[index].accNumber}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18),
                                              ),
                                            ),
                                            Container(
                                              child: Text(
                                                'Account Holder Name : ${listOfVerifiedAccounts[index].accName}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18),
                                              ),
                                            ),
                                            Container(
                                              child: Text(
                                                'IFSC Code : ${listOfVerifiedAccounts[index].ifsc}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    shrinkWrap: true,
                                    itemCount: listOfVerifiedAccounts.length,
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
                            : Container(),
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
    return true;
  }

  void getUserDetails() {
    SharedPreferences.getInstance().then((sharedPrefs) {
      authToken = sharedPrefs.getString(Constants.SHARED_PREF_TOKEN);

      fetchVerifiedAccounts();
    });
  }

  void fetchVerifiedAccounts() {
    setState(() {
      _showProgress = true;
      listOfVerifiedAccounts.clear();
    });
    HTTPService()
        .getVerifiedAccounts(
            authToken, fromDateAsString, toDateAsString, selectedStatus)
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
}
