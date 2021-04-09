import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vimopay_application/customs/constants.dart';
import 'package:vimopay_application/customs/custom_dialog.dart';
import 'package:vimopay_application/network/http_service.dart';
import 'package:vimopay_application/network/models/bbps_bill_fetch_failed_model.dart';
import 'package:vimopay_application/network/models/bbps_bill_fetched_response_model.dart';
import 'package:vimopay_application/network/models/bbps_bill_pay_response_model.dart';
import 'package:vimopay_application/network/models/bbps_login_failed_model.dart';
import 'package:vimopay_application/network/models/bbps_login_response_model.dart';
import 'package:vimopay_application/network/models/bbps_services_response_model.dart';
import 'package:vimopay_application/network/models/biller_list_response_model.dart';

class BBPSFastagRechargeScreen extends StatefulWidget {
  @override
  _BBPSFastagRechargeScreenState createState() =>
      _BBPSFastagRechargeScreenState();
}

class _BBPSFastagRechargeScreenState extends State<BBPSFastagRechargeScreen> {
  String jwt_token = "";
  String authToken = "";
  List<BillerListResponseData> listOfBillers;
  String mainWalletBalance = "";
  String selectedBillerName = "";
  String selectedBillerId = "";
  String fieldName = "";
  String fieldValue = "";
  String amount = "";
  String mobileNumber = "";
  String refId = "";

  TextEditingController fieldController;
  TextEditingController mobileNumberController;

  bool _isFetchingBill = false;
  bool _isBillFetched = false;
  bool _billPayInProgress = false;
  BBPSBillFetchResponseModel billModel;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((sharedPrefs) {
      authToken = sharedPrefs.getString(Constants.SHARED_PREF_TOKEN);
      mainWalletBalance =
          sharedPrefs.getString(Constants.SHARED_PREF_MAIN_WALLET_BALANCE);
    });

    fieldController = TextEditingController();
    mobileNumberController = TextEditingController();
    listOfBillers = List();

    generateAgentToken();
  }

  @override
  void dispose() {
    super.dispose();
    fieldController.dispose();
    mobileNumberController.dispose();
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
                            'Electricity Recharge',
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
                      ),
                    ),
                  ],
                )),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    'Biller Name',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18,
                    ),
                  ),
                  Container(
                    child: listOfBillers.isNotEmpty
                        ? DropdownButtonHideUnderline(
                            child: DropdownButton(
                              items: listOfBillers.map((biller) {
                                return DropdownMenuItem(
                                  child: Text(
                                    biller.cateName,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  value: biller.cateName,
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedBillerName = value;
                                  fieldController.clear();
                                  _isBillFetched = false;

                                  listOfBillers.forEach((biller) {
                                    if (biller.cateName == value) {
                                      setState(() {
                                        fieldName = biller.field;
                                        selectedBillerId = biller.value;
                                      });
                                    }
                                  });
                                });
                              },
                              value: selectedBillerName,
                              isExpanded: true,
                            ),
                          )
                        : Container(
                            child: CircularProgressIndicator(),
                          ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  fieldName.isNotEmpty
                      ? Text(
                          fieldName,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 18,
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: 8,
                  ),
                  fieldName.isNotEmpty
                      ? TextField(
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              hintText: fieldName,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              fillColor: Colors.transparent,
                              filled: true,
                              hintStyle: TextStyle(
                                  color: Colors.black54, fontSize: 16)),
                          controller: fieldController,
                        )
                      : Container(),
                  SizedBox(
                    height: 20,
                  ),
                  fieldName.isNotEmpty
                      ? Text(
                          "Customer Mobile Number",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 18,
                          ),
                        )
                      : Container(),
                  fieldName.isNotEmpty
                      ? SizedBox(
                          height: 8,
                        )
                      : Container(),
                  fieldName.isNotEmpty
                      ? TextField(
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            hintText: "Customer Mobile Number",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            fillColor: Colors.transparent,
                            filled: true,
                            hintStyle:
                                TextStyle(color: Colors.black54, fontSize: 16),
                          ),
                          controller: mobileNumberController,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                          ],
                        )
                      : Container(),
                  !_isBillFetched
                      ? Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: !_isFetchingBill
                              ? MaterialButton(
                                  onPressed: () {
                                    fieldValue = fieldController.text.trim();
                                    mobileNumber =
                                        mobileNumberController.text.trim();

                                    if (selectedBillerName.isNotEmpty &&
                                        fieldValue.isNotEmpty &&
                                        mobileNumber.length == 10) {
                                      setState(() {
                                        _isFetchingBill = true;
                                      });
                                      fetchBill();
                                    } else {
                                      if (selectedBillerName.isEmpty)
                                        showErrorDialog(
                                            'Please select a biller');
                                      else if (fieldValue.isNotEmpty)
                                        showErrorDialog(
                                            'Please enter $fieldName');
                                      else if (mobileNumber.length != 10)
                                        showErrorDialog(
                                            'Invalid mobile number');
                                    }
                                  },
                                  child: Text(
                                    'Fetch Bill',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  color: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  minWidth: 100,
                                )
                              : CircularProgressIndicator(),
                        )
                      : SizedBox(),
                  _isBillFetched
                      ? Container(
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Material(
                            elevation: 10,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Biller Id',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        billModel.data.billerDetails.billerId,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Customer Name',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Container(
                                        width: 150,
                                        child: Text(
                                          billModel
                                              .data.billDetails.customerName,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Due Date',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        billModel.data.billDetails.dueDate,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Total Amount',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        'Rs.${billModel.data.billDetails.amount.toString()}',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  _billPayInProgress
                                      ? CircularProgressIndicator()
                                      : MaterialButton(
                                          onPressed: () {
                                            double balance =
                                                double.parse(mainWalletBalance);
                                            double amt = double.parse(amount);
                                            if (balance > amt) {
                                              payBill();
                                            } else {
                                              showErrorDialog(
                                                  'Insufficient wallet balance');
                                            }
                                          },
                                          color: Colors.green,
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Text(
                                            'Pay now',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : SizedBox(),
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

  void generateAgentToken() {
    HTTPService().bbpsAgentLogin().then((response) {
      if (response.statusCode == 200) {
        BBPSLoginResponseModel responseModel =
            BBPSLoginResponseModel.fromJson(json.decode(response.body));
        jwt_token = responseModel.token;

        fetchFastagBillers();
      } else {
        BBPSLoginFailedModel loginFailedModel =
            BBPSLoginFailedModel.fromJson(json.decode(response.body));
        showErrorDialog(loginFailedModel.message);
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

  void fetchFastagBillers() {
    HTTPService().fetchBBPSBillers(authToken, '5').then((response) {
      if (response.statusCode == 200) {
        BillerListResponseModel responseModel =
            BillerListResponseModel.fromJson(json.decode(response.body));
        if (responseModel.status) {
          if (mounted) {
            setState(() {
              listOfBillers = responseModel.data;

              selectedBillerName = listOfBillers[0].cateName;
              fieldName = listOfBillers[0].field;
              selectedBillerId = listOfBillers[0].value;
            });
          }
        } else {}
      } else {
        showErrorDialog('Server error occurred ${response.statusCode}');
      }
    });
  }

  void fetchBill() {
    refId = (DateTime.now().millisecondsSinceEpoch).toString();

    HTTPService()
        .bbpsBillFetch(refId, fieldValue, selectedBillerId, jwt_token,
            mobileNumber, fieldName)
        .then((response) {
      setState(() {
        _isFetchingBill = false;
      });
      if (response.statusCode == 200) {
        BBPSBillFetchResponseModel responseModel =
            BBPSBillFetchResponseModel.fromJson(json.decode(response.body));
        if (responseModel.status.toLowerCase() == "success") {
          setState(() {
            _isBillFetched = true;
            billModel = responseModel;
            amount = billModel.data.billDetails.amount.toString();
          });
        } else {
          BBPSBillFetchFailed responseModel =
              BBPSBillFetchFailed.fromJson(json.decode(response.body));
          showErrorDialog(responseModel.message);
          print('Bill Fetch failed ${response.statusCode}');
        }
      } else {
        BBPSBillFetchFailed responseModel =
            BBPSBillFetchFailed.fromJson(json.decode(response.body));
        showErrorDialog(responseModel.message);
        print('Bill Fetch failed ${response.statusCode}');
      }
    });
  }

  void payBill() {
    setState(() {
      _billPayInProgress = true;
    });

    HTTPService()
        .payElectricityBill(
            jwt_token,
            billModel.refId,
            "",
            "",
            mobileNumber,
            amount,
            billModel.data.billerDetails.billerId,
            fieldName,
            fieldValue)
        .then((response) {
      setState(() {
        _billPayInProgress = false;
      });

      if (response.statusCode == 200) {
        BBPSBillPayResponseModel responseModel =
            BBPSBillPayResponseModel.fromJson(json.decode(response.body));
        if (responseModel.status == "SUCCESS") {
          showSuccess(responseModel.message);

          updateTransactionToServer(true);
        } else {
          showErrorDialog(responseModel.message);

          updateTransactionToServer(false);
        }
      } else {
        showErrorDialog("Bill payment failed");
      }
    });
  }

  void updateTransactionToServer(bool status) {
    String txnId = (DateTime.now().millisecondsSinceEpoch).toString();

    HTTPService()
        .bbpsBillPay(authToken, refId, selectedBillerName, amount,
            selectedBillerId, txnId, status)
        .then((response) {
      if (response.statusCode == 200) {
        BBPSServicesResponseModel responseModel =
            BBPSServicesResponseModel.fromJson(json.decode(response.body));
        if (responseModel.status) {
          // do nothing
          print('Transaction updated in the server');
        } else {
          print('Transaction could not be updated in server..');
        }
      } else {
        print('Transaction could not be updated in server..');
      }
    });
  }
}
