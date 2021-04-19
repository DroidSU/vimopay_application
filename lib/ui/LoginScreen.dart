import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vimopay_application/customs/constants.dart';
import 'package:vimopay_application/customs/custom_dialog.dart';
import 'package:vimopay_application/customs/scale_route_transition.dart';
import 'package:vimopay_application/network/http_service.dart';
import 'package:vimopay_application/network/models/login_response_data.dart';
import 'package:vimopay_application/network/models/login_response_model.dart';
import 'package:vimopay_application/ui/DashboardScreen.dart';
import 'package:vimopay_application/ui/ForgotPasswordScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController? mobileNumberController;
  TextEditingController? passwordController;

  bool _showProgress = false;
  bool _obscurePassword = true;
  String mobileNumber = "";
  String password = "";
  String? fcm_token = "";

  @override
  void initState() {
    super.initState();
    mobileNumberController = TextEditingController();
    passwordController = TextEditingController();
    SharedPreferences.getInstance().then((sharedPrefs) {
      fcm_token = sharedPrefs.getString(Constants.SHARED_PREF_FCM_TOKEN);
    });
  }

  @override
  void dispose() {
    super.dispose();

    mobileNumberController!.dispose();
    passwordController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Stack(
        children: [
          Container(
            height: 350,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: new DecorationImage(
                  image: AssetImage(
                    'images/background_clip_4.png',
                  ),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25))),
          ),
          Container(
            color: Colors.transparent,
            margin: EdgeInsets.fromLTRB(0, 350, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(40, 20, 40, 0),
                  child: TextField(
                    decoration: new InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.transparent, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        prefixIcon: Icon(Icons.phone_android_rounded),
                        filled: true,
                        hintStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.normal),
                        hintText: "Mobile Number",
                        fillColor: Color(0xfff2f2f2)),
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    inputFormatters: [LengthLimitingTextInputFormatter(10)],
                    controller: mobileNumberController,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Roboto'),
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
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.transparent, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        prefixIcon: Icon(
                          Icons.lock_open_rounded,
                        ),
                        suffixIcon: IconButton(
                          icon: _obscurePassword
                              ? Icon(
                                  Icons.visibility_outlined,
                                  color: Colors.black,
                                )
                              : Icon(
                                  Icons.visibility_off_outlined,
                                  color: Colors.black,
                                ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        filled: true,
                        hintStyle: new TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.normal),
                        hintText: "Password",
                        fillColor: Colors.grey[200]),
                    keyboardType: TextInputType.visiblePassword,
                    maxLines: 1,
                    obscureText: _obscurePassword,
                    controller: passwordController,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Roboto'),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 35, 0, 0),
                  alignment: Alignment.center,
                  child: !_showProgress
                      ? RaisedButton(
                          onPressed: () {
                            mobileNumber = mobileNumberController!.text.trim();
                            password = passwordController!.text.trim();

                            if (mobileNumber.isNotEmpty &&
                                mobileNumber.length == 10) {
                              setState(() {
                                _showProgress = true;
                              });

                              HTTPService()
                                  .loginUser(mobileNumber, password, fcm_token)
                                  .then((response) {
                                setState(() {
                                  _showProgress = false;
                                });

                                if (response.statusCode == 200) {
                                  LoginResponseModel loginResponseModel =
                                      LoginResponseModel.fromJson(
                                          json.decode(response.body));
                                  if (loginResponseModel.status!) {
                                    saveUserData(loginResponseModel.data!);
                                  } else {
                                    showErrorDialog(loginResponseModel.message);
                                  }
                                } else {
                                  showErrorDialog(
                                      'Server error occurred while login. Error code: ${response.statusCode}');
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
                                showErrorDialog('Please enter your password');
                            }
                          },
                          // color: Color(0xff6600CC),
                          color: Color(0xff133374),
                          padding: EdgeInsets.all(12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            "Login",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        )
                      : CircularProgressIndicator(),
                ),
                Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: InkWell(
                      child: Text(
                        'Forgot your password?',
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                      ),
                      onTap: () {
                        Navigator.of(context)
                            .push(ScaleRoute(page: ForgotPasswordScreen()));
                      },
                    )),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  void saveUserData(LoginResponseData data) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(Constants.SHARED_PREF_NAME, data.name!);
    sharedPreferences.setString(Constants.SHARED_PREF_EMAIL, data.email!);
    sharedPreferences.setString(Constants.SHARED_PREF_MOBILE, data.mobile!);
    sharedPreferences.setString(Constants.SHARED_PREF_USER_ID, data.userid!);
    sharedPreferences.setString(Constants.SHARED_PREF_TOKEN, data.token!);
    sharedPreferences.setString(Constants.SHARED_PREF_PASSWORD, password);
    // sharedPreferences.setString(Constants.SHARED_PREF_PROFILE_IMAGE, data.profileimage);

    setState(() {
      _showProgress = false;
    });

    Navigator.of(context).pushAndRemoveUntil(
        ScaleRoute(page: DashboardScreen()), (route) => false);
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
                height: 220,
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
                        message!,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
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
}
