import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vimopay_application/customs/constants.dart';
import 'package:vimopay_application/customs/custom_dialog.dart';
import 'package:vimopay_application/network/http_service.dart';
import 'package:vimopay_application/network/models/get_bank_details_response_model.dart';

class TransferToBankScreen extends StatefulWidget {
  String walletBalance;

  TransferToBankScreen({@required this.walletBalance});

  @override
  _TransferToBankScreenState createState() => _TransferToBankScreenState();
}

class _TransferToBankScreenState extends State<TransferToBankScreen> {
  String walletBalance = "";
  String holderName = "";
  String bankName = "";
  String accountNumber = "";
  String ifscCode = "";
  String authToken = "";
  String phoneNumber = "";

  bool _fetchBankDetailsProgress = false;
  bool _transferProgress = false;

  String selectedTransferMethod = "IMPS";
  TextEditingController _amountController;
  String amountToTransfer = "";

  @override
  void initState() {
    super.initState();
    walletBalance = widget.walletBalance;

    _amountController = TextEditingController();

    getAccountDetails();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: SafeArea(
            child: Scaffold(
          backgroundColor: Colors.white,
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
                      'Transfer To Bank',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Container(
              height: double.infinity,
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/bg_7.png'),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Available Balance : \u20B9$walletBalance',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Charges applicable for payout in bank',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'IMPS Charges :',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                '\u20B910',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'NEFT Charges :',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                '\u20B95',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Account Details',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            width: 280,
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: _fetchBankDetailsProgress
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'A/C Holder Name :',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            holderName != null
                                                ? holderName
                                                : 'Manoj',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Bank Name :',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            bankName != null
                                                ? bankName
                                                : 'HDFC',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Account Number :',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            accountNumber != null
                                                ? accountNumber
                                                : '06301140007287',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'IFSC Code :',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            ifscCode != null
                                                ? ifscCode
                                                : 'HDFC0000630',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Settle via',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Material(
                                      child: InkWell(
                                        child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(20, 8, 20, 8),
                                          child: Text(
                                            'IMPS',
                                            style: TextStyle(
                                              color: selectedTransferMethod ==
                                                      "IMPS"
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            selectedTransferMethod = "IMPS";
                                          });
                                        },
                                      ),
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      color: selectedTransferMethod == "IMPS"
                                          ? Color(0xff094ece)
                                          : Color(0xedffffff),
                                      shadowColor:
                                          selectedTransferMethod == "IMPS"
                                              ? Color(0x94094ece)
                                              : Color(0xedffffff),
                                    ),
                                    Material(
                                      child: InkWell(
                                        child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(20, 8, 20, 8),
                                          child: Text(
                                            'NEFT',
                                            style: TextStyle(
                                              color: selectedTransferMethod ==
                                                      "NEFT"
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            selectedTransferMethod = "NEFT";
                                          });
                                        },
                                      ),
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      color: selectedTransferMethod == "NEFT"
                                          ? Color(0xff094ece)
                                          : Color(0xedffffff),
                                      shadowColor:
                                          selectedTransferMethod == "NEFT"
                                              ? Color(0x94094ece)
                                              : Color(0xedffffff),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: 200,
                                height: 50,
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    disabledBorder: OutlineInputBorder(
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
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    hintText: 'Enter Amount',
                                    hintStyle: TextStyle(
                                        color: Colors.black54, fontSize: 14),
                                  ),
                                  controller: _amountController,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              _transferProgress
                                  ? CircularProgressIndicator()
                                  : MaterialButton(
                                      onPressed: () {
                                        amountToTransfer =
                                            _amountController.text.trim();
                                        startTransfer();
                                      },
                                      child: Text(
                                        'Submit',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                      padding: EdgeInsets.all(8),
                                      elevation: 10,
                                      color: Color(0x94094ece),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                            ],
                          )
                        ],
                      ),
                    ),
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

  void getAccountDetails() async {
    SharedPreferences.getInstance().then((sharedPrefs) {
      authToken = sharedPrefs.getString(Constants.SHARED_PREF_TOKEN);
      holderName = sharedPrefs.getString(Constants.SHARED_PREF_HOLDER_NAME);
      phoneNumber = sharedPrefs.getString(Constants.SHARED_PREF_MOBILE);

      if (holderName == null) {
        setState(() {
          _fetchBankDetailsProgress = true;
        });

        HTTPService().getBankDetails(authToken).then((response) {
          setState(() {
            _fetchBankDetailsProgress = false;
          });
          if (response.statusCode == 200) {
            GetBankDetailsResponseModel responseModel =
                GetBankDetailsResponseModel.fromJson(
                    json.decode(response.body));
            if (responseModel.status) {
              sharedPrefs.setString(
                  Constants.SHARED_PREF_BANK_NAME, responseModel.data.bankname);
              sharedPrefs.setString(Constants.SHARED_PREF_ACCOUNT_NUMBER,
                  responseModel.data.acno);
              sharedPrefs.setString(
                  Constants.SHARED_PREF_IFSC_CODE, responseModel.data.ifsc);
              sharedPrefs.setString(Constants.SHARED_PREF_HOLDER_NAME,
                  responseModel.data.acholder);

              setState(() {
                holderName = responseModel.data.acholder;
                bankName = responseModel.data.bankname;
                // accountNumber = responseModel.data.acno;
                // ifscCode = responseModel.data.ifsc;

                accountNumber = "919007076812";
                ifscCode = "PYTM0123456";
              });
            } else {}
          } else {
            showErrorDialog('Server Error code ${response.statusCode}');
          }
        });
      } else {
        setState(() {
          bankName = sharedPrefs.getString(Constants.SHARED_PREF_BANK_NAME);
          // accountNumber =
          //     sharedPrefs.getString(Constants.SHARED_PREF_ACCOUNT_NUMBER);
          // ifscCode = sharedPrefs.getString(Constants.SHARED_PREF_IFSC_CODE);

          accountNumber = "919007076812";
          ifscCode = "PYTM0123456";
        });
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

  void startTransfer() {
    if (double.parse(amountToTransfer) <= double.parse(walletBalance)) {
      String orderId = "";

      setState(() {
        _transferProgress = true;
      });

      HTTPService()
          .getChecksum(authToken, accountNumber, ifscCode, amountToTransfer)
          .then((response) {
        setState(() {
          _transferProgress = false;
        });
        if (response.statusCode == 200) {
          // GetChecksumResponseModel responseModel =
          //     GetChecksumResponseModel.fromJson(json.decode(response.body));
          // if (responseModel.status) {
          //   String checksum = responseModel.data.checksum;
          //   orderId = responseModel.data.orderid;
          //
          //   String MID = "VIMOPA31418806368491";
          //
          //   HTTPService()
          //       .initiatePayout(
          //           mid: MID,
          //           checkSum: checksum,
          //           amount: amountToTransfer,
          //           beneficiaryAccount: accountNumber,
          //           beneficiaryContactRefId: '',
          //           beneficiaryIFSC: ifscCode,
          //           beneficiaryVPA: '',
          //           date: '',
          //           orderId: orderId,
          //           phoneNumber: phoneNumber,
          //           purpose: 'OTHERS',
          //           transferMode: selectedTransferMethod)
          //       .then((response) {
          //     setState(() {
          //       _transferProgress = false;
          //     });
          //     if (response.statusCode == 200) {
          //     } else {
          //       showErrorDialog('Error occurred');
          //     }
          //   });
          // } else {
          //   setState(() {
          //     _transferProgress = false;
          //   });
          //   showErrorDialog(responseModel.message);
          // }
          showSuccessDialog(context, "Request Submitted!");
        } else {
          setState(() {
            _transferProgress = false;
          });
          showErrorDialog('Some error occurred');
        }
      });
    } else {
      showErrorDialog('Amount cannot be greater than wallet balance');
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
}
