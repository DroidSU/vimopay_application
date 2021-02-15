import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vimopay_application/customs/constants.dart';
import 'package:vimopay_application/customs/custom_dialog.dart';
import 'package:vimopay_application/network/http_service.dart';
import 'package:vimopay_application/network/models/basic_response_model.dart';
import 'package:vimopay_application/network/models/get_bank_details_response_model.dart';

class EditBankDetailScreen extends StatefulWidget {
  @override
  _EditBankDetailScreenState createState() => _EditBankDetailScreenState();
}

class _EditBankDetailScreenState extends State<EditBankDetailScreen> {
  String bankName = "";
  String accountNumber = "";
  String IFSC = "";
  String accountHolderName = "";
  String authToken = "";

  TextEditingController bankNameController;
  TextEditingController accountNumberController;
  TextEditingController ifscController;
  TextEditingController holderNameController;

  bool _showProgress = false;
  bool _showFetchingDetails = true;

  @override
  void initState() {
    super.initState();
    bankNameController = TextEditingController();
    accountNumberController = TextEditingController();
    ifscController = TextEditingController();
    holderNameController = TextEditingController();
    getUserDetails();
  }

  @override
  void dispose() {
    bankNameController.dispose();
    accountNumberController.dispose();
    ifscController.dispose();
    holderNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: SafeArea(
          child: Scaffold(
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
                        'Bank Details',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    // Container(
                    //   child: InkWell(
                    //     child: Text(
                    //       'Logout',
                    //       style: TextStyle(
                    //           color: Colors.white,
                    //           fontWeight: FontWeight.bold,
                    //           fontSize: 18),
                    //     ),
                    //     onTap: () {
                    //       logoutUser();
                    //     },
                    //   ),
                    //   width: 75,
                    // ),
                    // SizedBox(
                    //   width: 10,
                    // ),
                  ],
                ),
              ),
            ),
            body: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/bg_7.png'),
                      ),
                    ),
                  ),
                ),
                _showFetchingDetails
                    ? Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      )
                    : SingleChildScrollView(
                        child: Container(
                        margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
                        child: Column(
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                fillColor: Colors.grey.withOpacity(0.3),
                                filled: true,
                                hintText: 'Bank Name',
                                hintStyle: TextStyle(
                                    color: Colors.black54.withOpacity(0.3),
                                    fontFamily: 'Segoe'),
                              ),
                              controller: bankNameController,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                fillColor: Colors.grey.withOpacity(0.3),
                                filled: true,
                                hintText: 'Account Number',
                                hintStyle: TextStyle(
                                    color: Colors.black54.withOpacity(0.3),
                                    fontFamily: 'Segoe'),
                              ),
                              controller: accountNumberController,
                              keyboardType: TextInputType.number,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                fillColor: Colors.grey.withOpacity(0.3),
                                filled: true,
                                hintText: 'IFSC',
                                hintStyle: TextStyle(
                                    color: Colors.black54.withOpacity(0.3),
                                    fontFamily: 'Segoe'),
                              ),
                              controller: ifscController,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                fillColor: Colors.grey.withOpacity(0.3),
                                filled: true,
                                hintText: 'Account Holder Name',
                                hintStyle: TextStyle(
                                    color: Colors.black54.withOpacity(0.3),
                                    fontFamily: 'Segoe'),
                              ),
                              controller: holderNameController,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            _showProgress
                                ? CircularProgressIndicator()
                                : MaterialButton(
                                    onPressed: () {
                                      updateBankDetails();
                                    },
                                    minWidth: 200,
                                    child: Text(
                                      'Save',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                    color: Colors.blue[900],
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      )),
              ],
            ),
          ),
        ),
        onWillPop: onBackPressed);
  }

  Future<bool> onBackPressed() async {
    Navigator.of(context).pop();
    return true;
  }

  void logoutUser() {
    SharedPreferences.getInstance().then((sharedPrefs) {
      sharedPrefs.clear();
    });
  }

  void updateBankDetails() {
    bankName = bankNameController.text.trim();
    accountNumber = accountNumberController.text.trim();
    IFSC = ifscController.text.trim();
    accountHolderName = holderNameController.text.trim();

    setState(() {
      _showProgress = true;
    });

    HTTPService()
        .updateBankDetails(
            authToken, bankName, accountNumber, IFSC, accountHolderName)
        .then((response) {
      setState(() {
        _showProgress = false;
      });

      if (response.statusCode == 200) {
        BasicResponseModel basicResponseModel =
            BasicResponseModel.fromJson(json.decode(response.body));

        if (basicResponseModel.status) {
          // JUST SHOW DIALOG. UPDATE STORED VALUES WHEN DATA FETCHED FROM API
          showSuccessDialog(
              context, 'Bank details update waiting to be approved by user');
        } else {
          showErrorDialog(basicResponseModel.message);
        }
      } else {
        showErrorDialog('Something went wrong! Error ${response.statusCode}');
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
                          message == null
                              ? 'Error occurred. Please check logs.'
                              : message,
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

  void getUserDetails() {
    SharedPreferences.getInstance().then((sharedPrefs) {
      authToken = sharedPrefs.getString(Constants.SHARED_PREF_TOKEN);

      HTTPService().getBankDetails(authToken).then((response) {
        setState(() {
          _showFetchingDetails = false;
        });

        if (response.statusCode == 200) {
          GetBankDetailsResponseModel responseModel =
              GetBankDetailsResponseModel.fromJson(json.decode(response.body));
          if (responseModel.status) {
            setState(() {
              SharedPreferences.getInstance().then((sharedPrefs) {
                sharedPrefs.setString(Constants.SHARED_PREF_BANK_NAME,
                    responseModel.data.bankname);
                sharedPrefs.setString(Constants.SHARED_PREF_ACCOUNT_NUMBER,
                    responseModel.data.acno);
                sharedPrefs.setString(
                    Constants.SHARED_PREF_IFSC_CODE, responseModel.data.ifsc);
                sharedPrefs.setString(Constants.SHARED_PREF_HOLDER_NAME,
                    responseModel.data.acholder);

                bankNameController.text = responseModel.data.bankname;
                accountNumberController.text = responseModel.data.acno;
                ifscController.text = responseModel.data.ifsc;
                holderNameController.text = responseModel.data.acholder;
              });
            });
          } else {
            showErrorDialog(responseModel.message);
          }
        } else {
          showErrorDialog('Server Error code ${response.statusCode}');
        }
      });
    });
  }
}
