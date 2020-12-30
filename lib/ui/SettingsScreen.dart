import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vimopay_application/customs/constants.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String mobileNumber = "";
  bool _changeMobileNumber = false;
  bool _showMobileChangeProgress = false;
  TextEditingController mobileController;
  String changeMobileOTP = "";

  String emailAddress = "";
  bool _changeEmail = false;
  bool _showEmailChangeProgress = false;
  TextEditingController emailController;
  String changeEmailOTP = "";

  String bankHolderName = "";
  TextEditingController holderNameController;
  String accountNumber = "";
  TextEditingController accountNumberController;
  String ifscCode = "";
  TextEditingController ifscController;

  @override
  void initState() {
    super.initState();

    mobileController = TextEditingController();
    emailController = TextEditingController();
    holderNameController = TextEditingController();
    accountNumberController = TextEditingController();
    ifscController = TextEditingController();

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
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Settings',
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
                                    border: new OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10.0),
                                      ),
                                    ),
                                    filled: true,
                                    hintStyle:
                                        new TextStyle(color: Colors.grey[800]),
                                    hintText: "Enter mobile number",
                                    labelText: 'Mobile Number',
                                    labelStyle: TextStyle(
                                        color: Colors.black54, fontSize: 14),
                                    fillColor: Colors.white70),
                              ),
                            ),
                            Container(
                              width: 90,
                              child: RaisedButton(
                                  onPressed: () {},
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
                                    hintText: "Change email address",
                                    labelText: 'Email Address',
                                    labelStyle: TextStyle(
                                        color: Colors.black54, fontSize: 14),
                                    fillColor: Colors.white70),
                              ),
                            ),
                            Container(
                              width: 90,
                              child: RaisedButton(
                                  onPressed: () {},
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
                        height: 300,
                        width: MediaQuery.of(context).size.width,
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
                            )
                          ],
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
    Navigator.of(context).pop();

    return true;
  }

  void getUserDetails() {
    SharedPreferences.getInstance().then((sharedPrefs) {
      mobileNumber = sharedPrefs.getString(Constants.SHARED_PREF_MOBILE);
      emailAddress = sharedPrefs.getString(Constants.SHARED_PREF_EMAIL);

      setState(() {
        mobileController.text = mobileNumber;
        emailController.text = emailAddress;
      });
    });
  }
}
