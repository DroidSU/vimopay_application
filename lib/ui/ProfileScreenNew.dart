import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vimopay_application/customs/constants.dart';
import 'package:vimopay_application/customs/custom_dialog.dart';
import 'package:vimopay_application/customs/scale_route_transition.dart';
import 'package:vimopay_application/network/http_service.dart';
import 'package:vimopay_application/network/models/basic_response_model.dart';
import 'package:vimopay_application/network/models/commission_plan_response_model.dart';
import 'package:vimopay_application/ui/CommissionChartScreen.dart';
import 'package:vimopay_application/ui/DashboardScreen.dart';
import 'package:vimopay_application/ui/EditBankDetailsScreen.dart';
import 'package:vimopay_application/ui/EditProfileScreen.dart';
import 'package:vimopay_application/ui/LoginScreen.dart';

import 'ChangeCredentialsScreen.dart';

class ProfileScreenNew extends StatefulWidget {
  @override
  _ProfileScreenNewState createState() => _ProfileScreenNewState();
}

class _ProfileScreenNewState extends State<ProfileScreenNew> {
  String? name = "";
  String? email = "";
  String? mobile = "";
  String? userId = "";

  File? imageFile;
  String? authToken = "";
  String oldPassword = '';
  String newPassword = '';
  String confirmPassword = '';
  bool _showChangePasswordUI = false;
  bool _showChangePasswordProgress = false;
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  TextEditingController? oldPasswordController;
  TextEditingController? newPasswordController;
  TextEditingController? confirmPasswordController;

  @override
  void initState() {
    super.initState();
    getUserDetails();
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
                        'Profile',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    // Container(
                    //   child: InkWell(
                    //     child: Text(
                    //       'Logout',
                    //       style: TextStyle(
                    //           color: Colors.white,
                    //           fontWeight: FontWeight.bold,
                    //           fontSize: 18),
                    //     ),
                    //     onTap: () {
                    //       logoutUser();
                    //     },
                    //   ),
                    //   width: 75,
                    // ),
                    // SizedBox(
                    //   width: 10,
                    // ),
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
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                                height: 80,
                                width: 80,
                                decoration:
                                    BoxDecoration(shape: BoxShape.circle),
                                child: Stack(
                                  children: [
                                    imageFile == null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: Image.asset(
                                              'images/default_user.png',
                                              height: 80,
                                              width: 80,
                                            ),
                                          )
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(40.0),
                                            child: Image.file(
                                              imageFile!,
                                              width: 80.0,
                                              height: 80.0,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                    Align(
                                        alignment: Alignment.bottomRight,
                                        child: InkWell(
                                          child: Material(
                                            shape: CircleBorder(),
                                            elevation: 5,
                                            color: Colors.blue[900],
                                            child: Padding(
                                              padding: EdgeInsets.all(5),
                                              child: Icon(
                                                Icons.camera_alt,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            showImagePickerDialog();
                                          },
                                        )),
                                  ],
                                )),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userId!,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  mobile!,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  name!,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  email!,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                Material(
                                    elevation: 5,
                                    color: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    child: InkWell(
                                      child: Text(
                                        'Edit Profile',
                                        style: TextStyle(
                                            color: Colors.blue, fontSize: 14),
                                      ),
                                      onTap: () {
                                        Navigator.of(context).push(ScaleRoute(
                                            page: EditProfileScreen()));
                                      },
                                    ))
                              ],
                            ),
                          ],
                        ),
                        margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                      ),
                      Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                      Container(
                          margin: EdgeInsets.fromLTRB(10, 0, 20, 0),
                          padding: EdgeInsets.all(5),
                          child: InkWell(
                            child: Material(
                                elevation: 10,
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(20, 0, 10, 0),
                                  padding: EdgeInsets.fromLTRB(15, 15, 5, 15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        'images/ic_bank.png',
                                        height: 26,
                                        width: 26,
                                        color: Colors.black,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Text(
                                          'Bank Details',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                      Container(
                                        width: 50,
                                        child: Icon(
                                          Icons.navigate_next_sharp,
                                          color: Colors.black,
                                          size: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            onTap: () {
                              Navigator.of(context).push(
                                  ScaleRoute(page: EditBankDetailScreen()));
                            },
                          )),
                      Container(
                          margin: EdgeInsets.fromLTRB(10, 0, 20, 0),
                          padding: EdgeInsets.all(5),
                          child: InkWell(
                            child: Material(
                                elevation: 10,
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(20, 0, 10, 0),
                                  padding: EdgeInsets.fromLTRB(15, 15, 5, 15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.lock,
                                        size: 26,
                                        color: Colors.black,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Text(
                                          'Change Credentials',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                      Container(
                                        width: 50,
                                        child: Icon(
                                          Icons.navigate_next_sharp,
                                          color: Colors.black,
                                          size: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            onTap: () {
                              Navigator.of(context).push(
                                  ScaleRoute(page: ChangeCredentialsScreen()));
                            },
                          )),
                      Container(
                        margin: EdgeInsets.fromLTRB(15, 10, 20, 0),
                        child: InkWell(
                          child: Material(
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              margin: EdgeInsets.fromLTRB(20, 0, 10, 0),
                              padding: EdgeInsets.fromLTRB(15, 15, 5, 15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        'images/ic_key.png',
                                        height: 26,
                                        width: 26,
                                        color: Colors.black,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Text(
                                          'Change Password',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                      Container(
                                          width: 50,
                                          child: InkWell(
                                            child: Icon(
                                              !_showChangePasswordUI
                                                  ? Icons.navigate_next_sharp
                                                  : Icons
                                                      .arrow_drop_down_rounded,
                                              color: Colors.black,
                                            ),
                                            onTap: () {
                                              setState(() {
                                                _showChangePasswordUI =
                                                    !_showChangePasswordUI;
                                              });
                                            },
                                          ))
                                    ],
                                  ),
                                  _showChangePasswordUI
                                      ? Container(
                                          margin:
                                              EdgeInsets.fromLTRB(0, 20, 20, 0),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                height: 50,
                                                alignment: Alignment.center,
                                                child: TextField(
                                                  decoration: InputDecoration(
                                                    suffixIcon: IconButton(
                                                      icon: _obscureOldPassword
                                                          ? Icon(
                                                              Icons
                                                                  .visibility_rounded,
                                                              color:
                                                                  Colors.black,
                                                            )
                                                          : Icon(
                                                              Icons
                                                                  .visibility_off,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                      onPressed: () {
                                                        setState(() {
                                                          _obscureOldPassword =
                                                              !_obscureOldPassword;
                                                        });
                                                      },
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    errorBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    focusedErrorBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    disabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    hintText:
                                                        'Current Password',
                                                    hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                    filled: true,
                                                    fillColor: Colors.white
                                                        .withOpacity(0.3),
                                                  ),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontFamily: ''),
                                                  textAlign: TextAlign.center,
                                                  controller:
                                                      oldPasswordController,
                                                  keyboardType: TextInputType
                                                      .visiblePassword,
                                                  obscureText:
                                                      _obscureOldPassword,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Container(
                                                height: 50,
                                                alignment: Alignment.center,
                                                child: TextField(
                                                  decoration: InputDecoration(
                                                    suffixIcon: IconButton(
                                                      icon: _obscureNewPassword
                                                          ? Icon(
                                                              Icons
                                                                  .visibility_rounded,
                                                              color:
                                                                  Colors.black,
                                                            )
                                                          : Icon(
                                                              Icons
                                                                  .visibility_off,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                      onPressed: () {
                                                        setState(() {
                                                          _obscureNewPassword =
                                                              !_obscureNewPassword;
                                                        });
                                                      },
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    errorBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    focusedErrorBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    disabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    hintText: 'New Password',
                                                    hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                    filled: true,
                                                    fillColor: Colors.white
                                                        .withOpacity(0.3),
                                                  ),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontFamily: ''),
                                                  textAlign: TextAlign.center,
                                                  controller:
                                                      newPasswordController,
                                                  keyboardType: TextInputType
                                                      .visiblePassword,
                                                  obscureText:
                                                      _obscureNewPassword,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Container(
                                                height: 50,
                                                alignment: Alignment.center,
                                                child: TextField(
                                                  decoration: InputDecoration(
                                                    suffixIcon: IconButton(
                                                      icon:
                                                          _obscureConfirmPassword
                                                              ? Icon(
                                                                  Icons
                                                                      .visibility_rounded,
                                                                  color: Colors
                                                                      .black,
                                                                )
                                                              : Icon(
                                                                  Icons
                                                                      .visibility_off,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                      onPressed: () {
                                                        setState(() {
                                                          _obscureConfirmPassword =
                                                              !_obscureConfirmPassword;
                                                        });
                                                      },
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    errorBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    focusedErrorBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    disabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    hintText:
                                                        'Confirm Password',
                                                    hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                    filled: true,
                                                    fillColor: Colors.white
                                                        .withOpacity(0.3),
                                                  ),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontFamily: ''),
                                                  textAlign: TextAlign.center,
                                                  controller:
                                                      confirmPasswordController,
                                                  keyboardType: TextInputType
                                                      .visiblePassword,
                                                  obscureText:
                                                      _obscureConfirmPassword,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              _showChangePasswordProgress
                                                  ? CircularProgressIndicator()
                                                  : MaterialButton(
                                                      onPressed: () {
                                                        String password =
                                                            oldPasswordController!
                                                                .text
                                                                .trim();
                                                        newPassword =
                                                            newPasswordController!
                                                                .text
                                                                .trim();
                                                        confirmPassword =
                                                            confirmPasswordController!
                                                                .text
                                                                .trim();

                                                        if (password ==
                                                                oldPassword &&
                                                            newPassword
                                                                .isNotEmpty &&
                                                            confirmPassword
                                                                .isNotEmpty &&
                                                            newPassword ==
                                                                confirmPassword) {
                                                          setState(() {
                                                            _showChangePasswordProgress =
                                                                true;
                                                          });
                                                          HTTPService()
                                                              .changePassword(
                                                                  authToken!,
                                                                  newPassword)
                                                              .then((response) {
                                                            setState(() {
                                                              _showChangePasswordProgress =
                                                                  false;
                                                            });

                                                            if (response
                                                                    .statusCode ==
                                                                200) {
                                                              BasicResponseModel
                                                                  responseModel =
                                                                  BasicResponseModel.fromJson(
                                                                      json.decode(
                                                                          response
                                                                              .body));
                                                              if (responseModel
                                                                  .status!) {
                                                                showSuccessDialog(
                                                                    context,
                                                                    responseModel
                                                                        .message);
                                                                setState(() {
                                                                  _showChangePasswordUI =
                                                                      false;
                                                                  SharedPreferences
                                                                          .getInstance()
                                                                      .then(
                                                                          (sharedPrefs) {
                                                                    sharedPrefs.setString(
                                                                        Constants
                                                                            .SHARED_PREF_PASSWORD,
                                                                        password);
                                                                  });
                                                                });
                                                              } else {
                                                                showErrorDialog(
                                                                    responseModel
                                                                        .message);
                                                              }
                                                            } else {
                                                              showErrorDialog(
                                                                  'Error occurred ${response.statusCode}');
                                                            }
                                                          });
                                                        } else {
                                                          if (password
                                                              .isNotEmpty)
                                                            showErrorDialog(
                                                                'Please enter current password');
                                                          else if (password !=
                                                              oldPassword)
                                                            showErrorDialog(
                                                                'Invalid current password');
                                                          else if (newPassword
                                                              .isEmpty)
                                                            showErrorDialog(
                                                                'Invalid new password');
                                                          else if (confirmPassword
                                                              .isEmpty)
                                                            showErrorDialog(
                                                                'Please confirm your password');
                                                          else if (newPassword !=
                                                              confirmPassword)
                                                            showErrorDialog(
                                                                'Passwords do not match');
                                                        }
                                                      },
                                                      color: Color(0xff133374),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                      child: Text(
                                                        'Change',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                            elevation: 10,
                          ),
                          onTap: () {
                            setState(() {
                              _showChangePasswordUI = !_showChangePasswordUI;
                            });
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 10, 20, 0),
                        padding: EdgeInsets.all(5),
                        child: Material(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                              margin: EdgeInsets.fromLTRB(20, 0, 10, 0),
                              padding: EdgeInsets.fromLTRB(15, 15, 5, 15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15)),
                              child: InkWell(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      'images/ic_discount.png',
                                      height: 30,
                                      width: 30,
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'My Commissions',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                    Container(
                                      width: 50,
                                      child: Icon(
                                        Icons.navigate_next_sharp,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.of(context).push(ScaleRoute(
                                      page: CommissionChartScreen()));
                                },
                              )),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 10, 20, 0),
                        padding: EdgeInsets.all(5),
                        child: InkWell(
                          child: Material(
                            child: Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Download Commission Plan',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Icon(
                                    Icons.download_rounded,
                                    size: 22,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                              margin: EdgeInsets.fromLTRB(20, 0, 10, 0),
                              padding: EdgeInsets.fromLTRB(15, 15, 5, 15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                            elevation: 10,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          onTap: () {
                            getDownloadURL();
                          },
                        ),
                      ),
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
    Navigator.of(context).pushReplacement(ScaleRoute(page: DashboardScreen()));
    return true;
  }

  void getUserDetails() async {
    SharedPreferences.getInstance().then((sharedPrefs) {
      setState(() {
        name = sharedPrefs.getString(Constants.SHARED_PREF_NAME);
        email = sharedPrefs.getString(Constants.SHARED_PREF_EMAIL);
        mobile = sharedPrefs.getString(Constants.SHARED_PREF_MOBILE);
        authToken = sharedPrefs.getString(Constants.SHARED_PREF_TOKEN);
        userId = sharedPrefs.getString(Constants.SHARED_PREF_USER_ID);

        String? imagePath =
            sharedPrefs.getString(Constants.SHARED_PREF_USER_DP_PATH);
        if (imagePath != null) imageFile = File(imagePath);
      });
    });
  }

  void logoutUser() async {
    SharedPreferences.getInstance().then((sharedPrefs) {
      sharedPrefs.clear();
    });
    Navigator.of(context)
        .pushAndRemoveUntil(ScaleRoute(page: LoginScreen()), (route) => false);
  }

  void showImagePickerDialog() {
    showDialog(
        context: context,
        builder: (buildContext) {
          return CustomAlertDialog(
            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            content: Container(
              height: 220,
              decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                color: const Color(0xFFFFFF),
                borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Choose image from',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    child: Material(
                      elevation: 10,
                      child: Container(
                          padding: EdgeInsets.all(8),
                          width: 180,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'images/ic_camera.png',
                                height: 30,
                                width: 30,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'From Camera',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                            ],
                          )),
                    ),
                    onTap: () {
                      getImage(true);
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    child: Material(
                      elevation: 10,
                      child: Container(
                          padding: EdgeInsets.all(8),
                          width: 180,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'images/ic_gallery.png',
                                height: 30,
                                width: 30,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'From Gallery',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                            ],
                          )),
                    ),
                    onTap: () {
                      getImage(false);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  Future getImage(bool isFromCamera) async {
    String imagePath = "";

    if (isFromCamera) {
      final pickedFile =
          await ImagePicker().getImage(source: ImageSource.camera);

      if (pickedFile != null) {
        setState(() {
          imagePath = pickedFile.path;
          imageFile = File(imagePath);
        });

        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString(
            Constants.SHARED_PREF_USER_DP_PATH, imagePath);

        String _base64String = base64Encode(imageFile!.readAsBytesSync());

        Navigator.of(context).pop();

        // HTTPService()
        //     .uploadProfilePicture(authToken, _base64String)
        //     .then((response) => {
        //   if (response.statusCode == 200)
        //     print('Upload successful')
        //   else
        //     print('Upload unsuccessful')
        // });
      }
    } else {
      final pickedFile =
          await ImagePicker().getImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          imagePath = pickedFile.path;
          imageFile = File(imagePath);
        });

        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString(
            Constants.SHARED_PREF_USER_DP_PATH, imagePath);

        String _base64String = base64Encode(imageFile!.readAsBytesSync());
        print('Image string: $_base64String');

        Navigator.of(context).pop();

        // HTTPService()
        //     .uploadProfilePicture(authToken, _base64String)
        //     .then((response) => {
        //   if (response.statusCode == 200)
        //     print('Upload successful')
        //   else
        //     print('Upload unsuccessful')
        // });
      }
    }
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
                          message!,
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

  void showSuccessDialog(BuildContext buildContext, String? message) {
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
                          message!,
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

  void getDownloadURL() {
    HTTPService().getCommissionPlanPDF(authToken!).then((response) {
      if (response.statusCode == 200) {
        CommissionPlanResponseModel responseModel =
            CommissionPlanResponseModel.fromJson(json.decode(response.body));
        if (responseModel.status!) {
          String? url = responseModel.data!.pDF;

          startDownload(url);
        } else {
          showErrorDialog("Access restricted to only Super Admins");
        }
      } else {
        showErrorDialog("Error occurred!");
      }
    });
  }

  Future startDownload(String? url) async {
    String storagePath = "";
    // getExternalStorageDirectory().then((directory) {
    //   storagePath =
    //       '${directory.path}${Platform.pathSeparator}commission_plan.pdf';
    //   // storagePath = directory.path;
    //
    //   print('Storing in : $storagePath');
    //
    //   FlutterDownloader.enqueue(
    //     url: url,
    //     savedDir: storagePath,
    //     showNotification:
    //         true, // show download progress in status bar (for Android)
    //     openFileFromNotification:
    //         true, // click on notification to open downloaded file (for Android)
    //   ).then((taskResponse) {
    //     print('Download response : $taskResponse');
    //   });
    // });
  }
}
