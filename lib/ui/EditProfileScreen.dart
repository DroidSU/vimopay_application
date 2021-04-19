import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vimopay_application/customs/constants.dart';
import 'package:vimopay_application/customs/custom_dialog.dart';
import 'package:vimopay_application/network/http_service.dart';
import 'package:vimopay_application/network/models/basic_response_model.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String? companyName = "";
  String? emailAddress = "";
  String? mobileNumber = "";
  String? fullName = "";
  String? address = "";
  String? city = "";
  String? state = "";
  String? pincode = "";
  String? aadharNumber = "";
  String? panNumber = "";
  String? gstNumber = "";
  String? authToken = "";

  TextEditingController? companyController;
  TextEditingController? emailController;
  TextEditingController? mobileController;
  TextEditingController? nameController;
  TextEditingController? addressController;
  TextEditingController? cityController;
  TextEditingController? stateController;
  TextEditingController? pincodeController;
  TextEditingController? aadharController;
  TextEditingController? panController;
  TextEditingController? gstController;

  bool _showProgress = false;

  @override
  void initState() {
    super.initState();
    companyController = TextEditingController();
    emailController = TextEditingController();
    mobileController = TextEditingController();
    nameController = TextEditingController();
    addressController = TextEditingController();
    cityController = TextEditingController();
    stateController = TextEditingController();
    pincodeController = TextEditingController();
    aadharController = TextEditingController();
    panController = TextEditingController();
    gstController = TextEditingController();

    getUserDetails();
  }

  @override
  void dispose() {
    companyController!.dispose();
    emailController!.dispose();
    mobileController!.dispose();
    nameController!.dispose();
    addressController!.dispose();
    cityController!.dispose();
    stateController!.dispose();
    pincodeController!.dispose();
    aadharController!.dispose();
    panController!.dispose();
    gstController!.dispose();

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
                      'Edit Profile',
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
                  margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          fillColor: Colors.grey.withOpacity(0.3),
                          filled: true,
                          hintText: 'Company',
                          hintStyle: TextStyle(
                              color: Colors.black54.withOpacity(0.3),
                              fontFamily: 'Segoe'),
                        ),
                        controller: companyController,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      emailAddress != null
                          ? TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                fillColor: Colors.grey.withOpacity(0.3),
                                filled: true,
                                hintText: 'Email Address',
                                hintStyle: TextStyle(
                                    color: Colors.black54.withOpacity(0.3),
                                    fontFamily: 'Segoe'),
                              ),
                              controller: emailController,
                              enabled: false,
                            )
                          : Container(),
                      mobileNumber != null
                          ? SizedBox(
                              height: 20,
                            )
                          : Container(),
                      mobileNumber != null
                          ? TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                fillColor: Colors.grey.withOpacity(0.3),
                                filled: true,
                                hintText: 'Mobile Number',
                                hintStyle: TextStyle(
                                    color: Colors.black54.withOpacity(0.3),
                                    fontFamily: 'Segoe'),
                              ),
                              controller: mobileController,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10)
                              ],
                              keyboardType: TextInputType.number,
                              enabled: false,
                            )
                          : Container(),
                      fullName!.isNotEmpty
                          ? SizedBox(
                              height: 20,
                            )
                          : Container(),
                      fullName!.isNotEmpty
                          ? TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                fillColor: Colors.grey.withOpacity(0.3),
                                filled: true,
                                hintText: 'Full Name',
                                hintStyle: TextStyle(
                                    color: Colors.black54.withOpacity(0.3),
                                    fontFamily: 'Segoe'),
                              ),
                              controller: nameController,
                              enabled: false,
                            )
                          : Container(),
                      address != null
                          ? SizedBox(
                              height: 20,
                            )
                          : Container(),
                      address != null
                          ? TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                fillColor: Colors.grey.withOpacity(0.3),
                                filled: true,
                                hintText: 'Address',
                                hintStyle: TextStyle(
                                    color: Colors.black54.withOpacity(0.3),
                                    fontFamily: 'Segoe'),
                              ),
                              controller: addressController,
                              enabled: false,
                            )
                          : Container(),
                      city != null
                          ? SizedBox(
                              height: 20,
                            )
                          : Container(),
                      city != null
                          ? TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                fillColor: Colors.grey.withOpacity(0.3),
                                filled: true,
                                hintText: 'City',
                                hintStyle: TextStyle(
                                    color: Colors.black54.withOpacity(0.3),
                                    fontFamily: 'Segoe'),
                              ),
                              controller: cityController,
                              enabled: false,
                            )
                          : Container(),
                      state != null
                          ? SizedBox(
                              height: 20,
                            )
                          : Container(),
                      state != null
                          ? TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                fillColor: Colors.grey.withOpacity(0.3),
                                filled: true,
                                hintText: 'State',
                                hintStyle: TextStyle(
                                    color: Colors.black54.withOpacity(0.3),
                                    fontFamily: 'Segoe'),
                              ),
                              controller: stateController,
                              enabled: false,
                            )
                          : Container(),
                      pincode != null
                          ? SizedBox(
                              height: 20,
                            )
                          : Container(),
                      pincode != null
                          ? TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                fillColor: Colors.grey.withOpacity(0.3),
                                filled: true,
                                hintText: 'Pincode',
                                hintStyle: TextStyle(
                                    color: Colors.black54.withOpacity(0.3),
                                    fontFamily: 'Segoe'),
                              ),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(6),
                              ],
                              keyboardType: TextInputType.number,
                              controller: pincodeController,
                              enabled: false,
                            )
                          : Container(),
                      aadharNumber != null
                          ? SizedBox(
                              height: 20,
                            )
                          : Container(),
                      aadharNumber != null
                          ? TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                fillColor: Colors.grey.withOpacity(0.3),
                                filled: true,
                                hintText: 'Aadhar Number',
                                hintStyle: TextStyle(
                                    color: Colors.black54.withOpacity(0.3),
                                    fontFamily: 'Segoe'),
                              ),
                              controller: aadharController,
                              enabled: false,
                            )
                          : Container(),
                      panNumber != null
                          ? SizedBox(
                              height: 20,
                            )
                          : Container(),
                      panNumber != null
                          ? TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                fillColor: Colors.grey.withOpacity(0.3),
                                filled: true,
                                hintText: 'PAN Number',
                                hintStyle: TextStyle(
                                    color: Colors.black54.withOpacity(0.3),
                                    fontFamily: 'Segoe'),
                              ),
                              controller: panController,
                              enabled: false,
                            )
                          : Container(),
                      gstNumber != null
                          ? SizedBox(
                              height: 20,
                            )
                          : Container(),
                      gstNumber != null
                          ? TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                fillColor: Colors.grey.withOpacity(0.3),
                                filled: true,
                                hintText: 'GST Number',
                                hintStyle: TextStyle(
                                    color: Colors.black54.withOpacity(0.3),
                                    fontFamily: 'Segoe'),
                              ),
                              controller: gstController,
                              enabled: false,
                            )
                          : Container(),
                      SizedBox(
                        height: 20,
                      ),
                      _showProgress
                          ? CircularProgressIndicator()
                          : MaterialButton(
                              onPressed: () {
                                updateProfileDetails();
                              },
                              minWidth: 200,
                              child: Text(
                                'Save',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              color: Colors.blue[900],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        )),
        onWillPop: onBackPressed);
  }

  Future<bool> onBackPressed() async {
    Navigator.of(context).pop();
    return true;
  }

  void updateProfileDetails() {
    address = addressController!.text.trim();
    city = cityController!.text.trim();
    state = stateController!.text.trim();
    pincode = pincodeController!.text.trim();
    aadharNumber = aadharController!.text.trim();
    panNumber = panController!.text.trim();
    fullName = nameController!.text.trim();
    emailAddress = emailController!.text.trim();
    companyName = companyController!.text.trim();
    mobileNumber = mobileController!.text.trim();

    // if (fullName.isNotEmpty &&
    //     address.isNotEmpty &&
    //     city.isNotEmpty &&
    //     state.isNotEmpty &&
    //     pincode.length == 6 &&
    //     aadharNumber.length == 12 &&
    //     panNumber.length == 10) {
    //
    // } else {}

    setState(() {
      _showProgress = true;
    });

    HTTPService()
        .updateProfileDetails(authToken!, fullName, address, city, state,
            pincode, aadharNumber, panNumber, gstNumber)
        .then((response) {
      setState(() {
        _showProgress = false;
      });
      if (response.statusCode == 200) {
        BasicResponseModel basicResponseBody =
            BasicResponseModel.fromJson(json.decode(response.body));
        if (basicResponseBody.status!) {
          SharedPreferences.getInstance().then((sharedPrefs) {
            sharedPrefs.setString(Constants.SHARED_PREF_NAME, fullName!);
            sharedPrefs.setString(Constants.SHARED_PREF_EMAIL, emailAddress!);
            sharedPrefs.setString(Constants.SHARED_PREF_MOBILE, mobileNumber!);
            sharedPrefs.setString(Constants.SHARED_PREF_ADDRESS, address!);
            sharedPrefs.setString(Constants.SHARED_PREF_CITY, city!);
            sharedPrefs.setString(Constants.SHARED_PREF_STATE, state!);
            sharedPrefs.setString(Constants.SHARED_PREF_PINCODE, pincode!);
            sharedPrefs.setString(
                Constants.SHARED_PREF_AADHAR_NUMBER, aadharNumber!);
            sharedPrefs.setString(Constants.SHARED_PREF_PAN_NUMBER, panNumber!);
            sharedPrefs.setString(Constants.COMPANY_NAME, companyName!);
          });

          showSuccessDialog(context, 'Profile details changed!');
        } else {
          print(
              'Profile details could not be updated ${basicResponseBody.message}');
        }
      } else {
        print('Profile details could not be updated ${response.body}');
      }
    });
  }

  void getUserDetails() {
    SharedPreferences.getInstance().then((sharedPrefs) {
      authToken = sharedPrefs.getString(Constants.SHARED_PREF_TOKEN);
      companyName = sharedPrefs.getString(Constants.COMPANY_NAME);
      emailAddress = sharedPrefs.getString(Constants.SHARED_PREF_EMAIL);
      mobileNumber = sharedPrefs.getString(Constants.SHARED_PREF_MOBILE);
      fullName = sharedPrefs.getString(Constants.SHARED_PREF_NAME);
      address = sharedPrefs.getString(Constants.SHARED_PREF_ADDRESS);
      city = sharedPrefs.getString(Constants.SHARED_PREF_CITY);
      state = sharedPrefs.getString(Constants.SHARED_PREF_STATE);
      pincode = sharedPrefs.getString(Constants.SHARED_PREF_PINCODE);
      aadharNumber = sharedPrefs.getString(Constants.SHARED_PREF_AADHAR_NUMBER);
      panNumber = sharedPrefs.getString(Constants.SHARED_PREF_PAN_NUMBER);
      gstNumber = sharedPrefs.getString(Constants.SHARED_PREF_GST_NUMBER);

      setState(() {
        companyController!.text = companyName!;
        emailController!.text = emailAddress!;
        mobileController!.text = mobileNumber!;
        nameController!.text = fullName!;
        addressController!.text = address!;
        cityController!.text = city!;
        stateController!.text = state!;
        pincodeController!.text = pincode!;
        aadharController!.text = aadharNumber!;
        panController!.text = panNumber!;
      });
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
}
