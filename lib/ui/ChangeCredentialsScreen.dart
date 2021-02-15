import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vimopay_application/customs/constants.dart';
import 'package:vimopay_application/customs/custom_dialog.dart';
import 'package:vimopay_application/network/http_service.dart';
import 'package:vimopay_application/network/models/basic_response_model.dart';

class ChangeCredentialsScreen extends StatefulWidget {
  @override
  _ChangeCredentialsScreenState createState() =>
      _ChangeCredentialsScreenState();
}

class _ChangeCredentialsScreenState extends State<ChangeCredentialsScreen> {
  TextEditingController mobileController;
  TextEditingController emailAddressController;

  bool _showMobileUpdateProgress = false;
  bool _showEmailUpdateProgress = false;

  String authToken = "";
  String mobileNumber = "";
  String email = "";
  String mobileOTP = "";
  String emailOTP = "";

  @override
  void initState() {
    super.initState();
    mobileController = TextEditingController();
    emailAddressController = TextEditingController();

    getUserDetails();
  }

  @override
  void dispose() {
    mobileController.dispose();
    emailAddressController.dispose();

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
                      'Change Credentials',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
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
              SingleChildScrollView(
                child: Container(
                    margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Column(
                      children: [
                        Container(
                            child: Column(
                          children: [
                            Container(
                              height: 60,
                              child: Stack(
                                children: [
                                  TextField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
                                      ),
                                      fillColor: Colors.grey.withOpacity(0.3),
                                      filled: true,
                                      hintText: 'Mobile Number',
                                      hintStyle: TextStyle(
                                          color:
                                              Colors.black54.withOpacity(0.3),
                                          fontFamily: 'Segoe'),
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(10),
                                    ],
                                    controller: mobileController,
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Material(
                                        elevation: 10,
                                        color: Colors.blue[900],
                                        borderRadius: BorderRadius.circular(10),
                                        child: InkWell(
                                          child: Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Text(
                                              'Change',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            ),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              mobileNumber =
                                                  mobileController.text.trim();
                                            });
                                            updateMobile(otp: '');
                                          },
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            _showMobileUpdateProgress
                                ? Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Please enter OTP sent to $mobileNumber',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        OTPTextField(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          keyboardType: TextInputType.number,
                                          textFieldAlignment:
                                              MainAxisAlignment.spaceAround,
                                          fieldWidth: 50,
                                          fieldStyle: FieldStyle.box,
                                          length: 6,
                                          style: TextStyle(fontSize: 16),
                                          onCompleted: (pin) {
                                            mobileOTP = pin;
                                            updateMobile(otp: mobileOTP);
                                          },
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        MaterialButton(
                                          onPressed: () {},
                                          child: Text(
                                            'Submit',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                          color: Color(0xff133374),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                          ],
                        )),
                        Container(
                            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: Column(
                              children: [
                                Container(
                                  height: 60,
                                  child: Stack(
                                    children: [
                                      TextField(
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            borderSide: BorderSide(
                                                color: Colors.transparent),
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            borderSide: BorderSide(
                                                color: Colors.transparent),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            borderSide: BorderSide(
                                                color: Colors.transparent),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            borderSide: BorderSide(
                                                color: Colors.transparent),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            borderSide: BorderSide(
                                                color: Colors.transparent),
                                          ),
                                          fillColor:
                                              Colors.grey.withOpacity(0.3),
                                          filled: true,
                                          hintText: 'Email Address',
                                          hintStyle: TextStyle(
                                              color: Colors.black54
                                                  .withOpacity(0.3),
                                              fontFamily: 'Segoe'),
                                        ),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        controller: emailAddressController,
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Material(
                                            elevation: 10,
                                            color: Colors.blue[900],
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: InkWell(
                                              child: Padding(
                                                padding: EdgeInsets.all(10),
                                                child: Text(
                                                  'Change',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16),
                                                ),
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  email = emailAddressController
                                                      .text
                                                      .trim();
                                                });

                                                updateEmail();
                                              },
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                _showEmailUpdateProgress
                                    ? Container(
                                        alignment: Alignment.center,
                                        margin:
                                            EdgeInsets.fromLTRB(10, 10, 10, 0),
                                        child: Column(
                                          children: [
                                            Text(
                                              'Please enter OTP sent to $email',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            OTPTextField(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              keyboardType:
                                                  TextInputType.number,
                                              textFieldAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              fieldWidth: 50,
                                              fieldStyle: FieldStyle.box,
                                              length: 6,
                                              style: TextStyle(fontSize: 16),
                                              onCompleted: (pin) {
                                                emailOTP = pin;
                                                updateEmail();
                                              },
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            MaterialButton(
                                              onPressed: () {},
                                              child: Text(
                                                'Submit',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16),
                                              ),
                                              color: Color(0xff133374),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(),
                              ],
                            )),
                      ],
                    )),
              ),
            ],
          ),
        )),
        onWillPop: onBackPressed);
  }

  Future<bool> onBackPressed() async {
    Navigator.of(context).pop();
    return true;
  }

  updateMobile({String otp}) {
    if (mobileNumber.isEmpty) mobileNumber = mobileController.text.trim();

    if (mobileNumber != null && mobileNumber.length == 10) {
      setState(() {
        _showMobileUpdateProgress = true;
      });

      HTTPService()
          .changeMobileNumber(authToken, mobileNumber, otp)
          .then((response) {
        if (response.statusCode == 200) {
          BasicResponseModel basicResponseBody =
              BasicResponseModel.fromJson(json.decode(response.body));

          if (mobileOTP.isNotEmpty) {
            SharedPreferences.getInstance().then((preference) {
              preference.setString(Constants.SHARED_PREF_MOBILE, mobileNumber);
            });
            setState(() {
              _showMobileUpdateProgress = false;
              mobileOTP = "";
            });
          }

          showSuccessDialog(context, basicResponseBody.message);
        } else {
          BasicResponseModel basicResponseBody =
              BasicResponseModel.fromJson(json.decode(response.body));
          showErrorDialog(basicResponseBody.message);
        }
      });
    } else {
      showErrorDialog('Invalid mobile number');
    }
  }

  updateEmail() {
    if (email.isEmpty) email = emailAddressController.text.trim();

    if (email != null) {
      setState(() {
        _showEmailUpdateProgress = true;
      });

      HTTPService()
          .changeEmailAddress(authToken, email, emailOTP)
          .then((response) {
        if (response.statusCode == 200) {
          BasicResponseModel basicResponseBody =
              BasicResponseModel.fromJson(json.decode(response.body));

          if (emailOTP.isNotEmpty) {
            SharedPreferences.getInstance().then((preference) {
              preference.setString(Constants.SHARED_PREF_EMAIL, email);
            });

            setState(() {
              _showEmailUpdateProgress = false;
              emailOTP = "";
            });
          }

          showSuccessDialog(context, basicResponseBody.message);
        } else {
          BasicResponseModel basicResponseBody =
              BasicResponseModel.fromJson(json.decode(response.body));
          showErrorDialog(basicResponseBody.message);
        }
      });
    } else {
      showErrorDialog('Invalid email');
    }
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
      mobileNumber = sharedPrefs.getString(Constants.SHARED_PREF_MOBILE);
      email = sharedPrefs.getString(Constants.SHARED_PREF_EMAIL);

      setState(() {
        mobileController.text = mobileNumber;
        emailAddressController.text = email;
      });
    });
  }
}
