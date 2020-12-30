import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vimopay_application/customs/constants.dart';
import 'package:vimopay_application/customs/custom_dialog.dart';
import 'package:vimopay_application/customs/slide_in_transition.dart';
import 'package:vimopay_application/network/http_service.dart';
import 'package:vimopay_application/network/models/get_wallet_response_data.dart';
import 'package:vimopay_application/network/models/get_wallet_response_model.dart';
import 'package:vimopay_application/ui/ProfileScreen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _headerController;

  String authToken;
  String walletBalance = "";
  String mAtmBalance = "";
  String aepsBalance = "";

  List<String> listOfWalletBalance = List();
  List<String> listOfWalletNames = List();

  List<String> bankingImages = [
    "images/ic_aadhar_atm.png",
    "images/ic_mini_atm.png",
    "images/ic_money.png",
    "images/ic_aadhar_pay.png",
    "images/ic_new_account.png",
    "images/ic_bank.png",
  ];

  List<String> bankingServiceTitles = [
    'AADHAR ATM',
    'MINI ATM',
    'MONEY',
    'AADHAR PAY',
    'NEW ACCOUNT',
    'UPI MONEY'
  ];

  List<String> billsUtilitiesImages = [
    "images/ic_prepaid.png",
    "images/ic_dth.png",
    "images/ic_electric.png",
    "images/ic_broadband.png",
    "images/ic_postpaid.png",
    "images/ic_fastag.png",
  ];

  List<String> billsUtilitiesTitles = [
    'Prepaid',
    'DTH',
    'Electric',
    'Broadband',
    'Postpaid',
    'Fastag'
  ];

  List<String> insuranceImages = [
    "images/ic_two_wheeler.png",
    "images/ic_four_wheeler.png",
    "images/ic_term_plan.png",
    "images/ic_health.png",
    "images/ic_life_insurance.png",
    "images/ic_child_policy.png",
  ];

  List<String> insuranceTitles = [
    'Two Wheeler',
    'Four Wheeler',
    'Term Plan',
    'Health',
    'Life Policy',
    'Child Policy'
  ];

  @override
  void initState() {
    _headerController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );
    _headerController.forward();

    getUserDetails();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _headerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Icon(
            Icons.menu_rounded,
          ),
          title: Image.asset(
            'images/ic_logo.png',
          ),
          centerTitle: true,
          actions: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Icon(Icons.notification_important_rounded),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
              child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xff7c94b6),
                  image: new DecorationImage(
                    image: AssetImage(
                      'images/background_png.png',
                    ),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.2), BlendMode.dstATop),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                children: [
                                  FadeTransition(
                                    opacity: _headerController,
                                    child: Container(
                                      width: 200,
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                                      child: Text(
                                        'Good Morning',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  FadeTransition(
                                    opacity: _headerController,
                                    child: Container(
                                      width: 200,
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                      child: Text(
                                        'Sujoy Dutta',
                                        style: TextStyle(
                                          color: Colors.blue[900],
                                          fontSize: 26,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        FadeTransition(
                          opacity: _headerController,
                          child: Container(
                              padding: EdgeInsets.all(5),
                              child: InkWell(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.asset(
                                    'images/default_user.png',
                                    width: 60.0,
                                    height: 60.0,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).push(
                                      SlideInTransition(page: ProfileScreen()));
                                },
                              )),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // Container(
                  //   padding: EdgeInsets.fromLTRB(10, 0, 5, 5),
                  //   child: Text(
                  //     'My Wallets',
                  //     style: TextStyle(
                  //         color: Colors.black87,
                  //         fontSize: 18,
                  //         fontWeight: FontWeight.bold),
                  //   ),
                  // ),
                  // Container(
                  //   margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //     children: [
                  //       Material(
                  //         borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  //         color: Color(0xff6600CC),
                  //         child: Container(
                  //           width: 100,
                  //           padding: EdgeInsets.fromLTRB(5, 15, 5, 5),
                  //           decoration: BoxDecoration(
                  //             borderRadius:
                  //                 BorderRadius.all(Radius.circular(10.0)),
                  //             gradient: LinearGradient(
                  //               colors: [Color(0xff407CD1), Color(0xff6A73C5)],
                  //               begin: Alignment.topLeft,
                  //               end: Alignment.bottomRight,
                  //             ),
                  //           ),
                  //           child: (listOfWalletBalance != null &&
                  //                   listOfWalletBalance.isNotEmpty)
                  //               ? Column(
                  //                   mainAxisAlignment: MainAxisAlignment.center,
                  //                   crossAxisAlignment: CrossAxisAlignment.center,
                  //                   children: [
                  //                     SizedBox(
                  //                       height: 10,
                  //                     ),
                  //                     Container(
                  //                       child: Text(
                  //                         '\u{20B9} ${listOfWalletBalance[0]}',
                  //                         style: TextStyle(
                  //                           fontSize: 15,
                  //                           color: Colors.white,
                  //                         ),
                  //                         maxLines: 2,
                  //                         overflow: TextOverflow.clip,
                  //                       ),
                  //                       alignment: Alignment.center,
                  //                     ),
                  //                     SizedBox(
                  //                       height: 20,
                  //                     ),
                  //                     Row(
                  //                       mainAxisAlignment:
                  //                           MainAxisAlignment.spaceEvenly,
                  //                       children: [
                  //                         Icon(
                  //                           Icons.account_balance_wallet_rounded,
                  //                           color: Colors.white,
                  //                           size: 20,
                  //                         ),
                  //                         Container(
                  //                           alignment: Alignment.center,
                  //                           child: Text(
                  //                             '${listOfWalletNames[0]}',
                  //                             style: TextStyle(
                  //                               fontSize: 15,
                  //                               color: Colors.white,
                  //                             ),
                  //                           ),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   ],
                  //                 )
                  //               : Container(
                  //                   height: 30,
                  //                   width: 30,
                  //                   alignment: Alignment.center,
                  //                   child: CircularProgressIndicator(
                  //                       valueColor:
                  //                           new AlwaysStoppedAnimation<Color>(
                  //                               Colors.white)),
                  //                 ),
                  //         ),
                  //         elevation: 10,
                  //         shadowColor: Color(0xaa6600cc),
                  //       ),
                  //       Material(
                  //         borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  //         color: Color(0xff6600CC),
                  //         child: Container(
                  //           width: 100,
                  //           padding: EdgeInsets.fromLTRB(5, 15, 5, 5),
                  //           decoration: BoxDecoration(
                  //             borderRadius:
                  //                 BorderRadius.all(Radius.circular(10.0)),
                  //             gradient: LinearGradient(
                  //               colors: [Color(0xff407CD1), Color(0xff6A73C5)],
                  //               begin: Alignment.topLeft,
                  //               end: Alignment.bottomRight,
                  //             ),
                  //           ),
                  //           child: (listOfWalletBalance != null &&
                  //                   listOfWalletBalance.isNotEmpty)
                  //               ? Column(
                  //                   mainAxisAlignment: MainAxisAlignment.center,
                  //                   crossAxisAlignment: CrossAxisAlignment.center,
                  //                   children: [
                  //                     SizedBox(
                  //                       height: 10,
                  //                     ),
                  //                     Container(
                  //                       child: Text(
                  //                         '\u{20B9} ${listOfWalletBalance[1]}',
                  //                         style: TextStyle(
                  //                           fontSize: 15,
                  //                           color: Colors.white,
                  //                         ),
                  //                         maxLines: 2,
                  //                         overflow: TextOverflow.clip,
                  //                       ),
                  //                       alignment: Alignment.center,
                  //                     ),
                  //                     SizedBox(
                  //                       height: 15,
                  //                     ),
                  //                     Row(
                  //                       mainAxisAlignment:
                  //                           MainAxisAlignment.spaceEvenly,
                  //                       children: [
                  //                         Icon(
                  //                           Icons.account_balance_wallet_rounded,
                  //                           color: Colors.white,
                  //                           size: 20,
                  //                         ),
                  //                         Container(
                  //                           alignment: Alignment.center,
                  //                           child: Text(
                  //                             '${listOfWalletNames[1]}',
                  //                             style: TextStyle(
                  //                               fontSize: 15,
                  //                               color: Colors.white,
                  //                             ),
                  //                           ),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   ],
                  //                 )
                  //               : Container(
                  //                   height: 30,
                  //                   width: 30,
                  //                   alignment: Alignment.center,
                  //                   child: CircularProgressIndicator(
                  //                       valueColor:
                  //                           new AlwaysStoppedAnimation<Color>(
                  //                               Colors.white)),
                  //                 ),
                  //         ),
                  //         elevation: 10,
                  //         shadowColor: Color(0xaa6600cc),
                  //       ),
                  //       Material(
                  //         borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  //         color: Color(0xff6600CC),
                  //         child: Container(
                  //           width: 100,
                  //           padding: EdgeInsets.fromLTRB(5, 15, 5, 5),
                  //           decoration: BoxDecoration(
                  //             borderRadius:
                  //                 BorderRadius.all(Radius.circular(10.0)),
                  //             gradient: LinearGradient(
                  //               colors: [Color(0xff407CD1), Color(0xff6A73C5)],
                  //               begin: Alignment.topLeft,
                  //               end: Alignment.bottomRight,
                  //             ),
                  //           ),
                  //           child: (listOfWalletBalance != null &&
                  //                   listOfWalletBalance.isNotEmpty)
                  //               ? Column(
                  //                   mainAxisAlignment: MainAxisAlignment.center,
                  //                   crossAxisAlignment: CrossAxisAlignment.center,
                  //                   children: [
                  //                     SizedBox(
                  //                       height: 10,
                  //                     ),
                  //                     Container(
                  //                       child: Text(
                  //                         '\u{20B9} ${listOfWalletBalance[2]}',
                  //                         style: TextStyle(
                  //                           fontSize: 15,
                  //                           color: Colors.white,
                  //                         ),
                  //                         maxLines: 2,
                  //                         overflow: TextOverflow.clip,
                  //                       ),
                  //                       alignment: Alignment.center,
                  //                     ),
                  //                     SizedBox(
                  //                       height: 15,
                  //                     ),
                  //                     Row(
                  //                       mainAxisAlignment:
                  //                           MainAxisAlignment.spaceEvenly,
                  //                       children: [
                  //                         Icon(
                  //                           Icons.account_balance_wallet_rounded,
                  //                           color: Colors.white,
                  //                           size: 20,
                  //                         ),
                  //                         Container(
                  //                           alignment: Alignment.center,
                  //                           child: Text(
                  //                             '${listOfWalletNames[2]}',
                  //                             style: TextStyle(
                  //                               fontSize: 15,
                  //                               color: Colors.white,
                  //                             ),
                  //                           ),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   ],
                  //                 )
                  //               : Container(
                  //                   height: 30,
                  //                   width: 30,
                  //                   alignment: Alignment.center,
                  //                   child: CircularProgressIndicator(
                  //                       valueColor:
                  //                           new AlwaysStoppedAnimation<Color>(
                  //                               Colors.white)),
                  //                 ),
                  //         ),
                  //         elevation: 10,
                  //         shadowColor: Color(0xaa6600cc),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Our Services',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      'Banking',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    height: 250,
                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: GridView.builder(
                      itemCount: bankingServiceTitles.length,
                      physics: new NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemBuilder: (BuildContext buildContext, int index) {
                        return Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Material(
                              elevation: 2,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              shadowColor: Colors.grey[800],
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    bankingImages[index],
                                    height: 50,
                                    width: 50,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    bankingServiceTitles[index],
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 12),
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ));
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      'Bills & Utility',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    height: 250,
                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: GridView.builder(
                      itemCount: billsUtilitiesTitles.length,
                      physics: new NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemBuilder: (BuildContext buildContext, int index) {
                        return Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Material(
                              elevation: 2,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              shadowColor: Colors.grey[800],
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    billsUtilitiesImages[index],
                                    height: 50,
                                    width: 50,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    billsUtilitiesTitles[index],
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 12),
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ));
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      'Insurance',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    height: 250,
                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: GridView.builder(
                      itemCount: billsUtilitiesTitles.length,
                      physics: new NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemBuilder: (BuildContext buildContext, int index) {
                        return Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Material(
                              elevation: 2,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              shadowColor: Colors.grey[800],
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    insuranceImages[index],
                                    height: 50,
                                    width: 50,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    insuranceTitles[index],
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 12),
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ));
                      },
                    ),
                  ),
                ],
              ),
            ],
          )),
        ));
  }

  void getUserDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    authToken = sharedPreferences.getString(Constants.SHARED_PREF_TOKEN);

    HTTPService().getWallets(authToken).then((response) {
      if (response.statusCode == 200) {
        GetWalletsResponseModel walletsResponseModel =
            GetWalletsResponseModel.fromJson(json.decode(response.body));

        if (walletsResponseModel.status) {
          List<String> walletBalanceList = List();
          List<String> walletNameList = List();

          walletBalanceList.add(walletsResponseModel.data.wBalance);
          walletNameList.add('Main');

          walletBalanceList.add(walletsResponseModel.data.aBalance);
          walletNameList.add('AEPS');

          walletBalanceList.add(walletsResponseModel.data.mBalance);
          walletNameList.add('MATM');

          setState(() {
            walletBalance = walletsResponseModel.data.wBalance;
            aepsBalance = walletsResponseModel.data.aBalance;
            mAtmBalance = walletsResponseModel.data.mBalance;

            listOfWalletBalance = walletBalanceList;
            listOfWalletNames = walletNameList;
          });

          GetWalletResponseData getWalletResponseData =
              walletsResponseModel.data;
          saveWalletBalance(getWalletResponseData);
        } else {
          showErrorDialog(walletsResponseModel.message);
        }
      } else {
        showErrorDialog(
            'Server error occurred while fetching wallet data. Error code ${response.statusCode}');
      }
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

  void saveWalletBalance(GetWalletResponseData getWalletResponseData) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(Constants.SHARED_PREF_MAIN_WALLET_BALANCE,
        getWalletResponseData.wBalance);
    sharedPreferences.setString(
        Constants.SHARED_PREF_MATM_BALANCE, getWalletResponseData.mBalance);
    sharedPreferences.setString(
        Constants.SHARED_PREF_AEPS_BALANCE, getWalletResponseData.aBalance);
  }
}
