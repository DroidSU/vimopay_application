import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vimopay_application/customs/constants.dart';
import 'package:vimopay_application/customs/custom_dialog.dart';
import 'package:vimopay_application/customs/scale_route_transition.dart';
import 'package:vimopay_application/network/http_service.dart';
import 'package:vimopay_application/network/models/basic_response_model.dart';
import 'package:vimopay_application/ui/SettingsScreen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String authToken = "";
  String userName = "";
  String userEmail = "";
  String userMobile = "";
  String address = "";
  String city = "";
  String userId = "";
  String company = "";

  TextEditingController nameController;
  TextEditingController emailController;
  TextEditingController mobileController;
  TextEditingController addressController;
  TextEditingController cityController;
  TextEditingController stateController;
  TextEditingController pincodeController;
  TextEditingController aadharCardController;
  TextEditingController pancardController;
  TextEditingController gstController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    mobileController = TextEditingController();
    addressController = TextEditingController();
    cityController = TextEditingController();
    stateController = TextEditingController();
    pincodeController = TextEditingController();
    aadharCardController = TextEditingController();
    pancardController = TextEditingController();
    gstController = TextEditingController();

    fetchUserDetails();
  }

  @override
  void dispose() {
    super.dispose();

    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    pincodeController.dispose();
    aadharCardController.dispose();
    pancardController.dispose();
    gstController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Profile Details',
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
          actions: [
            InkWell(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.settings,
                  color: Colors.blue[900],
                  size: 30,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(ScaleRoute(page: SettingsScreen()));
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'images/default_user.png',
                      width: 80.0,
                      height: 80.0,
                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(10, 20, 10, 5),
                    child: RichText(
                      text: TextSpan(
                        text: 'User ID: ',
                        style: TextStyle(color: Colors.black54, fontSize: 15),
                        children: [
                          TextSpan(
                              text: userId,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16))
                        ],
                      ),
                    )),
                Container(
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                    child: RichText(
                      text: TextSpan(
                        text: 'Company: ',
                        style: TextStyle(color: Colors.black54, fontSize: 15),
                        children: [
                          TextSpan(
                              text: company,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16))
                        ],
                      ),
                    )),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 20, 10, 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: nameController,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          decoration: new InputDecoration(
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              ),
                              filled: true,
                              hintStyle: new TextStyle(color: Colors.grey[800]),
                              hintText: "Enter name",
                              labelText: 'Name',
                              labelStyle: TextStyle(
                                  color: Colors.black54, fontSize: 16),
                              alignLabelWithHint: true,
                              fillColor: Colors.white70),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextField(
                          controller: mobileController,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          showCursor: false,
                          readOnly: true,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          decoration: new InputDecoration(
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              ),
                              filled: true,
                              hintStyle: new TextStyle(color: Colors.grey[800]),
                              hintText: "Enter mobile number",
                              labelText: 'Mobile Number',
                              labelStyle: TextStyle(
                                  color: Colors.black54, fontSize: 18),
                              alignLabelWithHint: true,
                              fillColor: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 8, 10, 5),
                  child: TextField(
                    controller: emailController,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    showCursor: false,
                    readOnly: true,
                    style: TextStyle(color: Colors.black, fontSize: 14),
                    keyboardType: TextInputType.emailAddress,
                    decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),
                        filled: true,
                        hintStyle: new TextStyle(color: Colors.grey[800]),
                        hintText: "Enter email address",
                        labelText: 'Email Address',
                        labelStyle:
                            TextStyle(color: Colors.black54, fontSize: 16),
                        alignLabelWithHint: true,
                        fillColor: Colors.white70),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 8, 10, 5),
                  child: TextField(
                    controller: addressController,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),
                        filled: true,
                        hintStyle: new TextStyle(color: Colors.grey[800]),
                        hintText: "Enter address",
                        labelText: 'Address',
                        labelStyle:
                            TextStyle(color: Colors.black54, fontSize: 16),
                        alignLabelWithHint: true,
                        fillColor: Colors.white70),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 8, 10, 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: stateController,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          decoration: new InputDecoration(
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              ),
                              filled: true,
                              hintStyle: new TextStyle(color: Colors.grey[800]),
                              hintText: "Enter state name",
                              labelText: 'State',
                              labelStyle: TextStyle(
                                  color: Colors.black54, fontSize: 16),
                              alignLabelWithHint: true,
                              fillColor: Colors.white70),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextField(
                          controller: cityController,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          decoration: new InputDecoration(
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              ),
                              filled: true,
                              hintStyle: new TextStyle(color: Colors.grey[800]),
                              hintText: "Enter city name",
                              labelText: 'City Name',
                              labelStyle: TextStyle(
                                  color: Colors.black54, fontSize: 16),
                              alignLabelWithHint: true,
                              fillColor: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: pincodeController,
                          maxLines: 1,
                          showCursor: false,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(6)
                          ],
                          decoration: new InputDecoration(
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              ),
                              filled: true,
                              hintStyle: new TextStyle(color: Colors.grey[800]),
                              hintText: "Enter pincode name",
                              labelText: 'Pincode',
                              labelStyle: TextStyle(
                                  color: Colors.black54, fontSize: 16),
                              alignLabelWithHint: true,
                              fillColor: Colors.white70),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextField(
                          controller: pancardController,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          keyboardType: TextInputType.text,
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
                              hintStyle: new TextStyle(color: Colors.grey[800]),
                              hintText: "Pan Card",
                              labelText: 'Pan Card',
                              labelStyle: TextStyle(
                                  color: Colors.black54, fontSize: 16),
                              alignLabelWithHint: true,
                              fillColor: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: aadharCardController,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(12)
                          ],
                          keyboardType: TextInputType.number,
                          decoration: new InputDecoration(
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              ),
                              filled: true,
                              hintStyle: new TextStyle(color: Colors.grey[800]),
                              hintText: "Aadhar card",
                              labelText: 'Aadhar Card',
                              labelStyle: TextStyle(
                                  color: Colors.black54, fontSize: 16),
                              alignLabelWithHint: true,
                              fillColor: Colors.white70),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextField(
                          controller: gstController,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          keyboardType: TextInputType.text,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(15),
                          ],
                          decoration: new InputDecoration(
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              ),
                              filled: true,
                              hintStyle: new TextStyle(color: Colors.grey[800]),
                              hintText: "GST Number",
                              labelText: 'GST Number',
                              labelStyle: TextStyle(
                                  color: Colors.black54, fontSize: 16),
                              alignLabelWithHint: true,
                              fillColor: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void onBackPressed() {
    Navigator.of(context).pop();
  }

  void fetchUserDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    authToken = sharedPreferences.getString(Constants.SHARED_PREF_TOKEN);
    userName = sharedPreferences.getString(Constants.SHARED_PREF_NAME);
    userEmail = sharedPreferences.getString(Constants.SHARED_PREF_EMAIL);
    userMobile = sharedPreferences.getString(Constants.SHARED_PREF_MOBILE);
    userId = sharedPreferences.getString(Constants.SHARED_PREF_USER_ID);
    address = sharedPreferences.getString(Constants.SHARED_PREF_ADDRESS) == null
        ? ""
        : sharedPreferences.getString(Constants.SHARED_PREF_ADDRESS);

    setState(() {
      nameController.text = userName;
      emailController.text = userEmail;
      mobileController.text = userMobile;
      addressController.text = address;
    });
  }

  void updateMobileNumber() {
    String mobileNumber = mobileController.text.trim();
    if (mobileNumber != null && mobileNumber.length == 10) {
      HTTPService()
          .changeMobileNumber(authToken, mobileNumber)
          .then((response) {
        if (response.statusCode == 200) {
          SharedPreferences.getInstance().then((preference) {
            preference.setString(Constants.SHARED_PREF_MOBILE, mobileNumber);
          });
          // showSuccessDialog(context, 'Mobile number changed successfully');
        } else {
          BasicResponseBody basicResponseBody =
              BasicResponseBody.fromJson(json.decode(response.body));
          showErrorDialog(basicResponseBody.message);
        }
      });
    } else {
      showErrorDialog('Invalid mobile number');
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

  void updateServerDetails() {
    updateMobileNumber();
    updateEmailAddress();
  }

  void updateEmailAddress() {
    String emailId = emailController.text.trim();
    if (emailId != null && EmailValidator.validate(emailId)) {
      HTTPService().changeEmailAddress(authToken, emailId).then((response) {
        if (response.statusCode == 200) {
          SharedPreferences.getInstance().then((preference) {
            preference.setString(Constants.SHARED_PREF_EMAIL, emailId);
          });
          showSuccessDialog(context, 'Profile detail updated successfully');
        } else {
          BasicResponseBody basicResponseBody =
              BasicResponseBody.fromJson(json.decode(response.body));
          showErrorDialog(basicResponseBody.message);
        }
      });
    } else {
      showErrorDialog('Invalid Email Id');
    }
  }
}
