import 'dart:convert';

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
  String userAddress = "";
  String userCity = "";
  String userState = "";
  String pincode = "";
  String aadharNumber = "";
  String gstNumber = "";
  String panNumber = "";
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

  bool _isValidName = true;
  bool _isValidMobile = true;
  bool _isValidEmail = true;
  bool _isValidAddress = true;
  bool _isValidState = true;
  bool _isValidCity = true;
  bool _isValidPincode = true;
  bool _isValidPanCard = true;
  bool _isValidAadharCard = true;
  bool _isValidGSTNumber = true;

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
    return WillPopScope(
        child: Scaffold(
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
                    Navigator.of(context)
                        .push(ScaleRoute(page: SettingsScreen()));
                  },
                )
              ],
            ),
            body: SingleChildScrollView(
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
                                  Radius.circular(10.0),
                                ),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              filled: true,
                              hintStyle: new TextStyle(color: Colors.grey[800]),
                              hintText: "Enter name",
                              labelText: 'Name',
                              errorText: _isValidName ? null : 'Invalid Name',
                              errorStyle: TextStyle(color: Colors.red),
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
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              filled: true,
                              hintStyle: new TextStyle(color: Colors.grey[800]),
                              hintText: "mobile number",
                              labelText: 'Mobile Number',
                              errorText:
                                  _isValidMobile ? null : 'Invalid Mobile',
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
                            Radius.circular(10.0),
                          ),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        filled: true,
                        hintStyle: new TextStyle(color: Colors.grey[800]),
                        hintText: "Enter address",
                        labelText: 'Address',
                        errorText: _isValidAddress ? null : 'Invalid Address',
                        errorStyle: TextStyle(color: Colors.red),
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
                          keyboardType: TextInputType.name,
                          decoration: new InputDecoration(
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              filled: true,
                              hintStyle: new TextStyle(color: Colors.grey[800]),
                              hintText: "Enter state name",
                              labelText: 'State',
                              errorText:
                                  _isValidState ? null : 'Invalid State Name',
                              errorStyle: TextStyle(color: Colors.red),
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
                                  Radius.circular(10.0),
                                ),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              filled: true,
                              hintStyle: new TextStyle(color: Colors.grey[800]),
                              hintText: "Enter city name",
                              labelText: 'City Name',
                              errorText:
                                  _isValidCity ? null : 'Invalid City Name',
                              errorStyle: TextStyle(color: Colors.red),
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
                                  Radius.circular(10.0),
                                ),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              filled: true,
                              hintStyle: new TextStyle(color: Colors.grey[800]),
                              hintText: "Enter pincode name",
                              errorText:
                                  _isValidPincode ? null : 'Invalid Pincode',
                              errorStyle: TextStyle(color: Colors.red),
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
                                  Radius.circular(10.0),
                                ),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              filled: true,
                              hintStyle: new TextStyle(color: Colors.grey[800]),
                              hintText: "Pan Card",
                              errorText:
                                  _isValidPanCard ? null : 'Invalid PAN number',
                              errorStyle: TextStyle(color: Colors.red),
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
                                  Radius.circular(10.0),
                                ),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              filled: true,
                              hintStyle: new TextStyle(color: Colors.grey[800]),
                              hintText: "Aadhar card",
                              errorText: _isValidAadharCard
                                  ? null
                                  : 'Invalid Aadhar number',
                              errorStyle: TextStyle(color: Colors.red),
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
            ))),
        onWillPop: onBackPressed);
  }

  Future<bool> onBackPressed() async {
    userName = nameController.text.trim();
    userAddress = addressController.text.trim();
    userCity = cityController.text.trim();
    userState = stateController.text.trim();
    pincode = pincodeController.text.trim();
    aadharNumber = aadharCardController.text.trim();
    panNumber = pancardController.text.trim();
    gstNumber = gstController.text.trim();

    if (userName.isNotEmpty &&
        userAddress.isNotEmpty &&
        userCity.isNotEmpty &&
        userState.isNotEmpty &&
        pincode.length == 6 &&
        aadharNumber.length == 12 &&
        panNumber.length == 10) {
      updateProfileDetails();
      Navigator.of(context).pop();

      return true;
    } else {
      if (userName.isEmpty) {
        setState(() {
          _isValidName = false;
        });
      }
      if (userAddress.isEmpty) {
        setState(() {
          _isValidAddress = false;
        });
      }
      if (userState.isEmpty) {
        setState(() {
          _isValidState = false;
        });
      }
      if (userCity.isEmpty) {
        setState(() {
          _isValidCity = false;
        });
      }
      if (pincode.length != 6) {
        setState(() {
          _isValidPincode = false;
        });
      }
      if (aadharNumber.length != 12) {
        setState(() {
          _isValidAadharCard = false;
        });
      }
      if (panNumber.length != 10) {
        setState(() {
          _isValidPanCard = false;
        });
      }
      return false;
    }
  }

  void fetchUserDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    authToken = sharedPreferences.getString(Constants.SHARED_PREF_TOKEN);
    userName = sharedPreferences.getString(Constants.SHARED_PREF_NAME);
    userEmail = sharedPreferences.getString(Constants.SHARED_PREF_EMAIL);
    userMobile = sharedPreferences.getString(Constants.SHARED_PREF_MOBILE);
    userId = sharedPreferences.getString(Constants.SHARED_PREF_USER_ID);
    userAddress =
        sharedPreferences.getString(Constants.SHARED_PREF_ADDRESS) == null
            ? ""
            : sharedPreferences.getString(Constants.SHARED_PREF_ADDRESS);
    userCity = sharedPreferences.getString(Constants.SHARED_PREF_CITY) == null
        ? ""
        : sharedPreferences.getString(Constants.SHARED_PREF_CITY);
    userState = sharedPreferences.getString(Constants.SHARED_PREF_STATE) == null
        ? ""
        : sharedPreferences.getString(Constants.SHARED_PREF_STATE);
    pincode = sharedPreferences.getString(Constants.SHARED_PREF_PINCODE) == null
        ? ""
        : sharedPreferences.getString(Constants.SHARED_PREF_PINCODE);
    aadharNumber =
        sharedPreferences.getString(Constants.SHARED_PREF_AADHAR_NUMBER) == null
            ? ""
            : sharedPreferences.getString(Constants.SHARED_PREF_AADHAR_NUMBER);
    panNumber =
        sharedPreferences.getString(Constants.SHARED_PREF_PAN_NUMBER) == null
            ? ""
            : sharedPreferences.getString(Constants.SHARED_PREF_PAN_NUMBER);
    gstNumber =
        sharedPreferences.getString(Constants.SHARED_PREF_GST_NUMBER) == null
            ? ""
            : sharedPreferences.getString(Constants.SHARED_PREF_GST_NUMBER);

    setState(() {
      nameController.text = userName;
      emailController.text = userEmail;
      mobileController.text = userMobile;
      addressController.text = userAddress;
      cityController.text = userCity;
      stateController.text = userState;
      pincodeController.text = pincode;
      aadharCardController.text = aadharNumber;
      pancardController.text = panNumber;
      gstController.text = gstNumber;
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

  void updateProfileDetails() {
    HTTPService()
        .updateProfileDetails(authToken, userName, userAddress, userCity,
            userState, pincode, aadharNumber, panNumber, gstNumber)
        .then((response) {
      if (response.statusCode == 200) {
        BasicResponseModel basicResponseBody =
            BasicResponseModel.fromJson(json.decode(response.body));
        if (basicResponseBody.status) {
          saveProfileDetails();
        } else {
          print(
              'Profile details could not be updated ${basicResponseBody.message}');
        }
      } else {
        print('Profile details could not be updated ${response.body}');
      }
    });
  }

  void saveProfileDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(Constants.SHARED_PREF_NAME, userName);
    sharedPreferences.setString(Constants.SHARED_PREF_CITY, userCity);
    sharedPreferences.setString(Constants.SHARED_PREF_ADDRESS, userAddress);
    sharedPreferences.setString(Constants.SHARED_PREF_STATE, userState);
    sharedPreferences.setString(Constants.SHARED_PREF_PINCODE, pincode);
    sharedPreferences.setString(
        Constants.SHARED_PREF_AADHAR_NUMBER, aadharNumber);
    sharedPreferences.setString(Constants.SHARED_PREF_PAN_NUMBER, panNumber);
    sharedPreferences.setString(Constants.SHARED_PREF_GST_NUMBER, gstNumber);
  }
}
