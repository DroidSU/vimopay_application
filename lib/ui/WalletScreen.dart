import 'package:flutter/material.dart';

class WalletScreen extends StatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Color(0xfff1fafc),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: 1,
              backgroundColor: Colors.grey,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.blue[900],
              selectedLabelStyle: TextStyle(color: Colors.blue[900]),
              unselectedLabelStyle: TextStyle(color: Colors.white),
              unselectedItemColor: Colors.white,
              onTap: (index) {
                switch (index) {
                  case 0:
                    onBackPressed();
                    break;
                  case 1:
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
          ),
        ),
        onWillPop: onBackPressed);
  }

  Future<bool> onBackPressed() async {
    Navigator.of(context).pop();
    return true;
  }
}
