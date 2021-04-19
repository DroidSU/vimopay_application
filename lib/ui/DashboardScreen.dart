import 'dart:convert';
import 'dart:io';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marquee/marquee.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vimopay_application/customs/constants.dart';
import 'package:vimopay_application/customs/custom_dialog.dart';
import 'package:vimopay_application/customs/recharge_types.dart';
import 'package:vimopay_application/customs/scale_route_transition.dart';
import 'package:vimopay_application/network/http_service.dart';
import 'package:vimopay_application/network/models/all_commissions_response_model.dart';
import 'package:vimopay_application/network/models/get_banner_response_model.dart';
import 'package:vimopay_application/network/models/get_wallet_response_data.dart';
import 'package:vimopay_application/network/models/get_wallet_response_model.dart';
import 'package:vimopay_application/network/models/notice_response_model.dart';
import 'package:vimopay_application/ui/CMSServiceScreen.dart';
import 'package:vimopay_application/ui/MoneyTransferScreen.dart';
import 'package:vimopay_application/ui/ProfileScreenNew.dart';
import 'package:vimopay_application/ui/ReportScreenUI.dart';
import 'package:vimopay_application/ui/SupportScreen.dart';
import 'package:vimopay_application/ui/WalletScreen.dart';
import 'package:vimopay_application/ui/bbps_screens/BBPSGasRechargeScreen.dart';
import 'package:vimopay_application/ui/bbps_screens/BBPS_BroadbandRechargeScreen.dart';
import 'package:vimopay_application/ui/bbps_screens/BBPS_DTHRechargeScreen.dart';
import 'package:vimopay_application/ui/bbps_screens/BBPS_ElectricityRechargeScreen.dart';
import 'package:vimopay_application/ui/bbps_screens/BBPS_FastagRechargeScreen.dart';
import 'package:vimopay_application/ui/bbps_screens/BBPS_PostpaidRechargeScreen.dart';
import 'package:vimopay_application/ui/bbps_screens/BBPS_PrepaidRechargeScreen.dart';

import 'LoginScreen.dart';
import 'RechargeScreen.dart';
import 'bbps_screens/BBPS_WaterRechargeScreen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _headerController;

  String? authToken;
  String? username = '';
  String? userId = "";
  String? noticeString = "";
  String? youEarned = "";
  String? transactionCount = "";
  String? totalTxnAmount = "";
  File? imageFile;

  bool _showWallet = false;
  String? mainWalletBalance = "";
  String? atmWalletBalance = "";

  List<String?> bannerUrl = [];
  List<String?> redirectUrl = [];
  bool _showCommissions = false;

  List<String> bankingImages = [
    "images/ic_aadhar_atm.png",
    "images/ic_mini_atm.png",
    "images/ic_money_transfer.png",
    "images/ic_aadhar_pay.png",
    "images/ic_new_account.png",
    "images/ic_upi_money.png",
  ];

  List<String> bankingServiceTitles = [
    'Aadhar ATM',
    'Mini ATM',
    'Money Transfer',
    'Aadhar Pay',
    'New Account',
    'BHIM UPI'
  ];

  List<String> bbpsServiceTitles = [
    'Prepaid',
    'DTH',
    'Water',
    'Gas',
    'Insurance',
    'Loan',
  ];

  List<String> bbpsServiceImages = [
    "images/ic_prepaid.png",
    "images/ic_dth.png",
    "images/ic_electric.png",
    "images/ic_broadband.png",
    "images/ic_postpaid.png",
    "images/ic_fastag.png",
  ];

  List<String> rechargesBillsImages = [
    "images/ic_prepaid.png",
    "images/ic_dth.png",
    "images/ic_electric.png",
    "images/ic_broadband.png",
    "images/ic_postpaid.png",
    "images/ic_fastag.png",
  ];

  List<String> rechargesBillsTitles = [
    RechargeTypes.PREPAID,
    RechargeTypes.DTH,
    RechargeTypes.Electric,
    RechargeTypes.BROADBAND,
    RechargeTypes.POSTPAID,
    RechargeTypes.FASTAG
  ];

  List<String> insuranceImages = [
    "images/ic_two_wheeler_insurance.png",
    "images/ic_four_wheeler.png",
    "images/ic_term_plan_insurance.png",
    "images/ic_health_insurance.png",
    "images/ic_life_insurance.png",
    "images/ic_child_insurance.png",
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
    "images/ic_rail_booking.png",
    "images/ic_flight_booking.png",
    "images/ic_bus_booking.png",
    "images/ic_hotel_booking.png",
    "images/ic_movie_booking.png",
    "images/ic_metro_booking.png",
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
    "images/ic_taxes.png",
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

  List<String> otherServicesImage = [
    'images/ic_cms_service.png',
    'images/ic_pan_card.png',
    'images/ic_buy_gold.png',
    'images/ic_mutual_fund.png',
    'images/ic_apply_loan.png',
    'images/ic_shopping.png',
  ];

  List<String> otherServicesTitles = [
    'CMS Service',
    'PAN Card',
    'Buy Gold',
    'Mutual Fund',
    'Apply Loan',
    'Shopping',
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
            backgroundColor: Color(0xff133374),
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.yellowAccent,
            selectedLabelStyle: TextStyle(color: Colors.yellowAccent),
            unselectedLabelStyle: TextStyle(color: Colors.white),
            unselectedItemColor: Colors.white,
            onTap: (index) {
              switch (index) {
                case 0:
                  break;
                case 1:
                  Navigator.of(context).pushReplacement(ScaleRoute(
                      page: WalletScreen(
                    comingFrom: "Dashboard",
                    selectedWallet: 0,
                  )));
                  break;
                case 2:
                  Navigator.of(context)
                      .push(ScaleRoute(page: ReportScreenUI()));
                  break;
                case 3:
                  Navigator.of(context)
                      .pushReplacement(ScaleRoute(page: ProfileScreenNew()));
                  break;
                case 4:
                  Navigator.of(context).push(ScaleRoute(page: SupportScreen()));
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
                icon: Icon(
                  Icons.account_balance_wallet_rounded,
                  size: 24,
                ),
                label: 'Wallet',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'images/ic_report.png',
                  height: 20,
                  width: 20,
                ),
                label: 'Report',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.supervisor_account_rounded,
                  color: Colors.white,
                  size: 24,
                ),
                label: 'Profile',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.support_agent_outlined,
                  color: Colors.white,
                  size: 24,
                ),
                label: 'Support',
              ),
            ],
          ),
          appBar: PreferredSize(
            preferredSize: Size(double.infinity, 100),
            child: Container(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Image.asset(
                      'images/ic_logo_with_text_2.png',
                      height: 50,
                      width: 200,
                    ),
                    alignment: Alignment.center,
                  ),
                  Container(
                      width: 60,
                      alignment: Alignment.center,
                      child: InkWell(
                        child: Icon(
                          Icons.logout,
                          // color: Color(0xff133374),
                          color: Colors.black,
                          size: 24,
                        ),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (buildContext) {
                                return CustomAlertDialog(
                                  content: Container(
                                    height: 100,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Sure you want to logout?',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          children: [
                                            MaterialButton(
                                              onPressed: () {
                                                logoutUser();
                                              },
                                              color: Colors.green,
                                              child: Text(
                                                'Yes',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14),
                                              ),
                                              elevation: 10,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            MaterialButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              color: Colors.red,
                                              child: Text(
                                                'No',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14),
                                              ),
                                              elevation: 10,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ],
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                      )),
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
                      noticeString == ""
                          ? Container()
                          : Container(
                              margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              width: MediaQuery.of(context).size.width,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.all(5),
                              child: Center(
                                child: Marquee(
                                  text: noticeString!,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  scrollAxis: Axis.horizontal,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  blankSpace: 20.0,
                                  velocity: 20.0,
                                  pauseAfterRound: Duration(seconds: 1),
                                  showFadingOnlyWhenScrolling: true,
                                  fadingEdgeStartFraction: 0.1,
                                  fadingEdgeEndFraction: 0.1,
                                  startPadding: 10.0,
                                  accelerationDuration: Duration(seconds: 1),
                                  accelerationCurve: Curves.linear,
                                  decelerationDuration:
                                      Duration(milliseconds: 500),
                                  decelerationCurve: Curves.easeOut,
                                ),
                              ),
                            ),
                      SizedBox(
                        height: 2,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 100,
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
                                                  url!,
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
                        color: Colors.transparent,
                        height: 65,
                        margin: EdgeInsets.fromLTRB(5, 10, 5, 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              child: Material(
                                child: SizedBox(
                                  width: 120,
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Atm Wallet',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          '\u20B9$atmWalletBalance',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).push(ScaleRoute(
                                    page: WalletScreen(
                                  comingFrom: 'Dashboard',
                                  selectedWallet: 0,
                                )));
                              },
                            ),
                            VerticalDivider(
                              color: Colors.black,
                              thickness: 0.3,
                            ),
                            InkWell(
                              child: Material(
                                child: SizedBox(
                                  width: 120,
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Main Wallet',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          '\u20B9$mainWalletBalance',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).push(ScaleRoute(
                                    page: WalletScreen(
                                  comingFrom: 'Dashboard',
                                  selectedWallet: 1,
                                )));
                              },
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Material(
                          child: Column(
                            children: [
                              InkWell(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        child: Text(
                                          'Commissions Earned',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 10, 20, 0),
                                      child: Icon(
                                        !_showCommissions
                                            ? Icons.navigate_next_rounded
                                            : Icons.keyboard_arrow_down,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.center,
                                ),
                                onTap: () {
                                  setState(() {
                                    _showCommissions = !_showCommissions;
                                  });
                                },
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              _showCommissions
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Column(
                                            children: [
                                              Text(
                                                'You Earned',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              SizedBox(
                                                height: 2,
                                              ),
                                              Text(
                                                youEarned!,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Column(
                                            children: [
                                              Text(
                                                'Total Transactions',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              SizedBox(
                                                height: 2,
                                              ),
                                              Text(
                                                transactionCount!,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Column(
                                            children: [
                                              Text(
                                                'Total Txn Amt',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              SizedBox(
                                                height: 2,
                                              ),
                                              Text(
                                                totalTxnAmount!,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  : Container()
                            ],
                          ),
                          elevation: 8,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
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
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          width: 100,
                                          child: InkWell(
                                            child: Column(
                                              children: [
                                                Material(
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    child: Image.asset(
                                                      bankingImages[index],
                                                      height: 50,
                                                      width: 50,
                                                    ),
                                                  ),
                                                  elevation: 10,
                                                  shape: CircleBorder(),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Material(
                                                  child: Text(
                                                    bankingServiceTitles[index],
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  elevation: 10,
                                                  color: Colors.transparent,
                                                  shadowColor:
                                                      Colors.transparent,
                                                ),
                                              ],
                                            ),
                                            onTap: () {
                                              if (index == 0) {
                                                startAEPSTransaction();
                                              } else if (index == 1) {
                                                startMiniATM();
                                              } else if (index == 2) {
                                                Navigator.of(context).push(
                                                    ScaleRoute(
                                                        page:
                                                            MoneyTransferScreen()));
                                              } else {
                                                showComingSoon("Coming soon!");
                                              }
                                            },
                                          ),
                                        );
                                      },
                                      itemCount: bankingImages.length,
                                      shrinkWrap: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
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
                                  'Recharges & Bill Payments',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          width: 100,
                                          child: InkWell(
                                            child: Column(
                                              children: [
                                                Material(
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    child: Image.asset(
                                                      rechargesBillsImages[
                                                          index],
                                                      height: 50,
                                                      width: 50,
                                                    ),
                                                  ),
                                                  elevation: 10,
                                                  shape: CircleBorder(),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Material(
                                                  child: Text(
                                                    rechargesBillsTitles[index],
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  elevation: 10,
                                                  color: Colors.transparent,
                                                  shadowColor:
                                                      Colors.transparent,
                                                ),
                                              ],
                                            ),
                                            onTap: () {
                                              if (index == 0) {
                                                Navigator.of(context)
                                                    .push(ScaleRoute(
                                                        page: RechargeScreen(
                                                  rechargeType:
                                                      RechargeTypes.PREPAID,
                                                )));
                                              } else if (index == 1) {
                                                Navigator.of(context)
                                                    .push(ScaleRoute(
                                                        page: RechargeScreen(
                                                  rechargeType:
                                                      RechargeTypes.DTH,
                                                )));
                                              } else if (index == 2) {
                                                Navigator.of(context).push(
                                                    ScaleRoute(
                                                        page:
                                                            BBPSElectricityRechargeScreen()));
                                              } else if (index == 3) {
                                                Navigator.of(context).push(
                                                    ScaleRoute(
                                                        page:
                                                            BBPSBroadbandRechargeScreen()));
                                              } else if (index == 4) {
                                                Navigator.of(context).push(
                                                    ScaleRoute(
                                                        page:
                                                            BBPSPostpaidRechargeScreen()));
                                              } else if (index == 5) {
                                                Navigator.of(context).push(
                                                    ScaleRoute(
                                                        page:
                                                            BBPSFastagRechargeScreen()));
                                              } else {
                                                showComingSoon("Coming soon!");
                                              }
                                            },
                                          ),
                                        );
                                      },
                                      itemCount: rechargesBillsTitles.length,
                                      shrinkWrap: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
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
                                  'BBPS',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          width: 100,
                                          child: InkWell(
                                            child: Column(
                                              children: [
                                                Material(
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    child: Image.asset(
                                                      bbpsServiceImages[index],
                                                      height: 50,
                                                      width: 50,
                                                    ),
                                                  ),
                                                  elevation: 10,
                                                  shape: CircleBorder(),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Material(
                                                  child: Text(
                                                    bbpsServiceTitles[index],
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  elevation: 10,
                                                  color: Colors.transparent,
                                                  shadowColor:
                                                      Colors.transparent,
                                                ),
                                              ],
                                            ),
                                            onTap: () {
                                              if (index == 0) {
                                                Navigator.of(context).push(
                                                    ScaleRoute(
                                                        page:
                                                            BBPSPrepaidRechargeScreen()));
                                              } else if (index == 1) {
                                                Navigator.of(context).push(
                                                    ScaleRoute(
                                                        page:
                                                            BBPSDTHRechargeScreen()));
                                              } else if (index == 2) {
                                                Navigator.of(context).push(
                                                    ScaleRoute(
                                                        page:
                                                            BBPSWaterRechargeScreen()));
                                              } else if (index == 3) {
                                                Navigator.of(context).push(
                                                    ScaleRoute(
                                                        page:
                                                            BBPSGasRechargeScreen()));
                                              } else {
                                                showComingSoon("Coming soon!");
                                              }
                                            },
                                          ),
                                        );
                                      },
                                      itemCount: bankingImages.length,
                                      shrinkWrap: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
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
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return Container(
                                            width: 100,
                                            child: InkWell(
                                              child: Column(
                                                children: [
                                                  Material(
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      child: Image.asset(
                                                        insuranceImages[index],
                                                        height: 50,
                                                        width: 50,
                                                      ),
                                                    ),
                                                    elevation: 10,
                                                    shape: CircleBorder(),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Material(
                                                    child: Text(
                                                      insuranceTitles[index],
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    elevation: 10,
                                                    color: Colors.transparent,
                                                    shadowColor:
                                                        Colors.transparent,
                                                  ),
                                                ],
                                              ),
                                              onTap: () {
                                                showComingSoon(
                                                    "Available only in the desktop version");
                                              },
                                            ));
                                      },
                                      itemCount: insuranceTitles.length,
                                      shrinkWrap: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
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
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return Container(
                                            width: 100,
                                            child: InkWell(
                                              child: Column(
                                                children: [
                                                  Material(
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      child: Image.asset(
                                                        travelImages[index],
                                                        height: 50,
                                                        width: 50,
                                                      ),
                                                    ),
                                                    elevation: 10,
                                                    shape: CircleBorder(),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Material(
                                                    child: Text(
                                                      travelTitles[index],
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    elevation: 10,
                                                    color: Colors.transparent,
                                                    shadowColor:
                                                        Colors.transparent,
                                                  ),
                                                ],
                                              ),
                                              onTap: () {
                                                showComingSoon('Coming soon!');
                                              },
                                            ));
                                      },
                                      itemCount: travelTitles.length,
                                      shrinkWrap: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
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
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return Container(
                                            width: 100,
                                            child: InkWell(
                                              child: Column(
                                                children: [
                                                  Material(
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      child: Image.asset(
                                                        taxesImages[index],
                                                        height: 50,
                                                        width: 50,
                                                      ),
                                                    ),
                                                    elevation: 10,
                                                    shape: CircleBorder(),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Material(
                                                    child: Text(
                                                      taxesTitles[index],
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    elevation: 10,
                                                    color: Colors.transparent,
                                                    shadowColor:
                                                        Colors.transparent,
                                                  ),
                                                ],
                                              ),
                                              onTap: () {
                                                showComingSoon('Coming soon!');
                                              },
                                            ));
                                      },
                                      itemCount: taxesTitles.length,
                                      shrinkWrap: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
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
                                  'Other Services',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          width: 100,
                                          child: InkWell(
                                            child: Column(
                                              children: [
                                                Material(
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    child: Image.asset(
                                                      otherServicesImage[index],
                                                      height: 50,
                                                      width: 50,
                                                    ),
                                                  ),
                                                  elevation: 10,
                                                  shape: CircleBorder(),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Material(
                                                  child: Text(
                                                    otherServicesTitles[index],
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  elevation: 10,
                                                  color: Colors.transparent,
                                                  shadowColor:
                                                      Colors.transparent,
                                                ),
                                              ],
                                            ),
                                            onTap: () {
                                              if (index == 0) {
                                                Navigator.of(context).push(
                                                    ScaleRoute(
                                                        page:
                                                            CMSServiceScreen()));
                                              } else if (index == 1) {
                                                showComingSoon(
                                                    'Available only in the desktop version!');
                                              } else {
                                                showComingSoon('Coming Soon!');
                                              }
                                            },
                                          ),
                                        );
                                      },
                                      itemCount: otherServicesTitles.length,
                                      shrinkWrap: true,
                                    ),
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
    userId = sharedPreferences.getString(Constants.SHARED_PREF_USER_ID);

    setState(() {
      username = sharedPreferences.getString(Constants.SHARED_PREF_NAME);
    });

    String? imagePath =
        sharedPreferences.getString(Constants.SHARED_PREF_USER_DP_PATH);
    if (imagePath != null) {
      setState(() {
        imageFile = File(imagePath);
      });
    }

    HTTPService().getWallets(authToken!).then((response) {
      if (response.statusCode == 200) {
        GetWalletsResponseModel walletsResponseModel =
            GetWalletsResponseModel.fromJson(json.decode(response.body));

        if (walletsResponseModel.status!) {
          GetWalletResponseData? getWalletResponseData =
              walletsResponseModel.data;

          if (mounted) {
            setState(() {
              mainWalletBalance = getWalletResponseData!.wBalance;
              atmWalletBalance = getWalletResponseData.aBalance;
            });
          }

          SharedPreferences.getInstance().then((sharedPrefs) {
            sharedPrefs.setString(
                Constants.SHARED_PREF_MAIN_WALLET_BALANCE, mainWalletBalance!);
            sharedPrefs.setString(
                Constants.SHARED_PREF_ATM_BALANCE, atmWalletBalance!);
          });

          setState(() {
            _showWallet = true;
          });
        } else {
          showErrorDialog(walletsResponseModel.message);
          SharedPreferences.getInstance().then((sharedPrefs) {
            sharedPrefs.setString(
                Constants.SHARED_PREF_MAIN_WALLET_BALANCE, '0');
            sharedPrefs.setString(Constants.SHARED_PREF_ATM_BALANCE, '0');
            sharedPrefs.setString(Constants.SHARED_PREF_MATM_BALANCE, '0');
          });

          setState(() {
            _showWallet = true;
          });
        }
      } else {
        setState(() {
          _showWallet = true;
        });
        showErrorDialog(
            'Server error occurred while fetching wallet data. Error code ${response.statusCode}');
        SharedPreferences.getInstance().then((sharedPrefs) {
          sharedPrefs.setString(Constants.SHARED_PREF_MAIN_WALLET_BALANCE, '0');
          sharedPrefs.setString(Constants.SHARED_PREF_ATM_BALANCE, '0');
          sharedPrefs.setString(Constants.SHARED_PREF_MATM_BALANCE, '0');
        });
      }
    });

    HTTPService().getBanner(authToken!).then((response) {
      if (response.statusCode == 200) {
        BannerResponseModel bannerResponseModel =
            BannerResponseModel.fromJson(json.decode(response.body));

        List<String?> urlList = [];
        List<String?> redirectUrlList = [];

        for (int i = 0; i < bannerResponseModel.data!.length; i++) {
          urlList.add(bannerResponseModel.data![i].photo);
          redirectUrlList.add(bannerResponseModel.data![i].description);
        }

        if (mounted) {
          setState(() {
            bannerUrl = urlList;
            redirectUrl = redirectUrlList;
          });
        }
      } else {
        print('Could not fetch image');
      }
    });

    HTTPService().getNotice(authToken!).then((response) {
      if (response.statusCode == 200) {
        NoticeResponseModel responseModel =
            NoticeResponseModel.fromJson(json.decode(response.body));
        if (responseModel.status!) {
          List<NoticeResponseData>? listOfNotices = [];
          listOfNotices = responseModel.data;
          if (mounted) {
            if (listOfNotices!.isNotEmpty) {
              setState(() {
                noticeString = listOfNotices![0].description;
              });
            }
          }
        } else {
          showErrorDialog(responseModel.message);
        }
      } else {
        showErrorDialog('Error occurred ${response.statusCode}');
      }
    });

    HTTPService().getAllCommissions(authToken!).then((response) {
      if (response.statusCode == 200) {
        AllCommissionsResponseModel responseModel =
            AllCommissionsResponseModel.fromJson(json.decode(response.body));
        if (responseModel.status!) {
          if (mounted) {
            setState(() {
              youEarned = responseModel.data!.youearned;
              transactionCount = responseModel.data!.transcationcount;
              totalTxnAmount = responseModel.data!.totaltxn;
            });
          }
        } else {
          showErrorDialog(responseModel.message);
        }
      } else {
        showErrorDialog('Error occurred while fetching commission');
      }
    });
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

  void showComingSoon(String message) {
    if (mounted) {
      showDialog(
          context: context,
          builder: (buildContext) {
            return CustomAlertDialog(
              contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              content: Container(
                width: 80,
                height: 180,
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
                          Icons.info_outline_rounded,
                          size: 40,
                          color: Colors.blue,
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
        getWalletResponseData.wBalance!);

    sharedPreferences.setString(
        Constants.SHARED_PREF_MATM_BALANCE, getWalletResponseData.mBalance!);

    sharedPreferences.setString(
        Constants.SHARED_PREF_ATM_BALANCE, getWalletResponseData.aBalance!);
  }

  void startAEPSTransaction() {
    const platformChannel = const MethodChannel("com.brixham.vimopay");
    try {
      platformChannel.invokeMethod("AEPS").then((result) {
        print(result.toString());
      });
    } catch (error) {
      print('AEPS error : $error');
    }
  }

  void startMiniATM() {
    const platformChannel = const MethodChannel("com.brixham.vimopay");
    try {
      platformChannel.invokeMethod("Mini ATM").then((result) {
        print(result.toString());
      });
    } catch (error) {
      print('Mini ATM error : $error');
    }
  }

  void logoutUser() async {
    SharedPreferences.getInstance().then((sharedPrefs) {
      sharedPrefs.clear();
    });
    Navigator.of(context)
        .pushAndRemoveUntil(ScaleRoute(page: LoginScreen()), (route) => false);
  }
}
