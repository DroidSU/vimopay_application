import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vimopay_application/customs/constants.dart';
import 'package:vimopay_application/customs/custom_dialog.dart';
import 'package:vimopay_application/network/http_service.dart';
import 'package:vimopay_application/network/models/basic_response_model.dart';

class MoneyTransferScreen extends StatefulWidget {
  @override
  _MoneyTransferScreenState createState() => _MoneyTransferScreenState();
}

class _MoneyTransferScreenState extends State<MoneyTransferScreen> {
  String accountNumber = "";
  String ifscCode = "";
  String authToken = "";
  String beneficiaryName = "";

  TextEditingController accountNumberController;
  TextEditingController ifscController;
  TextEditingController beneficiaryController;

  bool _isVerifiedIFSC = false;

  @override
  void initState() {
    super.initState();

    getUserDetails();

    accountNumberController = TextEditingController();
    ifscController = TextEditingController();
    beneficiaryController = TextEditingController();
  }

  @override
  void dispose() {
    accountNumberController.dispose();
    ifscController.dispose();
    beneficiaryController.dispose();

    super.dispose();
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
                            'Money Transfer',
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
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
              padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Container(
                    child: Text(
                      'Account Number:',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                    width: MediaQuery.of(context).size.width,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              BorderSide(color: Colors.black, width: 0.5)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              BorderSide(color: Colors.black, width: 0.5)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              BorderSide(color: Colors.black, width: 0.5)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              BorderSide(color: Colors.black, width: 0.5)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              BorderSide(color: Colors.black, width: 0.5)),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              BorderSide(color: Colors.black, width: 0.5)),
                      hintText: 'Account Number',
                      hintStyle: TextStyle(
                          color: Colors.grey.withOpacity(0.3),
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      filled: false,
                    ),
                    controller: accountNumberController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.normal),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Text(
                      'IFSC Code:',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                    width: MediaQuery.of(context).size.width,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Stack(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                    color: Colors.black, width: 0.5)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                    color: Colors.black, width: 0.5)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                    color: Colors.black, width: 0.5)),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                    color: Colors.black, width: 0.5)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                    color: Colors.black, width: 0.5)),
                            disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                    color: Colors.black, width: 0.5)),
                            hintText: 'IFSC Code',
                            hintStyle: TextStyle(
                                color: Colors.grey.withOpacity(0.3),
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            filled: false,
                            suffixIcon: _isVerifiedIFSC
                                ? Icon(
                                    Icons.verified_rounded,
                                    color: Colors.green,
                                  )
                                : null,
                          ),
                          controller: ifscController,
                          textCapitalization: TextCapitalization.characters,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.normal),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(11)
                          ],
                          // onChanged: (value) {
                          //   if (value.length == 11) {
                          //     ifscCode = ifscController.text.trim();
                          //     accountNumber = accountNumberController.text.trim();
                          //     verifyIFSC();
                          //   }
                          // },
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: MaterialButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (buildContext) {
                                    return CustomAlertDialog(
                                      content: Container(
                                        height: 160,
                                        child: Column(
                                          children: [
                                            Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                'You need to pay verification charge of Rs 4.00, Are you sure you want to continue with verification?',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                MaterialButton(
                                                  child: Text(
                                                    'Yes',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    verifyIFSC();
                                                  },
                                                  color: Colors.green,
                                                ),
                                                MaterialButton(
                                                  child: Text(
                                                    'No',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  color: Colors.red,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            },
                            child: Text(
                              'Verify',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            color: Color(0xff133374),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _isVerifiedIFSC
                      ? Container(
                          child: Column(
                            children: [
                              Text(
                                'Beneficiary Name',
                                style: TextStyle(
                                    color: Colors.grey.withOpacity(0.3)),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 0.5)),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 0.5)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 0.5)),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 0.5)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 0.5)),
                                  disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 0.5)),
                                  hintText: 'Beneficiary Name',
                                  hintStyle: TextStyle(
                                      color: Colors.grey.withOpacity(0.3),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  filled: false,
                                ),
                                controller: beneficiaryController,
                                keyboardType: TextInputType.name,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal),
                                // onChanged: (value) {
                                //   if (value.length == 11) {
                                //     ifscCode = ifscController.text.trim();
                                //     accountNumber = accountNumberController.text.trim();
                                //     verifyIFSC();
                                //   }
                                // },
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        )),
        onWillPop: onBackPressed);
  }

  Future<bool> onBackPressed() async {
    Navigator.of(context).pop();
    return true;
  }

  void verifyIFSC() {
    accountNumber = accountNumberController.text.trim();
    ifscCode = ifscController.text.trim();
    if (accountNumber.isNotEmpty &&
        ifscCode.isNotEmpty &&
        ifscCode.length == 11) {
      HTTPService()
          .verifyIFSC(authToken, ifscCode, accountNumber)
          .then((response) {
        if (response.statusCode == 200) {
          BasicResponseModel responseModel =
              BasicResponseModel.fromJson(json.decode(response.body));
          if (responseModel.status) {
            setState(() {
              _isVerifiedIFSC = true;
            });
          } else {
            showErrorDialog(responseModel.message);
          }
        } else {
          showErrorDialog('Server error occurred');
        }
      });
    } else {
      showErrorDialog('Invalid IFSC');
    }
  }

  void getUserDetails() {
    SharedPreferences.getInstance().then((sharedPrefs) {
      authToken = sharedPrefs.getString(Constants.SHARED_PREF_TOKEN);
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
