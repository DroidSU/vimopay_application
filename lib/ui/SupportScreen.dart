import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vimopay_application/customs/constants.dart';
import 'package:vimopay_application/customs/custom_dialog.dart';
import 'package:vimopay_application/network/http_service.dart';
import 'package:vimopay_application/network/models/basic_response_model.dart';

class SupportScreen extends StatefulWidget {
  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  String authToken = "";
  String userId = "";

  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  bool _showSubmitProgress = false;
  String mobileNumber = "";
  String name = "";
  String message = "";

  List<String> listOfStatus = [
    'Please Refund',
    'Recharge Error',
    'IP Address Wrong',
    'Show Low Balance',
    'Customize'
  ];

  bool _showComplainUI = false;
  String complainStatus = "";
  String complainDescription = "";
  TextEditingController descController;
  bool _showComplaintProgress = false;

  @override
  void dispose() {
    descController.dispose();
    mobileNumberController.dispose();
    nameController.dispose();
    messageController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    descController = TextEditingController();
    mobileNumberController = TextEditingController();
    nameController = TextEditingController();
    messageController = TextEditingController();

    SharedPreferences.getInstance().then((sharedPrefs) {
      authToken = sharedPrefs.getString(Constants.SHARED_PREF_TOKEN);
      userId = sharedPrefs.getString(Constants.SHARED_PREF_USER_ID);
    });

    complainStatus = listOfStatus[0];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size(double.infinity, 100),
            child: Container(
              height: 52,
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
                      'Support',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  // Container(
                  //   width: MediaQuery.of(context).size.width,
                  //   child: Text(
                  //     'Support Details',
                  //     style: TextStyle(color: Colors.black, fontSize: 18),
                  //   ),
                  //   alignment: Alignment.center,
                  // ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
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
                            Container(
                                child: InkWell(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.mail_rounded,
                                    color: Colors.black,
                                    size: 24,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'support@vimopay.in',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                              onTap: () {
                                // launch('mailTo:info@vimopay.in');
                                final Email email = Email(
                                  isHTML: false,
                                );

                                FlutterEmailSender.send(email).then((value) {});
                              },
                            )),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              child: InkWell(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.call,
                                      color: Colors.black,
                                      size: 24,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      '+91 6291 639 261',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  launch("tel://6291639261");
                                },
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                                child: InkWell(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.message_rounded,
                                    color: Colors.black,
                                    size: 24,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'SMS US',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (buildContext) {
                                      return StatefulBuilder(
                                          builder: (context, setState) {
                                        return CustomAlertDialog(
                                          content: Container(
                                              height: 340,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color: Color(0xfffffff1)),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      'Mobile number',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    TextField(
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.all(5),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          borderSide: BorderSide(
                                                              width: 0.5,
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.6)),
                                                        ),
                                                        disabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          borderSide: BorderSide(
                                                              width: 0.5,
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.6)),
                                                        ),
                                                        focusedErrorBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          borderSide: BorderSide(
                                                              width: 0.5,
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.6)),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          borderSide: BorderSide(
                                                              width: 0.5,
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.6)),
                                                        ),
                                                        errorBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          borderSide: BorderSide(
                                                              width: 0.5,
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.6)),
                                                        ),
                                                        fillColor: Colors.white
                                                            .withOpacity(0.3),
                                                        filled: true,
                                                      ),
                                                      keyboardType:
                                                          TextInputType.phone,
                                                      inputFormatters: [
                                                        LengthLimitingTextInputFormatter(
                                                            10),
                                                      ],
                                                      textAlign:
                                                          TextAlign.center,
                                                      controller:
                                                          mobileNumberController,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      'Name',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    TextField(
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.all(5),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          borderSide: BorderSide(
                                                              width: 0.5,
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.6)),
                                                        ),
                                                        disabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          borderSide: BorderSide(
                                                              width: 0.5,
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.6)),
                                                        ),
                                                        focusedErrorBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          borderSide: BorderSide(
                                                              width: 0.5,
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.6)),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          borderSide: BorderSide(
                                                              width: 0.5,
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.6)),
                                                        ),
                                                        errorBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          borderSide: BorderSide(
                                                              width: 0.5,
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.6)),
                                                        ),
                                                        fillColor: Colors.white
                                                            .withOpacity(0.3),
                                                        filled: true,
                                                      ),
                                                      keyboardType:
                                                          TextInputType.name,
                                                      textAlign:
                                                          TextAlign.center,
                                                      controller:
                                                          nameController,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      'Message',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    TextField(
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.all(5),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          borderSide: BorderSide(
                                                              width: 0.5,
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.6)),
                                                        ),
                                                        disabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          borderSide: BorderSide(
                                                              width: 0.5,
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.6)),
                                                        ),
                                                        focusedErrorBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          borderSide: BorderSide(
                                                              width: 0.5,
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.6)),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          borderSide: BorderSide(
                                                              width: 0.5,
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.6)),
                                                        ),
                                                        errorBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          borderSide: BorderSide(
                                                              width: 0.5,
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.6)),
                                                        ),
                                                        fillColor: Colors.white
                                                            .withOpacity(0.3),
                                                        filled: true,
                                                      ),
                                                      keyboardType:
                                                          TextInputType.text,
                                                      textAlign:
                                                          TextAlign.center,
                                                      controller:
                                                          messageController,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: _showSubmitProgress
                                                          ? CircularProgressIndicator()
                                                          : MaterialButton(
                                                              color: Color(
                                                                  0xff133374),
                                                              child: Text(
                                                                'Submit',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              onPressed: () {
                                                                mobileNumber =
                                                                    mobileNumberController
                                                                        .text
                                                                        .trim();
                                                                name =
                                                                    nameController
                                                                        .text
                                                                        .trim();
                                                                message =
                                                                    messageController
                                                                        .text
                                                                        .trim();

                                                                if (mobileNumber !=
                                                                        null &&
                                                                    mobileNumber
                                                                            .length ==
                                                                        10 &&
                                                                    name
                                                                        .isNotEmpty &&
                                                                    message
                                                                        .isNotEmpty) {
                                                                  setState(() {
                                                                    _showSubmitProgress =
                                                                        true;
                                                                  });
                                                                  HTTPService()
                                                                      .retailerSMSEnquire(
                                                                          authToken:
                                                                              authToken,
                                                                          retailerID:
                                                                              userId,
                                                                          mobileNumber:
                                                                              mobileNumber,
                                                                          name:
                                                                              name,
                                                                          message:
                                                                              message)
                                                                      .then(
                                                                          (response) {
                                                                    setState(
                                                                        () {
                                                                      _showSubmitProgress =
                                                                          false;
                                                                    });
                                                                    if (response
                                                                            .statusCode ==
                                                                        200) {
                                                                      BasicResponseModel
                                                                          responseModel =
                                                                          BasicResponseModel.fromJson(
                                                                              json.decode(response.body));
                                                                      if (responseModel
                                                                          .status) {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                        setState(
                                                                            () {
                                                                          mobileNumberController.text =
                                                                              "";
                                                                          nameController.text =
                                                                              "";
                                                                          messageController.text =
                                                                              "";
                                                                        });
                                                                        String
                                                                            message =
                                                                            'Thank You\n ${responseModel.message}';
                                                                        showSuccessDialog(
                                                                            buildContext,
                                                                            message);
                                                                      } else {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                        showErrorDialog(
                                                                            responseModel.message);
                                                                      }
                                                                    } else {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      showErrorDialog(
                                                                          'Error occurred ${response.statusCode}');
                                                                    }
                                                                  });
                                                                }
                                                              },
                                                            ),
                                                      alignment:
                                                          Alignment.center,
                                                    )
                                                  ],
                                                ),
                                              )),
                                        );
                                      });
                                    });
                              },
                            )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // Container(
                  //   margin: EdgeInsets.fromLTRB(30, 20, 30, 0),
                  //   child: Material(
                  //     borderRadius: BorderRadius.circular(15),
                  //     child: Container(
                  //       margin: EdgeInsets.fromLTRB(20, 0, 10, 0),
                  //       padding: EdgeInsets.fromLTRB(15, 15, 5, 15),
                  //       decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(15)),
                  //       child: Column(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         mainAxisSize: MainAxisSize.max,
                  //         children: [
                  //           Row(
                  //             children: [
                  //               Expanded(
                  //                 child: Text(
                  //                   'Raise New Complain',
                  //                   style: TextStyle(
                  //                       color: Colors.black,
                  //                       fontSize: 18,
                  //                       fontWeight: FontWeight.normal),
                  //                 ),
                  //               ),
                  //               Container(
                  //                   width: 50,
                  //                   child: InkWell(
                  //                     child: Icon(
                  //                       !_showComplainUI
                  //                           ? Icons.navigate_next_sharp
                  //                           : Icons.arrow_downward_rounded,
                  //                       color: Colors.black,
                  //                     ),
                  //                     onTap: () {
                  //                       setState(() {
                  //                         _showComplainUI = !_showComplainUI;
                  //                       });
                  //                     },
                  //                   ))
                  //             ],
                  //           ),
                  //           _showComplainUI
                  //               ? Container(
                  //                   margin: EdgeInsets.fromLTRB(0, 20, 20, 0),
                  //                   child: Column(
                  //                     children: [
                  //                       SizedBox(
                  //                         height: 10,
                  //                       ),
                  //                       Container(
                  //                         child: DropdownButton(
                  //                           isExpanded: true,
                  //                           onChanged: (value) {
                  //                             setState(() {
                  //                               complainStatus = value;
                  //                             });
                  //                           },
                  //                           value: complainStatus,
                  //                           items: listOfStatus.map((e) {
                  //                             return DropdownMenuItem(
                  //                               child: Text(
                  //                                 e,
                  //                                 style: TextStyle(
                  //                                     color: Colors.black,
                  //                                     fontWeight:
                  //                                         FontWeight.normal),
                  //                               ),
                  //                               value: e,
                  //                             );
                  //                           }).toList(),
                  //                         ),
                  //                         margin:
                  //                             EdgeInsets.fromLTRB(15, 0, 15, 0),
                  //                       ),
                  //                       SizedBox(
                  //                         height: 20,
                  //                       ),
                  //                       TextField(
                  //                         decoration: InputDecoration(
                  //                           border: OutlineInputBorder(
                  //                             borderRadius:
                  //                                 BorderRadius.circular(10),
                  //                           ),
                  //                           errorBorder: OutlineInputBorder(
                  //                             borderRadius:
                  //                                 BorderRadius.circular(10),
                  //                           ),
                  //                           focusedBorder: OutlineInputBorder(
                  //                             borderRadius:
                  //                                 BorderRadius.circular(10),
                  //                           ),
                  //                           focusedErrorBorder:
                  //                               OutlineInputBorder(
                  //                             borderRadius:
                  //                                 BorderRadius.circular(10),
                  //                           ),
                  //                           disabledBorder: OutlineInputBorder(
                  //                             borderRadius:
                  //                                 BorderRadius.circular(10),
                  //                           ),
                  //                           enabledBorder: OutlineInputBorder(
                  //                             borderRadius:
                  //                                 BorderRadius.circular(10),
                  //                           ),
                  //                           hintText: 'Complain Description',
                  //                           hintStyle: TextStyle(
                  //                               color: Colors.grey,
                  //                               fontWeight: FontWeight.normal),
                  //                           filled: true,
                  //                           fillColor:
                  //                               Colors.white.withOpacity(0.3),
                  //                         ),
                  //                         style: TextStyle(
                  //                           color: Colors.black,
                  //                           fontWeight: FontWeight.normal,
                  //                         ),
                  //                         textAlign: TextAlign.center,
                  //                         controller: descController,
                  //                       ),
                  //                       SizedBox(
                  //                         height: 20,
                  //                       ),
                  //                       _showComplaintProgress
                  //                           ? CircularProgressIndicator()
                  //                           : MaterialButton(
                  //                               onPressed: () {
                  //                                 complainDescription =
                  //                                     descController.text
                  //                                         .trim();
                  //                                 if (listOfStatus.contains(
                  //                                         complainStatus) &&
                  //                                     complainDescription
                  //                                         .isNotEmpty) {
                  //                                   setState(() {
                  //                                     _showComplaintProgress =
                  //                                         true;
                  //                                   });
                  //
                  //                                   HTTPService()
                  //                                       .sendComplain(
                  //                                           authToken,
                  //                                           complainStatus,
                  //                                           complainDescription)
                  //                                       .then((response) {
                  //                                     setState(() {
                  //                                       _showComplaintProgress =
                  //                                           false;
                  //                                       _showComplainUI = false;
                  //                                     });
                  //
                  //                                     if (response.statusCode ==
                  //                                         200) {
                  //                                       BasicResponseModel
                  //                                           responseModel =
                  //                                           BasicResponseModel
                  //                                               .fromJson(json
                  //                                                   .decode(response
                  //                                                       .body));
                  //                                       if (responseModel
                  //                                           .status) {
                  //                                         showSuccessDialog(
                  //                                             context,
                  //                                             responseModel
                  //                                                 .message);
                  //                                       } else {
                  //                                         showErrorDialog(
                  //                                             responseModel
                  //                                                 .message);
                  //                                       }
                  //                                     } else {
                  //                                       showErrorDialog(
                  //                                           'Error occurred ${response.statusCode}');
                  //                                     }
                  //                                   });
                  //                                 }
                  //                               },
                  //                               color: Color(0xff133374),
                  //                               shape: RoundedRectangleBorder(
                  //                                   borderRadius:
                  //                                       BorderRadius.circular(
                  //                                           10)),
                  //                               child: Text(
                  //                                 'Submit',
                  //                                 style: TextStyle(
                  //                                     color: Colors.white,
                  //                                     fontSize: 16,
                  //                                     fontWeight:
                  //                                         FontWeight.normal),
                  //                               ),
                  //                             ),
                  //                     ],
                  //                   ),
                  //                 )
                  //               : Container(),
                  //         ],
                  //       ),
                  //     ),
                  //     elevation: 8,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        )),
        onWillPop: onBackPressed);
  }

  Future<bool> onBackPressed() async {
    Navigator.of(context).pop();
    return true;
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
