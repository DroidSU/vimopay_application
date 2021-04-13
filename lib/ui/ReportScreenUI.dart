import 'package:flutter/material.dart';
import 'package:vimopay_application/customs/scale_route_transition.dart';
import 'package:vimopay_application/ui/ATMTransactionReportScreen.dart';
import 'package:vimopay_application/ui/DMTReportScreen.dart';
import 'package:vimopay_application/ui/RechargeReportScreen.dart';
import 'package:vimopay_application/ui/TransactionReportScreen.dart';

import 'CommissionReportScreen.dart';
import 'DashboardScreen.dart';
import 'ProfileScreenNew.dart';
import 'SupportScreen.dart';
import 'WalletScreen.dart';

class ReportScreenUI extends StatefulWidget {
  @override
  _ReportScreenUIState createState() => _ReportScreenUIState();
}

class _ReportScreenUIState extends State<ReportScreenUI> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: SafeArea(
            child: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: 2,
            backgroundColor: Color(0xff133374),
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.yellowAccent,
            selectedLabelStyle: TextStyle(color: Colors.yellowAccent),
            unselectedLabelStyle: TextStyle(color: Colors.white),
            unselectedItemColor: Colors.white,
            onTap: (index) {
              switch (index) {
                case 0:
                  Navigator.of(context).pushAndRemoveUntil(
                      ScaleRoute(page: DashboardScreen()), (route) => false);
                  break;
                case 1:
                  Navigator.of(context).pushReplacement(ScaleRoute(
                      page: WalletScreen(
                    comingFrom: "ReportScreen",
                    selectedWallet: 0,
                  )));
                  break;
                case 2:
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
                      'Reports',
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
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    padding: EdgeInsets.all(5),
                    width: MediaQuery.of(context).size.width,
                    child: Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'ATM Wallet Transaction Report',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                ),
                                Icon(
                                  Icons.navigate_next_rounded,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                                ScaleRoute(page: ATMTransactionReportScreen()));
                          },
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    padding: EdgeInsets.all(5),
                    width: MediaQuery.of(context).size.width,
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.all(15),
                          child: InkWell(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'DMT Report',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                ),
                                Icon(
                                  Icons.navigate_next_rounded,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.of(context)
                                  .push(ScaleRoute(page: DMTReportScreen()));
                            },
                          )),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    padding: EdgeInsets.all(5),
                    width: MediaQuery.of(context).size.width,
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.all(15),
                          child: InkWell(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Recharge Report',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                ),
                                Icon(
                                  Icons.navigate_next_rounded,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                  ScaleRoute(page: RechargeReportScreen()));
                            },
                          )),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    padding: EdgeInsets.all(5),
                    width: MediaQuery.of(context).size.width,
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(15),
                        child: InkWell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'All Transaction Report',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal),
                              ),
                              Icon(
                                Icons.navigate_next_rounded,
                                color: Colors.black,
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                                ScaleRoute(page: TransactionReportScreen()));
                          },
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    padding: EdgeInsets.all(5),
                    width: MediaQuery.of(context).size.width,
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.all(15),
                          child: InkWell(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Commission Report',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                ),
                                Icon(
                                  Icons.navigate_next_rounded,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                  ScaleRoute(page: CommissionReportScreen()));
                            },
                          )),
                    ),
                  ),
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
}
