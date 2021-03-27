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
import 'package:vimopay_application/network/models/commission_report_response_data.dart';
import 'package:vimopay_application/network/models/commission_report_response_model.dart';

class CommissionReportScreen extends StatefulWidget {
  @override
  _CommissionReportScreenState createState() => _CommissionReportScreenState();
}

class _CommissionReportScreenState extends State<CommissionReportScreen> {
  bool _showProgresss = false;

  List<CommissionReportResponseData> commissionReportList = List();
  String authToken = "";

  List<String> listOfProducts = [
    'Mobile Prepaid',
    'Money Transfer',
    'Broadband Postpaid',
    'Cable TV',
    'DTH',
    'Electricity',
    'Fastag',
    'Gas',
    'Health Insurance',
    'Landline Postpaid',
    'Life Insurance',
    'Loan Repayment',
    'LPG Gas',
    'Mobile Postpaid',
    'Water',
  ];
  String selectedProducts = 'Mobile Prepaid';

  String currentDateAsString = "";
  DateTime currentDate;
  String fromDateAsString = "";
  String toDateAsString = "";
  DateTime fromDate;
  DateTime toDate;

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

    complainStatus = listOfStatus[0];
    descController = TextEditingController();

    SharedPreferences.getInstance().then((sharedPrefs) {
      authToken = sharedPrefs.getString(Constants.SHARED_PREF_TOKEN);

      fetchCommissionList();
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
                            'Commission Report',
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('From Date'),
                                      Container(
                                          height: 35,
                                          margin:
                                              EdgeInsets.fromLTRB(0, 5, 0, 0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
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
                                                      firstDate: fromDate
                                                          .subtract(Duration(
                                                              days: 365)),
                                                      lastDate: currentDate)
                                                  .then((selectedDate) {
                                                if (selectedDate != null) {
                                                  setState(() {
                                                    fromDate = selectedDate;
                                                    fromDateAsString =
                                                        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';

                                                    commissionReportList
                                                        .clear();
                                                  });
                                                  fetchCommissionList();
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('To Date'),
                                      Container(
                                          height: 35,
                                          margin:
                                              EdgeInsets.fromLTRB(0, 5, 0, 0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
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
                                                      firstDate:
                                                          toDate.subtract(
                                                        Duration(
                                                          days: 365,
                                                        ),
                                                      ),
                                                      lastDate: toDate)
                                                  .then((selectedDate) {
                                                if (selectedDate != null) {
                                                  setState(() {
                                                    toDate = selectedDate;
                                                    toDateAsString =
                                                        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';

                                                    commissionReportList
                                                        .clear();
                                                  });

                                                  fetchCommissionList();
                                                }
                                              });
                                            },
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Product'),
                                      DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          isExpanded: true,
                                          elevation: 10,
                                          value: selectedProducts,
                                          items: listOfProducts.map((product) {
                                            return DropdownMenuItem<String>(
                                              child: Text(
                                                product,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                              value: product,
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              selectedProducts = value;
                                              commissionReportList.clear();
                                            });
                                            fetchCommissionList();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      _showProgresss
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : commissionReportList.isEmpty
                              ? Expanded(
                                  child: Container(
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
                                      margin:
                                          EdgeInsets.fromLTRB(20, 10, 20, 10),
                                      child: Material(
                                        elevation: 8,
                                        borderRadius: BorderRadius.circular(12),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          padding: EdgeInsets.all(12),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      commissionReportList[
                                                              index]
                                                          .product,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 0, 10, 0),
                                                    child: Text(
                                                      commissionReportList[
                                                              index]
                                                          .type,
                                                      style: TextStyle(
                                                          color: Colors.green,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  Text(
                                                    '\u20B9${commissionReportList[index].commissionAmount}',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16),
                                                  )
                                                ],
                                              ),
                                              Container(
                                                  width: double.infinity,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      MaterialButton(
                                                        onPressed: () {
                                                          printReceipt(
                                                              commissionReportList[
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
                                                              style: TextStyle(
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
                                                                  .circular(12),
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
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        color: Colors.redAccent,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  itemCount: commissionReportList.length,
                                  shrinkWrap: true,
                                ),
                    ],
                  ),
                ))),
        onWillPop: onBackPressed);
  }

  Future<bool> onBackPressed() async {
    Navigator.of(context).pop();
    return true;
  }

  void fetchCommissionList() {
    setState(() {
      _showProgresss = true;
    });

    HTTPService()
        .getCommissionReport(
            authToken, fromDateAsString, toDateAsString, selectedProducts)
        .then((response) {
      setState(() {
        _showProgresss = false;
      });
      if (response.statusCode == 200) {
        CommissionReportResponseModel responseModel =
            CommissionReportResponseModel.fromJson(json.decode(response.body));
        if (responseModel.status) {
          setState(() {
            commissionReportList = responseModel.data;
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

  void printReceipt(CommissionReportResponseData commissionReport) async {
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
                      pw.Text('Transaction Amount'),
                      pw.Text(
                          commissionReport.commissionAmount != null
                              ? commissionReport.commissionAmount
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
                          commissionReport.cratedate != null
                              ? UtilityMethods()
                                  .beautifyDateTime(commissionReport.cratedate)
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
}
