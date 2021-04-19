import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vimopay_application/customs/constants.dart';
import 'package:vimopay_application/customs/custom_dialog.dart';
import 'package:vimopay_application/network/http_service.dart';
import 'package:vimopay_application/network/models/admin_list_response_model.dart';
import 'package:vimopay_application/network/models/basic_response_model.dart';

class AddMoneyWalletScreen extends StatefulWidget {
  @override
  _AddMoneyWalletScreenState createState() => _AddMoneyWalletScreenState();
}

class _AddMoneyWalletScreenState extends State<AddMoneyWalletScreen> {
  String? authToken = "";

  List<AdminListResponseData>? listOfAdmins = [];
  List<String> listOfModes = [];
  AdminListResponseData? selectedAdmin;
  String? selectedMode = "";
  TextEditingController? refNumberController;
  TextEditingController? amountController;
  TextEditingController? noteController;
  bool _showProgress = false;
  String referenceNumber = "";
  String amount = "";
  String note = "";

  @override
  void initState() {
    super.initState();

    refNumberController = TextEditingController();
    amountController = TextEditingController();
    noteController = TextEditingController();

    SharedPreferences.getInstance().then((sharedPrefs) {
      authToken = sharedPrefs.getString(Constants.SHARED_PREF_TOKEN);

      getAdminList();
      getModeList();
    });
  }

  @override
  void dispose() {
    refNumberController!.dispose();
    amountController!.dispose();
    noteController!.dispose();
    super.dispose();
  }

  void getAdminList() {
    HTTPService().getAdminList(authToken!).then((response) {
      if (response.statusCode == 200) {
        AdminListResponseModel responseModel =
            AdminListResponseModel.fromJson(json.decode(response.body));
        if (responseModel.status!) {
          setState(() {
            listOfAdmins = responseModel.data;

            selectedAdmin = listOfAdmins![0];
          });
        } else {
          showErrorDialog(responseModel.message);
        }
      } else {
        showErrorDialog('Error occurred ${response.statusCode}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Color(0xfff1fafc),
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
                        'Add Money',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                decoration: BoxDecoration(
                    color: Color(0xfffffff1),
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choose an Admin',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    DropdownButton(
                      items: listOfAdmins!.map((element) {
                        return DropdownMenuItem(
                          child: Text(
                            '${element.adminname} (${element.admintype})',
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                          value: element,
                        );
                      }).toList(),
                      onChanged: (dynamic value) {
                        setState(() {
                          selectedAdmin = value;
                        });
                      },
                      value: selectedAdmin,
                      isExpanded: true,
                      elevation: 5,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Mode',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    DropdownButton(
                      items: listOfModes.map((element) {
                        return DropdownMenuItem(
                          child: Text(
                            element,
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                          value: element,
                        );
                      }).toList(),
                      onChanged: (dynamic value) {
                        setState(() {
                          selectedMode = value;
                        });
                      },
                      value: selectedMode,
                      isExpanded: true,
                      elevation: 5,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Ref. No.',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white60,
                      ),
                      controller: refNumberController,
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Amount',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 18),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white60,
                      ),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      controller: amountController,
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(30),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white60,
                        hintText: 'Note',
                        hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                            fontWeight: FontWeight.normal),
                      ),
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.center,
                      controller: noteController,
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: _showProgress
                            ? CircularProgressIndicator()
                            : MaterialButton(
                                elevation: 12,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                minWidth: 100,
                                height: 40,
                                onPressed: () {
                                  referenceNumber =
                                      refNumberController!.text.trim();
                                  amount = amountController!.text.trim();
                                  note = noteController!.text.trim();

                                  if (referenceNumber != null &&
                                      referenceNumber.isNotEmpty &&
                                      amount != null &&
                                      amount.isNotEmpty) {
                                    sendAddMoneyRequest();
                                  } else {
                                    if (referenceNumber == null ||
                                        referenceNumber.isEmpty) {
                                      showErrorDialog(
                                          'Reference number cannot be empty');
                                    } else
                                      showErrorDialog('Amount cannot be empty');
                                  }
                                },
                                child: Text(
                                  'Submit',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                ),
                                color: Color(0xff133374),
                              ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        onWillPop: onBackPressed);
  }

  Future<bool> onBackPressed() async {
    Navigator.of(context).pop();
    return true;
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
          });
    }
  }

  void getModeList() {
    setState(() {
      listOfModes = [
        'IMPS',
        'NEFT',
        'RTGS',
        'Cash Deposit',
        'Bank Transfer',
        'UPI'
      ];
      selectedMode = 'IMPS';
    });
  }

  void sendAddMoneyRequest() {
    setState(() {
      _showProgress = true;
    });
    HTTPService()
        .addMoneyRetailer(
            authToken: authToken!,
            adminId: selectedAdmin!.adminid.toString(),
            amount: amount,
            mode: selectedMode,
            note: note,
            referenceNumber: referenceNumber)
        .then((response) {
      setState(() {
        _showProgress = false;
      });
      if (response.statusCode == 200) {
        BasicResponseModel responseModel =
            BasicResponseModel.fromJson(json.decode(response.body));
        if (responseModel.status!) {
          resetUI();
          showSuccessDialog(context, responseModel.message);
        } else {
          showErrorDialog(responseModel.message);
        }
      } else {
        showErrorDialog('Error occurred ${response.statusCode}');
      }
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

  void resetUI() {
    setState(() {
      refNumberController!.text = '';
      referenceNumber = "";
      amountController!.text = "";
      amount = "";
      noteController!.text = "";
      note = "";
    });
  }
}
