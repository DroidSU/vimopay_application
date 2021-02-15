import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vimopay_application/customs/constants.dart';
import 'package:vimopay_application/customs/custom_dialog.dart';
import 'package:vimopay_application/customs/scale_route_transition.dart';
import 'package:vimopay_application/ui/ChangeCredentialsScreen.dart';
import 'package:vimopay_application/ui/DashboardScreen.dart';
import 'package:vimopay_application/ui/EditBankDetailsScreen.dart';
import 'package:vimopay_application/ui/EditProfileScreen.dart';
import 'package:vimopay_application/ui/LoginScreen.dart';

class ProfileScreenNew extends StatefulWidget {
  @override
  _ProfileScreenNewState createState() => _ProfileScreenNewState();
}

class _ProfileScreenNewState extends State<ProfileScreenNew> {
  String name = "";
  String email = "";
  String mobile = "";

  File imageFile;

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
                    Container(
                      child: InkWell(
                        child: Text(
                          'Logout',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        onTap: () {
                          logoutUser();
                        },
                      ),
                      width: 75,
                    ),
                    SizedBox(
                      width: 10,
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
                                              imageFile,
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
                                  mobile,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  name,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  email,
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
                          padding: EdgeInsets.all(10),
                          child: InkWell(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Image.asset(
                                  'images/ic_bank.png',
                                  height: 26,
                                  width: 26,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  'Bank Details',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                  ScaleRoute(page: EditBankDetailScreen()));
                            },
                          )),
                      Container(
                          margin: EdgeInsets.fromLTRB(10, 10, 20, 0),
                          padding: EdgeInsets.all(10),
                          child: InkWell(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Icon(
                                  Icons.lock,
                                  size: 26,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  'Change Credentials',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                  ScaleRoute(page: ChangeCredentialsScreen()));
                            },
                          )),
                      Container(
                          margin: EdgeInsets.fromLTRB(10, 10, 20, 0),
                          padding: EdgeInsets.all(10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Image.asset(
                                'images/ic_discount.png',
                                height: 30,
                                width: 30,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                'Commission Chart',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          )),
                      Container(
                          margin: EdgeInsets.fromLTRB(10, 10, 20, 0),
                          padding: EdgeInsets.all(10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Image.asset(
                                'images/ic_certificate.png',
                                height: 30,
                                width: 30,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                'Certificate',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
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
    Navigator.of(context).pushReplacement(ScaleRoute(page: DashboardScreen()));
    return true;
  }

  void getUserDetails() async {
    SharedPreferences.getInstance().then((sharedPrefs) {
      setState(() {
        name = sharedPrefs.getString(Constants.SHARED_PREF_NAME);
        email = sharedPrefs.getString(Constants.SHARED_PREF_EMAIL);
        mobile = sharedPrefs.getString(Constants.SHARED_PREF_MOBILE);

        String imagePath =
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

        String _base64String = base64Encode(imageFile.readAsBytesSync());

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

        String _base64String = base64Encode(imageFile.readAsBytesSync());
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
}
