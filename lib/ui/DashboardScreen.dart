import 'dart:convert';
import 'dart:io';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vimopay_application/customs/constants.dart';
import 'package:vimopay_application/customs/custom_dialog.dart';
import 'package:vimopay_application/customs/recharge_types.dart';
import 'package:vimopay_application/customs/scale_route_transition.dart';
import 'package:vimopay_application/network/http_service.dart';
import 'package:vimopay_application/network/models/get_banner_response_model.dart';
import 'package:vimopay_application/network/models/get_wallet_response_data.dart';
import 'package:vimopay_application/network/models/get_wallet_response_model.dart';
import 'package:vimopay_application/ui/MoneyTransferScreen.dart';
import 'package:vimopay_application/ui/ProfileScreenNew.dart';
import 'package:vimopay_application/ui/RechargeScreen.dart';
import 'package:vimopay_application/ui/WalletScreen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _headerController;

  String authToken;
  String username = '';
  String walletBalance = "";
  String mAtmBalance = "";
  String aepsBalance = "";
  File imageFile;

  List<String> listOfWalletBalance = List();
  List<String> listOfWalletNames = List();
  List<String> bannerUrl = List();
  List<String> redirectUrl = List();

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
    RechargeTypes.PREPAID,
    RechargeTypes.DTH,
    RechargeTypes.Electric,
    RechargeTypes.BROADBAND,
    RechargeTypes.POSTPAID,
    RechargeTypes.FASTAG
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

  List<String> travelImages = [
    "images/ic_railbooking.png",
    "images/ic_flight.png",
    "images/ic_busbooking.png",
    "images/ic_hotel.png",
    "images/ic_movie.png",
    "images/ic_metro.png",
  ];

  List<String> travelTitles = [
    'Rail Booking',
    'Flight',
    'Bus Booking',
    'Hotel',
    'Movie Ticket',
    'Metro Ticket'
  ];

  List<String> taxesImages = [
    "images/ic_new_gst.png",
    "images/ic_gst_return.png",
    "images/ic_it_return.png",
    "images/ic_trade_mark.png",
    "images/ic_food_license.png",
    "images/ic_company.png",
  ];

  List<String> taxesTitles = [
    'Taxes',
    'GST Return',
    'IT Return',
    'Trade Mark',
    'Food License',
    'Company'
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
    return SafeArea(
      child: Scaffold(
          backgroundColor: Color(0xfff1fafc),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: 0,
            backgroundColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.blue[900],
            selectedLabelStyle: TextStyle(color: Colors.blue[900]),
            unselectedLabelStyle: TextStyle(color: Colors.white),
            unselectedItemColor: Colors.white,
            onTap: (index) {
              switch (index) {
                case 0:
                  break;
                case 1:
                  Navigator.of(context).push(ScaleRoute(page: WalletScreen()));
                  break;
                case 2:
                  break;
                case 3:
                  break;
              }
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  size: 24,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet_rounded),
                label: 'Wallet',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_circle_rounded,
                  size: 24,
                  color: Colors.white,
                ),
                label: 'Profile',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.menu_open_outlined,
                  color: Colors.white,
                  size: 24,
                ),
                label: 'More',
              ),
            ],
          ),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: 80,
                      child: InkWell(
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              'images/default_user.png',
                              height: 40,
                              width: 44,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                              ScaleRoute(page: ProfileScreenNew()));
                        },
                      )),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: VerticalDivider(
                      width: 1,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    child: Center(
                      child: Image.asset(
                        'images/logo_text_1.png',
                        height: 40,
                        width: 200,
                      ),
                    ),
                    alignment: Alignment.center,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.support_agent_rounded,
                                size: 26,
                                color: Colors.white,
                              ),
                              onPressed: () {}),
                          Icon(
                            Icons.menu_rounded,
                            size: 26,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  )
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
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 135,
                        child: bannerUrl != null && bannerUrl.isNotEmpty
                            ? Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    border: Border.all(color: Colors.white)),
                                child: Carousel(
                                    dotSize: 5.0,
                                    dotSpacing: 20.0,
                                    dotIncreasedColor: Colors.blue,
                                    dotColor: Colors.white,
                                    indicatorBgPadding: 10.0,
                                    dotBgColor: Colors.transparent,
                                    borderRadius: true,
                                    noRadiusForIndicator: true,
                                    images: bannerUrl
                                        .map((url) => InkWell(
                                              child: ClipRRect(
                                                child: Image.network(
                                                  url,
                                                  fit: BoxFit.fill,
                                                ),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                              ),
                                              onTap: () {},
                                            ))
                                        .toList()),
                              )
                            : Container(
                                width: 180,
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(),
                              ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(5, 5, 5, 10),
                        child: Material(
                          elevation: 10,
                          color: Colors.transparent,
                          shadowColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            height: 120,
                            padding: EdgeInsets.fromLTRB(5, 5, 2, 0),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.transparent,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Banking',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  height: 70,
                                  margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        width: 100,
                                        child: InkWell(
                                          child: Stack(
                                            children: [
                                              Align(
                                                alignment: Alignment.topCenter,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: Image.asset(
                                                    bankingImages[index],
                                                    height: 50,
                                                    width: 50,
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Text(
                                                  bankingServiceTitles[index],
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          onTap: () {
                                            if (index == 2) {
                                              Navigator.of(context).push(
                                                  ScaleRoute(
                                                      page:
                                                          MoneyTransferScreen()));
                                            }
                                          },
                                        ),
                                      );
                                    },
                                    itemCount: bankingImages.length,
                                    shrinkWrap: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
                        child: Material(
                          elevation: 10,
                          color: Colors.transparent,
                          shadowColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            height: 120,
                            padding: EdgeInsets.fromLTRB(5, 5, 2, 0),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.transparent,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Bills & Utility',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                Container(
                                  height: 70,
                                  margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return Container(
                                          width: 100,
                                          child: InkWell(
                                            child: Stack(
                                              children: [
                                                Align(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    child: Image.asset(
                                                      billsUtilitiesImages[
                                                          index],
                                                      height: 50,
                                                      width: 50,
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: Text(
                                                    billsUtilitiesTitles[index],
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  ScaleRoute(
                                                      page: RechargeScreen(
                                                          rechargeType:
                                                              billsUtilitiesTitles[
                                                                  index])));
                                            },
                                          ));
                                    },
                                    itemCount: bankingImages.length,
                                    shrinkWrap: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
                        child: Material(
                          elevation: 10,
                          color: Colors.transparent,
                          shadowColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            height: 120,
                            padding: EdgeInsets.fromLTRB(5, 5, 2, 0),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.transparent,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Insurance',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  height: 70,
                                  margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        width: 100,
                                        child: Stack(
                                          children: [
                                            Align(
                                              alignment: Alignment.topCenter,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: Image.asset(
                                                  insuranceImages[index],
                                                  height: 50,
                                                  width: 50,
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Text(
                                                insuranceTitles[index],
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                    itemCount: bankingImages.length,
                                    shrinkWrap: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
                        child: Material(
                          elevation: 10,
                          color: Colors.transparent,
                          shadowColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            height: 120,
                            padding: EdgeInsets.fromLTRB(5, 5, 2, 0),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.transparent,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Travel & Ticketing',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  height: 70,
                                  margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        width: 100,
                                        child: Stack(
                                          children: [
                                            Align(
                                              alignment: Alignment.topCenter,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: Image.asset(
                                                  travelImages[index],
                                                  height: 50,
                                                  width: 50,
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Text(
                                                travelTitles[index],
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                    itemCount: bankingImages.length,
                                    shrinkWrap: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
                        child: Material(
                          elevation: 10,
                          color: Colors.transparent,
                          shadowColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            height: 120,
                            padding: EdgeInsets.fromLTRB(5, 5, 2, 0),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.transparent,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Taxes',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  height: 70,
                                  margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        width: 100,
                                        child: Stack(
                                          children: [
                                            Align(
                                              alignment: Alignment.topCenter,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: Image.asset(
                                                  taxesImages[index],
                                                  height: 50,
                                                  width: 50,
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Text(
                                                taxesTitles[index],
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                    itemCount: bankingImages.length,
                                    shrinkWrap: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  void getUserDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    authToken = sharedPreferences.getString(Constants.SHARED_PREF_TOKEN);
    setState(() {
      username = sharedPreferences.getString(Constants.SHARED_PREF_NAME);
    });

    String imagePath =
        sharedPreferences.getString(Constants.SHARED_PREF_USER_DP_PATH);
    if (imagePath != null) {
      setState(() {
        imageFile = File(imagePath);
      });
    }

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
          SharedPreferences.getInstance().then((sharedPrefs) {
            sharedPrefs.setString(
                Constants.SHARED_PREF_MAIN_WALLET_BALANCE, '0');
            sharedPrefs.setString(Constants.SHARED_PREF_AEPS_BALANCE, '0');
            sharedPrefs.setString(Constants.SHARED_PREF_MATM_BALANCE, '0');
          });
        }
      } else {
        showErrorDialog(
            'Server error occurred while fetching wallet data. Error code ${response.statusCode}');
        SharedPreferences.getInstance().then((sharedPrefs) {
          sharedPrefs.setString(Constants.SHARED_PREF_MAIN_WALLET_BALANCE, '0');
          sharedPrefs.setString(Constants.SHARED_PREF_AEPS_BALANCE, '0');
          sharedPrefs.setString(Constants.SHARED_PREF_MATM_BALANCE, '0');
        });
      }
    });

    HTTPService().getBanner(authToken).then((response) {
      if (response.statusCode == 200) {
        BannerResponseModel bannerResponseModel =
            BannerResponseModel.fromJson(json.decode(response.body));

        List<String> urlList = List();
        List<String> redirectUrlList = List();

        for (int i = 0; i < bannerResponseModel.data.length; i++) {
          urlList.add(bannerResponseModel.data[i].photo);
          redirectUrlList.add(bannerResponseModel.data[i].description);
        }

        setState(() {
          bannerUrl = urlList;
          redirectUrl = redirectUrlList;
        });
      } else {
        print('Could not fetch image');
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
