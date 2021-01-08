import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vimopay_application/customs/constants.dart';
import 'package:vimopay_application/customs/custom_dialog.dart';
import 'package:vimopay_application/network/http_service.dart';
import 'package:vimopay_application/network/models/basic_response_model.dart';

class ProfileSettingsScreen extends StatefulWidget {
  @override
  _ProfileSettingsScreenState createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  String authToken = "";

  String mobileNumber = "";
  bool _isValidMobile = true;
  TextEditingController mobileController;
  String changeMobileOTP = "";

  String emailAddress = "";
  bool _isValidEmail = true;
  TextEditingController emailController;
  String changeEmailOTP = "";

  String bankHolderName = "";
  TextEditingController holderNameController;
  String accountNumber = "";
  TextEditingController accountNumberController;
  String ifscCode = "";
  TextEditingController ifscController;
  String bankName = "";
  TextEditingController bankNameController;

  TextEditingController oldPasswordController;
  TextEditingController newPasswordController;
  TextEditingController confirmPasswordController;

  bool _showBankUpdateProgress = false;
  bool _showMobileUpdateProgress = false;
  bool _showEmailUpdateProgress = false;

  @override
  void initState() {
    super.initState();

    mobileController = TextEditingController();
    emailController = TextEditingController();
    holderNameController = TextEditingController();
    accountNumberController = TextEditingController();
    ifscController = TextEditingController();
    bankNameController = TextEditingController();
    oldPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();

    getUserDetails();
  }

  @override
  void dispose() {
    super.dispose();
    mobileController.dispose();
    emailController.dispose();
    holderNameController.dispose();
    accountNumberController.dispose();
    ifscController.dispose();
    bankNameController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Profile Settings',
              style: TextStyle(
                color: Colors.blue[900],
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            shadowColor: Colors.white70,
            elevation: 0,
            leading: InkWell(
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onTap: () {
                onBackPressed();
              },
            ),
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        padding: EdgeInsets.fromLTRB(5, 0, 10, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 210,
                              height: 50,
                              child: TextField(
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                controller: mobileController,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                decoration: new InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10.0),
                                      ),
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10.0),
                                      ),
                                      borderSide:
                                          BorderSide(color: Colors.blueAccent),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10.0),
                                      ),
                                      borderSide: BorderSide(color: Colors.red),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10.0),
                                      ),
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10.0),
                                      ),
                                      borderSide: BorderSide(color: Colors.red),
                                    ),
                                    filled: true,
                                    hintStyle:
                                        new TextStyle(color: Colors.grey[800]),
                                    hintText: "Enter mobile number",
                                    errorText: _isValidMobile
                                        ? null
                                        : 'Invalid mobile number',
                                    labelText: 'Mobile Number',
                                    labelStyle: TextStyle(
                                        color: Colors.black54, fontSize: 14),
                                    fillColor: Colors.white70),
                              ),
                            ),
                            Container(
                              width: 90,
                              child: _showMobileUpdateProgress
                                  ? CircularProgressIndicator()
                                  : RaisedButton(
                                      onPressed: () => updateMobile(),
                                      elevation: 10,
                                      color: Colors.blue,
                                      child: Text(
                                        'Update',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      )),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        padding: EdgeInsets.fromLTRB(5, 0, 10, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 210,
                              height: 50,
                              child: TextField(
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                controller: emailController,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                                keyboardType: TextInputType.emailAddress,
                                decoration: new InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10.0),
                                      ),
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10.0),
                                      ),
                                      borderSide:
                                          BorderSide(color: Colors.blueAccent),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10.0),
                                      ),
                                      borderSide: BorderSide(color: Colors.red),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10.0),
                                      ),
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10.0),
                                      ),
                                      borderSide: BorderSide(color: Colors.red),
                                    ),
                                    filled: true,
                                    hintStyle:
                                        new TextStyle(color: Colors.grey[800]),
                                    hintText: "Change email address",
                                    errorText:
                                        _isValidEmail ? null : 'Invalid email',
                                    labelText: 'Email Address',
                                    labelStyle: TextStyle(
                                        color: Colors.black54, fontSize: 14),
                                    fillColor: Colors.white70),
                              ),
                            ),
                            Container(
                              width: 90,
                              child: _showEmailUpdateProgress
                                  ? CircularProgressIndicator()
                                  : RaisedButton(
                                      onPressed: () => updateEmail(),
                                      elevation: 10,
                                      color: Colors.blue,
                                      child: Text(
                                        'Update',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      )),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 350,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        padding: EdgeInsets.fromLTRB(5, 0, 10, 0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black, width: 1)),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Bank Details',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Expanded(
                              child: TextField(
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                controller: holderNameController,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                                keyboardType: TextInputType.name,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                decoration: new InputDecoration(
                                    border: new OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10.0),
                                      ),
                                    ),
                                    filled: true,
                                    hintStyle:
                                        new TextStyle(color: Colors.grey[800]),
                                    hintText: "Account Holder Name",
                                    labelText: 'Holder Name',
                                    labelStyle: TextStyle(
                                        color: Colors.black54, fontSize: 14),
                                    fillColor: Colors.white70),
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                controller: accountNumberController,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                                keyboardType: TextInputType.number,
                                decoration: new InputDecoration(
                                    border: new OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10.0),
                                      ),
                                    ),
                                    filled: true,
                                    hintStyle:
                                        new TextStyle(color: Colors.grey[800]),
                                    hintText: "Account Number",
                                    labelText: 'Account number',
                                    labelStyle: TextStyle(
                                        color: Colors.black54, fontSize: 14),
                                    fillColor: Colors.white70),
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                controller: ifscController,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                                keyboardType: TextInputType.text,
                                decoration: new InputDecoration(
                                    border: new OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10.0),
                                      ),
                                    ),
                                    filled: true,
                                    hintStyle:
                                        new TextStyle(color: Colors.grey[800]),
                                    hintText: "IFSC Code",
                                    labelText: 'IFSC Code',
                                    labelStyle: TextStyle(
                                        color: Colors.black54, fontSize: 14),
                                    fillColor: Colors.white70),
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                controller: bankNameController,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                                keyboardType: TextInputType.name,
                                decoration: new InputDecoration(
                                    border: new OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10.0),
                                      ),
                                    ),
                                    filled: true,
                                    hintStyle:
                                        new TextStyle(color: Colors.grey[800]),
                                    hintText: "Bank Name",
                                    labelText: 'Bank Name',
                                    labelStyle: TextStyle(
                                        color: Colors.black54, fontSize: 14),
                                    fillColor: Colors.white70),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              width: 90,
                              child: _showBankUpdateProgress
                                  ? CircularProgressIndicator()
                                  : RaisedButton(
                                      onPressed: () {
                                        updateBankDetails();
                                      },
                                      elevation: 10,
                                      color: Colors.blue,
                                      shape: RoundedRectangleBorder(),
                                      child: Text(
                                        'Update',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      )),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          padding: EdgeInsets.fromLTRB(5, 0, 10, 0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: Colors.black, width: 1)),
                          height: 50,
                          child: InkWell(
                            child: Center(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.lock_outline_rounded,
                                  size: 24,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Change Password',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )),
                            onTap: () {
                              showChangePasswordDialog();
                            },
                          )),
                    ],
                  ),
                ),
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

  void getUserDetails() {
    SharedPreferences.getInstance().then((sharedPrefs) {
      mobileNumber = sharedPrefs.getString(Constants.SHARED_PREF_MOBILE);
      emailAddress = sharedPrefs.getString(Constants.SHARED_PREF_EMAIL);
      authToken = sharedPrefs.getString(Constants.SHARED_PREF_TOKEN);
      bankHolderName =
          sharedPrefs.getString(Constants.SHARED_PREF_HOLDER_NAME) == null
              ? ""
              : sharedPrefs.getString(Constants.SHARED_PREF_HOLDER_NAME);
      accountNumber =
          sharedPrefs.getString(Constants.SHARED_PREF_ACCOUNT_NUMBER) == null
              ? ""
              : sharedPrefs.getString(Constants.SHARED_PREF_ACCOUNT_NUMBER);
      bankName = sharedPrefs.getString(Constants.SHARED_PREF_BANK_NAME) == null
          ? ""
          : sharedPrefs.getString(Constants.SHARED_PREF_BANK_NAME);
      ifscCode = sharedPrefs.getString(Constants.SHARED_PREF_IFSC_CODE) == null
          ? ""
          : sharedPrefs.getString(Constants.SHARED_PREF_IFSC_CODE);

      setState(() {
        mobileController.text = mobileNumber;
        emailController.text = emailAddress;
        holderNameController.text = bankHolderName;
        accountNumberController.text = accountNumber;
        bankNameController.text = bankName;
        ifscController.text = ifscCode;
      });
    });
  }

  void showChangePasswordDialog() async {
    if (mounted) {
      showDialog(
          context: context,
          builder: (buildContext) {
            return CustomAlertDialog(
              contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              content: Container(
                width: 80,
                height: 300,
                decoration: new BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: const Color(0xFFFFFF),
                  borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: TextField(
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              textAlign: TextAlign.center,
                              controller: oldPasswordController,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              decoration: new InputDecoration(
                                  border: new OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(20.0),
                                    ),
                                  ),
                                  filled: true,
                                  hintStyle:
                                      new TextStyle(color: Colors.grey[800]),
                                  hintText: "Old Password",
                                  fillColor: Colors.white),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: TextField(
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              textAlign: TextAlign.center,
                              controller: newPasswordController,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              decoration: new InputDecoration(
                                  border: new OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(20.0),
                                    ),
                                  ),
                                  filled: true,
                                  hintStyle:
                                      new TextStyle(color: Colors.grey[800]),
                                  hintText: "New Password",
                                  fillColor: Colors.white),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: TextField(
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              textAlign: TextAlign.center,
                              controller: confirmPasswordController,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              decoration: new InputDecoration(
                                  border: new OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(20.0),
                                    ),
                                  ),
                                  filled: true,
                                  hintStyle:
                                      new TextStyle(color: Colors.grey[800]),
                                  hintText: "Confirm Password",
                                  fillColor: Colors.white),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();

                                    // currentPassword =
                                    //     oldPasswordController.text.trim();
                                    // String newPassword =
                                    //     newPasswordController.text.trim();
                                    // String confirmPassword =
                                    //     confirmPasswordController.text.trim();
                                    //
                                    // if (currentPassword != null &&
                                    //     currentPassword.isNotEmpty &&
                                    //     newPassword != null &&
                                    //     newPassword.isNotEmpty &&
                                    //     confirmPassword != null &&
                                    //     confirmPassword.isNotEmpty &&
                                    //     newPassword == confirmPassword) {
                                    //   HTTPService()
                                    //       .changePassword(
                                    //           authToken, newPassword)
                                    //       .then((response) {
                                    //     if (response.statusCode == 200) {
                                    //       var responseJSON =
                                    //           PasswordChangeResponseModel
                                    //               .fromJson(json
                                    //                   .decode(response.body));
                                    //       if (responseJSON.status) {
                                    //         _shouldLogOutUser = true;
                                    //
                                    //         showSuccessDialog(context,
                                    //             'Password changed successfully. Please log in again!');
                                    //       } else {
                                    //         showErrorDialog(
                                    //             responseJSON.message);
                                    //       }
                                    //     } else {
                                    //       showErrorDialog(
                                    //           'Server error! Error code ${response.statusCode}');
                                    //     }
                                    //   });
                                    // } else {}
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
                  ],
                ),
              ),
            );
          });
    }
  }

  updateMobile() {
    String mobileNumber = mobileController.text.trim();
    if (mobileNumber != null && mobileNumber.length == 10) {
      setState(() {
        _showMobileUpdateProgress = true;
      });

      HTTPService()
          .changeMobileNumber(authToken, mobileNumber)
          .then((response) {
        setState(() {
          _showMobileUpdateProgress = false;
        });

        if (response.statusCode == 200) {
          SharedPreferences.getInstance().then((preference) {
            preference.setString(Constants.SHARED_PREF_MOBILE, mobileNumber);
          });
          showSuccessDialog(context, 'Mobile number changed successfully');
        } else {
          BasicResponseModel basicResponseBody =
              BasicResponseModel.fromJson(json.decode(response.body));
          showErrorDialog(basicResponseBody.message);
        }
      });
    } else {
      setState(() {
        _isValidMobile = false;
      });
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

  updateEmail() {
    String emailId = emailController.text.trim();
    if (emailId != null && EmailValidator.validate(emailId)) {
      setState(() {
        _showEmailUpdateProgress = true;
      });
      HTTPService().changeEmailAddress(authToken, emailId).then((response) {
        setState(() {
          _showEmailUpdateProgress = false;
        });

        if (response.statusCode == 200) {
          SharedPreferences.getInstance().then((preference) {
            preference.setString(Constants.SHARED_PREF_EMAIL, emailId);
          });
          showSuccessDialog(context, 'Email address updated successfully');
        } else {
          BasicResponseModel basicResponseBody =
              BasicResponseModel.fromJson(json.decode(response.body));
          showErrorDialog(basicResponseBody.message);
        }
      });
    } else {
      setState(() {
        _isValidEmail = false;
      });
    }
  }

  void updateBankDetails() {
    setState(() {
      _showBankUpdateProgress = true;
    });

    bankName = bankNameController.text.trim();
    accountNumber = accountNumberController.text.trim();
    ifscCode = ifscController.text.trim();
    bankHolderName = holderNameController.text.trim();

    HTTPService()
        .updateBankDetails(
            authToken, bankName, accountNumber, ifscCode, bankHolderName)
        .then((response) {
      setState(() {
        _showBankUpdateProgress = false;
      });
      if (response.statusCode == 200) {
        BasicResponseModel basicResponseModel =
            BasicResponseModel.fromJson(json.decode(response.body));

        if (basicResponseModel.status) {
          showSuccessDialog(context, 'Bank details updated successfully');
          SharedPreferences.getInstance().then((sharedPrefs) {
            sharedPrefs.setString(
                Constants.SHARED_PREF_HOLDER_NAME, bankHolderName);
            sharedPrefs.setString(
                Constants.SHARED_PREF_ACCOUNT_NUMBER, accountNumber);
            sharedPrefs.setString(Constants.SHARED_PREF_IFSC_CODE, ifscCode);
            sharedPrefs.setString(Constants.SHARED_PREF_BANK_NAME, bankName);
          });
        } else {
          showErrorDialog(basicResponseModel.message);
        }
      } else {
        showErrorDialog('Something went wrong! Error ${response.statusCode}');
      }
    });
  }
}
