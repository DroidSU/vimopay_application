import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vimopay_application/customs/constants.dart';
import 'package:vimopay_application/customs/custom_dialog.dart';
import 'package:vimopay_application/customs/scale_route_transition.dart';
import 'package:vimopay_application/customs/utility_methods.dart';
import 'package:vimopay_application/network/http_service.dart';
import 'package:vimopay_application/network/models/get_wallet_response_data.dart';
import 'package:vimopay_application/network/models/get_wallet_response_model.dart';
import 'package:vimopay_application/network/models/main_transaction_response_model.dart';
import 'package:vimopay_application/network/models/transfer_to_wallet_response_model.dart';
import 'package:vimopay_application/ui/AddMoneyWalletScreen.dart';
import 'package:vimopay_application/ui/DashboardScreen.dart';
import 'package:vimopay_application/ui/ProfileScreenNew.dart';
import 'package:vimopay_application/ui/TransferToBankScreen.dart';

import 'ReportScreenUI.dart';
import 'SupportScreen.dart';

class WalletScreen extends StatefulWidget {
  final String? comingFrom;
  final int selectedWallet;

  WalletScreen({this.comingFrom, required this.selectedWallet});

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  String? authToken = "";
  String? mainWalletBalance = "";
  String? atmWalletBalance = "";

  List<String> walletNames = ['Atm Wallet', 'Main Wallet'];
  List<String?> balances = [];
  List<String> backgroundImageList = [];
  List<String> walletIconList = [];

  List<MainTransactionResponseData>? mainTransactionsList = [];

  LinearGradient? mainWalletGradient;
  LinearGradient? atmWalletGradient;

  ScrollController? _scrollController;

  int selectedWallet = 0;
  int currentIndex = 1;
  bool _showProgress = true;
  bool _showTransactionProgress = false;
  String? _comingFrom = "";

  @override
  void initState() {
    super.initState();
    _comingFrom = widget.comingFrom;
    selectedWallet = widget.selectedWallet;

    if (selectedWallet == 0)
      currentIndex = 1;
    else
      currentIndex = 2;

    _scrollController = ScrollController();

    backgroundImageList.add('images/ic_aeps_bg.png');
    backgroundImageList.add('images/ic_main_wallet_bg.png');

    walletIconList.add('images/ic_aeps_wallet.png');
    walletIconList.add('images/ic_main_wallet.png');

    mainWalletGradient = LinearGradient(
      colors: [
        Color(0xff6F65FA),
        Color(0xff3F58B9),
        Color(0xff144c7d),
      ],
    );

    atmWalletGradient = LinearGradient(
      colors: [
        Color(0xffA927F9),
        Color(0xff801EBC),
        Color(0xff5A1584),
      ],
    );

    getUserDetails();

    _scrollController!.addListener(() {
      int index =
          (_scrollController!.offset / (MediaQuery.of(context).size.width))
                  .round() +
              1;

      print('Index : $index');

      if (index != currentIndex) {
        currentIndex = index;

        if (index == 1) {
          fetchATMWalletTransactions();
        } else {
          _scrollController!
              .jumpTo(_scrollController!.position.maxScrollExtent);
          fetchMainWalletTransactions();
        }
      }
    });

    // _scrollController.jumpTo(currentIndex.toDouble());
  }

  @override
  void dispose() {
    _scrollController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // After 1 second, it takes you to the end of the ListView
    if (currentIndex == 2) {
      Timer(Duration(seconds: 1), () {
        _scrollController!.jumpTo(_scrollController!.position.maxScrollExtent);
      });
    }

    return WillPopScope(
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Color(0xfff1fafc),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: 1,
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
                    Navigator.of(context)
                        .push(ScaleRoute(page: SupportScreen()));
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
                        'Wallet',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                    height: 140,
                    padding: EdgeInsets.all(6),
                    child: _showProgress
                        ? Container()
                        : ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemExtent: MediaQuery.of(context).size.width - 20,
                            controller: _scrollController,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: index == 0
                                      ? mainWalletGradient
                                      : atmWalletGradient,
                                ),
                                // child: InkWell(
                                //   child:
                                //   onTap: () {
                                //     _scrollController.animateTo(
                                //         (index *
                                //                 (MediaQuery.of(context)
                                //                         .size
                                //                         .width -
                                //                     20))
                                //             .toDouble(),
                                //         duration: new Duration(seconds: 2),
                                //         curve: Curves.ease);
                                //   },
                                // ),
                                child: Material(
                                    elevation: 5,
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: index == 0
                                            ? mainWalletGradient
                                            : atmWalletGradient,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: Stack(
                                              children: [
                                                Row(
                                                  children: [
                                                    Material(
                                                      shape: CircleBorder(),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        child: Image.asset(
                                                          walletIconList[index],
                                                          height: 24,
                                                          width: 24,
                                                        ),
                                                      ),
                                                      color: Colors.white,
                                                    ),
                                                    SizedBox(
                                                      width: 12,
                                                    ),
                                                    Text(
                                                      walletNames[index],
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            margin: EdgeInsets.fromLTRB(
                                                0, 10, 0, 0),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                0, 0, 0, 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  'Balance',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Text(
                                                  balances[index]!,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              );
                            },
                            itemCount: walletNames.length,
                          ),
                  ),
                  selectedWallet == 1 ? buildMainExtra() : buildATMExtra(),
                  _showTransactionProgress
                      ? Container()
                      : Container(
                          child: Text(
                            'Transaction Details',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                          padding: EdgeInsets.fromLTRB(30, 15, 0, 0),
                        ),
                  _showTransactionProgress
                      ? Expanded(
                          child: Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        )
                      : Expanded(
                          child: buildTransactionWidget(),
                        ),
                ],
              ),
            ),
          ),
        ),
        onWillPop: onBackPressed);
  }

  Future<bool> onBackPressed() async {
    if (_comingFrom == "Dashboard") {
      Navigator.of(context)
          .pushReplacement(ScaleRoute(page: DashboardScreen()));
    } else if (_comingFrom == "ReportScreen") {
      Navigator.of(context).pushReplacement(ScaleRoute(page: ReportScreenUI()));
    } else {
      Navigator.of(context).pop();
    }
    return true;
  }

  void getUserDetails() {
    SharedPreferences.getInstance().then((sharedPrefs) {
      authToken = sharedPrefs.getString(Constants.SHARED_PREF_TOKEN);

      HTTPService().getWallets(authToken!).then((response) {
        setState(() {
          _showProgress = false;
        });
        if (response.statusCode == 200) {
          GetWalletsResponseModel walletsResponseModel =
              GetWalletsResponseModel.fromJson(json.decode(response.body));

          if (walletsResponseModel.status!) {
            GetWalletResponseData? getWalletResponseData =
                walletsResponseModel.data;

            setState(() {
              mainWalletBalance = getWalletResponseData!.wBalance;
              atmWalletBalance = getWalletResponseData.aBalance;

              balances.add(atmWalletBalance);
              balances.add(mainWalletBalance);
            });
            SharedPreferences.getInstance().then((sharedPrefs) {
              sharedPrefs.setString(Constants.SHARED_PREF_MAIN_WALLET_BALANCE,
                  mainWalletBalance!);
              sharedPrefs.setString(
                  Constants.SHARED_PREF_ATM_BALANCE, atmWalletBalance!);
            });
          } else {
            showErrorDialog(walletsResponseModel.message);

            setState(() {
              balances.add('0');
              balances.add('0');
            });

            SharedPreferences.getInstance().then((sharedPrefs) {
              sharedPrefs.setString(
                  Constants.SHARED_PREF_MAIN_WALLET_BALANCE, '0');
              sharedPrefs.setString(Constants.SHARED_PREF_ATM_BALANCE, '0');
              sharedPrefs.setString(Constants.SHARED_PREF_MATM_BALANCE, '0');
            });
          }
        } else {
          showErrorDialog(
              'Server error occurred while fetching wallet data. Error code ${response.statusCode}');

          setState(() {
            balances.add('0');
            balances.add('0');
          });

          SharedPreferences.getInstance().then((sharedPrefs) {
            sharedPrefs.setString(
                Constants.SHARED_PREF_MAIN_WALLET_BALANCE, '0');
            sharedPrefs.setString(Constants.SHARED_PREF_ATM_BALANCE, '0');
            sharedPrefs.setString(Constants.SHARED_PREF_MATM_BALANCE, '0');
          });
        }
      });

      if (selectedWallet == 0)
        fetchATMWalletTransactions();
      else
        fetchMainWalletTransactions();
    });
  }

  void fetchMainWalletTransactions() {
    setState(() {
      _showTransactionProgress = true;
      selectedWallet = 1;
      mainTransactionsList!.clear();
    });

    HTTPService().getMainWalletTransactions(authToken!).then((response) {
      setState(() {
        _showTransactionProgress = false;
      });

      if (response.statusCode == 200) {
        MainTransactionsResponseModel responseModel =
            MainTransactionsResponseModel.fromJson(json.decode(response.body));
        if (responseModel.status!) {
          setState(() {
            mainTransactionsList!.clear();
            mainTransactionsList = responseModel.data;
          });
        } else {
          mainTransactionsList!.clear();
        }
      } else {
        mainTransactionsList!.clear();
      }
    });
  }

  void fetchATMWalletTransactions() {
    setState(() {
      selectedWallet = 0;
      _showTransactionProgress = true;
      mainTransactionsList!.clear();
    });

    HTTPService().getWalletTransactions(authToken!).then((response) {
      setState(() {
        _showTransactionProgress = false;
      });

      // SAME AS MAIN TRANSACTION WALLET
      if (response.statusCode == 200) {
        MainTransactionsResponseModel responseModel =
            MainTransactionsResponseModel.fromJson(json.decode(response.body));
        if (responseModel.status!) {
          setState(() {
            mainTransactionsList!.clear();
            mainTransactionsList = responseModel.data;
          });
        } else {
          mainTransactionsList!.clear();
        }
      } else {
        mainTransactionsList!.clear();
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

  Widget buildTransactionWidget() {
    if (selectedWallet == 0 || selectedWallet == 1) {
      if (mainTransactionsList!.isNotEmpty) {
        return ListView.builder(
          itemBuilder: (context, index) {
            return Container(
              height: 150,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            mainTransactionsList![index].transactionType!,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Text(
                              '\u20B9 ${mainTransactionsList![index].transactionAmt.toString()}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.end,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        mainTransactionsList![index].transactionId == null
                            ? 'Txn Id:'
                            : 'Txn Id: ${mainTransactionsList![index].transactionId}',
                        style: TextStyle(color: Colors.black54),
                      ),
                      Row(
                        children: [
                          Text(
                            'Date: ${mainTransactionsList![index].createDate!.substring(0, 10)} ${UtilityMethods().beautifyTime(mainTransactionsList![index].createDate!.substring(11))}',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              mainTransactionsList![index].isStatus == 1
                                  ? 'Pending'
                                  : mainTransactionsList![index].isStatus == 2
                                      ? 'Success'
                                      : 'Failed',
                              style: TextStyle(
                                  color:
                                      mainTransactionsList![index].isStatus == 1
                                          ? Color(0xff133374)
                                          : mainTransactionsList![index]
                                                      .isStatus ==
                                                  2
                                              ? Colors.green
                                              : Colors.red,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.end,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          'Remarks : ${mainTransactionsList![index].comment}',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          itemCount: mainTransactionsList!.length,
          shrinkWrap: true,
        );
      } else {
        return Container(
          child: Center(
            child: Text(
              'No transactions to show',
              style: TextStyle(color: Colors.black54),
            ),
          ),
        );
      }
    } else {
      return Container();
    }
  }

  buildMainExtra() {
    return Container(
      width: double.infinity,
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: InkWell(
          child: Padding(
            padding: EdgeInsets.all(5),
            // child: Image.asset(
            //   'images/ic_add_money.png',
            //   height: 24,
            //   width: 24,
            // ),
            child: Text(
              '+ Add Money',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          onTap: () {
            Navigator.of(context)
                .push(ScaleRoute(page: AddMoneyWalletScreen()));
          },
        ),
        elevation: 10,
        color: Colors.pink[500],
      ),
      alignment: Alignment.centerRight,
    );
  }

  buildATMExtra() {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Material(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: InkWell(
              child: Padding(
                padding: EdgeInsets.all(5),
                // child: Image.asset(
                //   'images/ic_add_money.png',
                //   height: 24,
                //   width: 24,
                // ),
                child: Text(
                  'Transfer to Bank',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              onTap: () {
                startTransferToBank();
              },
            ),
            elevation: 10,
            color: Colors.pink[500],
          ),
          Material(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: InkWell(
              child: Padding(
                padding: EdgeInsets.all(5),
                // child: Image.asset(
                //   'images/ic_add_money.png',
                //   height: 24,
                //   width: 24,
                // ),
                child: Text(
                  'Transfer to Wallet',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              onTap: () => showTransferToWallet(),
            ),
            elevation: 10,
            color: Colors.pink[500],
          ),
        ],
      ),
    );
  }

  void startTransferToBank() {
    Navigator.of(context).push(ScaleRoute(
        page: TransferToBankScreen(
      walletBalance: atmWalletBalance,
    )));
  }

  void showTransferToWallet() {
    TextEditingController amountController = TextEditingController();
    bool _showTransferProgress = false;

    if (mounted) {
      showDialog(
          context: (context),
          builder: (buildContext) {
            return CustomAlertDialog(
              contentPadding: EdgeInsets.all(5),
              content: StatefulBuilder(
                builder: (context, StateSetter stateSetter) {
                  return Container(
                    height: 230,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text(
                          'Transfer to wallet',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Wallet Balance',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal),
                            ),
                            Text(
                              atmWalletBalance!,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Transfer ',
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 16),
                            ),
                            SizedBox(
                              width: 100,
                              height: 40,
                              child: TextField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal),
                                keyboardType: TextInputType.number,
                                controller: amountController,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: _showTransferProgress
                              ? CircularProgressIndicator()
                              : MaterialButton(
                                  onPressed: () {
                                    stateSetter(() {
                                      _showTransferProgress = true;
                                    });
                                    String amount =
                                        amountController.text.trim();
                                    if (double.parse(amount) <=
                                        double.parse(atmWalletBalance!)) {
                                      HTTPService()
                                          .transferToWallet(authToken!, amount)
                                          .then((response) {
                                        stateSetter(() {
                                          _showTransferProgress = false;
                                        });
                                        Navigator.of(context).pop();

                                        if (response.statusCode == 200) {
                                          TransferToWalletResponseModel
                                              responseModel =
                                              TransferToWalletResponseModel
                                                  .fromJson(json
                                                      .decode(response.body));
                                          if (responseModel.status!) {
                                            setState(() {
                                              atmWalletBalance = (double.parse(
                                                          atmWalletBalance!) -
                                                      double.parse(amount))
                                                  .toString();
                                            });

                                            showSuccessDialog(
                                                context, responseModel.message);
                                          } else {
                                            showErrorDialog(
                                                responseModel.message);
                                          }
                                        } else {
                                          showErrorDialog(
                                              'Some error occurred ${response.statusCode}');
                                        }
                                      });
                                    } else {
                                      Navigator.of(context).pop();
                                      showErrorDialog('Not enough balance');
                                    }
                                  },
                                  child: Text(
                                    'Transfer',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                  color: Colors.blue,
                                  minWidth: 120,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                        )
                      ],
                    ),
                  );
                },
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
}
