import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:vimopay_application/customs/countdown_widget.dart';
import 'package:vimopay_application/customs/custom_dialog.dart';
import 'package:vimopay_application/customs/scale_route_transition.dart';
import 'package:vimopay_application/network/http_service.dart';
import 'package:vimopay_application/ui/LoginScreen.dart';
import 'package:vimopay_application/ui/SplashScreen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with TickerProviderStateMixin {
  TextEditingController mobileController;
  AnimationController _controller;

  bool _showProgress = false;
  Timer timer;

  /*
    pagerState: 0 - do not show otp fields
    pagerState: 1 - show otp fields
   */
  int pagerState = 0;

  String mobile = "";
  String otp = '';

  @override
  void initState() {
    super.initState();
    mobileController = TextEditingController();
    _controller = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 30),
    );

    if (pagerState == 1) {
      _controller.forward();
      startTimer();
    }

    if (mobile.isNotEmpty) mobileController.text = mobile;
  }

  @override
  void dispose() {
    mobileController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  // Align(
                  //   alignment: Alignment.topCenter,
                  //   child: Container(
                  //     child: Image.asset(
                  //       'images/ic_logo.png',
                  //       height: 200,
                  //       width: 200,
                  //     ),
                  //   ),
                  // ),
                  // pagerState == 0 ? showMobileNumberField() : showPinField(),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10, 40, 0, 0),
                      child: InkWell(
                        child: Icon(
                          Icons.arrow_back,
                          size: 24,
                          color: Colors.black,
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 80, 0, 0),
                    width: MediaQuery.of(context).size.width,
                    child: pagerState == 0
                        ? showMobileNumberField()
                        : showPinField(),
                  ),
                ],
              ),
            ),
          ),
        ),
        onWillPop: onBackPressed);
  }

  Widget showMobileNumberField() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Reset Password',
            style: TextStyle(color: Colors.black, fontSize: 22),
            textAlign: TextAlign.center,
          ),
          Container(
            child: Text(
              'Enter 10 digit mobile number to receive confirmation code to change password',
              style:
                  TextStyle(color: Colors.black.withOpacity(0.3), fontSize: 14),
              textAlign: TextAlign.center,
            ),
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.fromLTRB(30, 10, 30, 0),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(40, 40, 40, 0),
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30.0),
                      ),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      )),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30.0),
                      ),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      )),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30.0),
                      ),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      )),
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30.0),
                      ),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      )),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30.0),
                      ),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      )),
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30.0),
                      ),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      )),
                  prefixIcon: Icon(Icons.phone_android_rounded),
                  filled: true,
                  hintStyle: new TextStyle(color: Colors.grey),
                  hintText: "Mobile Number",
                  fillColor: Colors.grey[200]),
              keyboardType: TextInputType.number,
              maxLines: 1,
              inputFormatters: [LengthLimitingTextInputFormatter(10)],
              controller: mobileController,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 35, 0, 0),
            alignment: Alignment.center,
            child: !_showProgress
                ? RaisedButton(
                    onPressed: () {
                      mobile = mobileController.text.trim();
                      if (mobile != null &&
                          mobile.isNotEmpty &&
                          mobile.length == 10) {
                        setState(() {
                          _showProgress = true;
                        });

                        HTTPService()
                            .forgotPassword(mobile, "")
                            .then((response) {
                          if (response.statusCode == 200) {
                            showSuccessDialog(
                                context, 'OTP sent successfully!');
                          } else {
                            showErrorDialog(
                                'Server error occurred. Error code ${response.statusCode}');
                          }
                        });
                      } else {
                        if (mobile.isEmpty)
                          showErrorDialog('Mobile number cannot be empty');
                        else if (mobile.length != 10) {
                          showErrorDialog('Invalid mobile number');
                        }
                      }
                    },
                    color: Color(0xff133374),
                    padding: EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "Verify number",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  )
                : CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }

  Widget showPinField() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'We have sent an OTP to your mobile',
            style: TextStyle(color: Colors.black, fontSize: 22),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Please enter the otp received to continue resetting your password',
            style:
                TextStyle(color: Colors.black.withOpacity(0.3), fontSize: 14),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: OTPTextField(
              width: MediaQuery.of(context).size.width,
              keyboardType: TextInputType.number,
              textFieldAlignment: MainAxisAlignment.spaceAround,
              fieldWidth: 50,
              fieldStyle: FieldStyle.box,
              length: 6,
              style: TextStyle(fontSize: 16),
              onCompleted: (pin) {
                print('OTP: $otp');

                if (pin.length == 6) {
                  otp = pin;

                  setState(() {
                    _showProgress = true;

                    timer.cancel();
                  });

                  HTTPService().forgotPassword(mobile, otp).then((response) {
                    if (response.statusCode == 200) {
                      showSuccessDialog(
                          context, 'New password successfully sent!');
                    } else {
                      showErrorDialog(
                          'Server error occurred. Error code ${response.statusCode}');
                    }
                  });
                }
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            alignment: Alignment.center,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Resend OTP in ',
                  style: TextStyle(color: Colors.black54),
                ),
                SizedBox(
                  width: 5,
                ),
                Countdown(
                  animation: StepTween(
                    begin: 30,
                    end: 0,
                  ).animate(_controller),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'seconds',
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 35, 0, 0),
            alignment: Alignment.center,
            child: !_showProgress
                ? RaisedButton(
                    onPressed: () {},
                    // color: Color(0xff6600CC),
                    color: Colors.blue,
                    padding: EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "Verify OTP",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  )
                : CircularProgressIndicator(),
          ),
        ],
      ),
    );
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
                              setState(() {
                                _showProgress = false;
                              });

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
                              if (pagerState == 0) {
                                setState(() {
                                  _showProgress = false;
                                  pagerState = 1;
                                });

                                startTimer();
                                _controller.forward();

                                Navigator.of(context).pop();
                              } else {
                                setState(() {
                                  _showProgress = false;
                                });
                                if (otp.isNotEmpty) {
                                  Navigator.of(context).pop();

                                  _controller.dispose();
                                  mobileController.dispose();
                                  Navigator.of(context).pushReplacement(
                                      ScaleRoute(page: SplashScreen()));
                                } else {
                                  Navigator.of(context).pop();
                                }
                              }
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

  void startTimer() {
    timer = Timer(Duration(seconds: 30), () {
      setState(() {
        _showProgress = false;
        pagerState = 0;

        _controller.dispose();
        _controller = new AnimationController(
          vsync: this,
          duration: new Duration(seconds: 30),
        );
      });
    });
  }

  Future<bool> onBackPressed() async {
    Navigator.of(context).pushReplacement(ScaleRoute(page: LoginScreen()));
    return true;
  }
}
