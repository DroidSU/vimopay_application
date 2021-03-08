import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vimopay_application/customs/constants.dart';
import 'package:vimopay_application/customs/custom_dialog.dart';
import 'package:vimopay_application/network/http_service.dart';
import 'package:vimopay_application/network/models/basic_response_model.dart';
import 'package:vimopay_application/network/models/money_transfer_request_data.dart';
import 'package:vimopay_application/network/models/money_transfer_response_model.dart';

class MoneyTransferScreen extends StatefulWidget {
  @override
  _MoneyTransferScreenState createState() => _MoneyTransferScreenState();
}

class _MoneyTransferScreenState extends State<MoneyTransferScreen> {
  String accountNumber = "";
  String ifscCode = "";
  String authToken = "";
  String beneficiaryName = "";
  String amount = "";
  String mobileNumber = "";

  List<String> listOfModes = ['IMPS', 'NEFT', 'RTGS'];
  String mode = '';

  TextEditingController accountNumberController;
  TextEditingController ifscController;
  TextEditingController beneficiaryController;
  TextEditingController amountController;
  TextEditingController mobileController;

  bool _isVerifiedIFSC = false;
  bool _showProgress = false;
  bool _showProgress1 = false;
  String mainWalletBalance = "";

  @override
  void initState() {
    super.initState();

    getUserDetails();

    setState(() {
      mode = listOfModes[0];
    });

    accountNumberController = TextEditingController();
    ifscController = TextEditingController();
    beneficiaryController = TextEditingController();
    amountController = TextEditingController();
    mobileController = TextEditingController();
  }

  @override
  void dispose() {
    accountNumberController.dispose();
    ifscController.dispose();
    beneficiaryController.dispose();
    amountController.dispose();
    mobileController.dispose();

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
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Column(
                            children: [
                              Container(
                                child: Text(
                                  'Beneficiary Name',
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
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                child: Text(
                                  'Amount',
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
                                  hintText: 'Amount',
                                  hintStyle: TextStyle(
                                      color: Colors.grey.withOpacity(0.3),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  filled: false,
                                ),
                                controller: amountController,
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
                                  'Mobile Number',
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
                                  hintText: 'Mobile Number',
                                  hintStyle: TextStyle(
                                      color: Colors.grey.withOpacity(0.3),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  filled: false,
                                ),
                                controller: mobileController,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                keyboardType: TextInputType.phone,
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
                                  'Mode',
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
                              DropdownButton(
                                isExpanded: true,
                                items: listOfModes.map((e) {
                                  return DropdownMenuItem(
                                    child: Text(
                                      e,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: ''),
                                    ),
                                    value: e,
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    mode = value;
                                  });
                                },
                                value: mode,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                                child: _showProgress
                                    ? CircularProgressIndicator()
                                    : MaterialButton(
                                        onPressed: () {
                                          startMoneyTransfer();
                                        },
                                        color: Color(0xff133374),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          'Submit',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                              )
                            ],
                          ),
                        )
                      : _showProgress1
                          ? Container(
                              child: Center(
                                child: CircularProgressIndicator(),
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
      setState(() {
        _showProgress1 = true;
      });

      HTTPService()
          .verifyIFSC(authToken, ifscCode, accountNumber)
          .then((response) {
        setState(() {
          _showProgress1 = false;
        });

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
      if (ifscCode.length != 11)
        showErrorDialog('Invalid IFSC');
      else
        showErrorDialog('Account number is empty');
    }
  }

  void getUserDetails() {
    SharedPreferences.getInstance().then((sharedPrefs) {
      authToken = sharedPrefs.getString(Constants.SHARED_PREF_TOKEN);
      mainWalletBalance =
          sharedPrefs.getString(Constants.SHARED_PREF_MAIN_WALLET_BALANCE);
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

  void startMoneyTransfer() {
    accountNumber = accountNumberController.text.trim();
    ifscCode = ifscController.text.trim();
    beneficiaryName = beneficiaryController.text.trim();
    amount = amountController.text.trim();
    mobileNumber = mobileController.text.trim();

    int balance = double.parse(mainWalletBalance).toInt();

    if (accountNumber.isNotEmpty &&
        ifscCode.isNotEmpty &&
        ifscCode.length == 11 &&
        beneficiaryName.isNotEmpty &&
        amount.isNotEmpty &&
        int.parse(amount) >= 10 &&
        mobileNumber.isNotEmpty &&
        mobileNumber.length == 10 &&
        int.parse(amount) <= balance) {
      setState(() {
        _showProgress = true;
      });

      HTTPService()
          .moneyTransfer(
              authToken: authToken,
              accountNumber: accountNumber,
              ifscCode: ifscCode,
              beneficiaryName: beneficiaryName,
              amount: amount,
              mode: mode,
              narration: '')
          .then((response) {
        setState(() {
          _showProgress = false;
        });
        if (response.statusCode == 200) {
          MoneyTransferResponseModel responseModel =
              MoneyTransferResponseModel.fromJson(json.decode(response.body));
          MoneyTransferRequestData requestData =
              MoneyTransferRequestData.fromJson(
                  json.decode(responseModel.message));
          if (responseModel.status) {
            String message =
                "Rs.${requestData.data.transferRequest.amount} transferred to ${requestData.data.transferRequest.beneficiaryAccountNumber}";
            showSuccess(message);
          } else {
            showErrorDialog(responseModel.message);
          }
        } else {
          showErrorDialog('Error occurred ${response.statusCode}');
        }
      });
    } else {
      if (accountNumber.isEmpty)
        showErrorDialog('Account number cannot be empty');
      else if (ifscCode.isEmpty || ifscCode.length != 11)
        showErrorDialog('Invalid IFSC code');
      else if (beneficiaryName.isEmpty)
        showErrorDialog('Beneficiary name cannot be empty');
      else if (amount.isEmpty)
        showErrorDialog('Amount cannot be empty');
      else if (int.parse(amount) < 10)
        showErrorDialog('Amount should be more than Rs.10');
      else if (mobileNumber.isEmpty || mobileNumber.length != 10)
        showErrorDialog('Invalid mobile number');
      else if (int.parse(amount) > balance)
        showErrorDialog('Not enough wallet balance');
    }
  }
}
