import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vimopay_application/customs/constants.dart';
import 'package:vimopay_application/customs/custom_dialog.dart';
import 'package:vimopay_application/customs/scale_route_transition.dart';
import 'package:vimopay_application/network/http_service.dart';
import 'package:vimopay_application/network/login_response_data.dart';
import 'package:vimopay_application/network/login_response_model.dart';
import 'package:vimopay_application/ui/DashboardScreen.dart';
import 'package:vimopay_application/ui/ForgotPasswordScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController mobileNumberController;
  TextEditingController passwordController;

  bool _showProgress = false;
  String mobileNumber = "";
  String password = "";

  @override
  void initState() {
    super.initState();
    mobileNumberController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();

    mobileNumberController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  child: Image.asset(
                    'images/ic_logo.png',
                    height: 200,
                    width: 200,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 200, 0, 0),
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(
                        'User Login',
                        style: TextStyle(color: Colors.black, fontSize: 26),
                      ),
                      alignment: Alignment.center,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
                      child: TextField(
                        decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                            prefixIcon: Icon(Icons.phone_android_rounded),
                            filled: true,
                            hintStyle: new TextStyle(color: Colors.grey[800]),
                            hintText: "Mobile Number",
                            fillColor: Colors.white70),
                        keyboardType: TextInputType.number,
                        maxLines: 1,
                        inputFormatters: [LengthLimitingTextInputFormatter(10)],
                        controller: mobileNumberController,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
                      child: TextField(
                        decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                            prefixIcon: Icon(Icons.lock_open_rounded),
                            filled: true,
                            hintStyle: new TextStyle(color: Colors.grey[800]),
                            hintText: "Password",
                            fillColor: Colors.white70),
                        keyboardType: TextInputType.visiblePassword,
                        maxLines: 1,
                        obscureText: true,
                        controller: passwordController,
                      ),
                    ),
                    Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.fromLTRB(0, 10, 40, 0),
                        child: InkWell(
                          child: Text(
                            'Forgot Password?',
                            style:
                                TextStyle(color: Colors.black54, fontSize: 16),
                          ),
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                                ScaleRoute(page: ForgotPasswordScreen()));
                          },
                        )),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 35, 0, 0),
                      alignment: Alignment.center,
                      child: !_showProgress
                          ? RaisedButton(
                              onPressed: () {
                                mobileNumber =
                                    mobileNumberController.text.trim();
                                password = passwordController.text.trim();

                                if (mobileNumber.isNotEmpty &&
                                    mobileNumber.length == 10) {
                                  setState(() {
                                    _showProgress = true;
                                  });

                                  HTTPService()
                                      .loginUser(mobileNumber, password)
                                      .then((response) {
                                    if (response.statusCode == 200) {
                                      LoginResponseModel loginResponseModel =
                                          LoginResponseModel.fromJson(
                                              json.decode(response.body));
                                      if (loginResponseModel.status) {
                                        saveUserData(loginResponseModel.data);
                                      } else {
                                        showErrorDialog(
                                            loginResponseModel.message);
                                      }
                                    } else {
                                      showErrorDialog(
                                          'Server error occurred while registering. Error code: ${response.statusCode}');
                                    }
                                  });
                                } else {
                                  setState(() {
                                    _showProgress = false;
                                  });

                                  if (mobileNumber.isEmpty)
                                    showErrorDialog(
                                        'Mobile number should not be empty');
                                  else if (mobileNumber.length != 10)
                                    showErrorDialog(
                                        'Please enter a valid mobile number');
                                  else if (password.isEmpty)
                                    showErrorDialog(
                                        'Please enter your password');
                                }
                              },
                              // color: Color(0xff6600CC),
                              color: Colors.blue,
                              padding: EdgeInsets.all(12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            )
                          : CircularProgressIndicator(),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void saveUserData(LoginResponseData data) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(Constants.SHARED_PREF_NAME, data.name);
    sharedPreferences.setString(Constants.SHARED_PREF_EMAIL, data.email);
    sharedPreferences.setString(Constants.SHARED_PREF_MOBILE, data.mobile);
    sharedPreferences.setString(Constants.SHARED_PREF_USER_ID, data.userid);
    sharedPreferences.setString(Constants.SHARED_PREF_TOKEN, data.token);
    // sharedPreferences.setString(Constants.SHARED_PREF_PROFILE_IMAGE, data.profileimage);

    setState(() {
      _showProgress = false;
    });

    Navigator.of(context).pushReplacement(ScaleRoute(page: DashboardScreen()));
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
}