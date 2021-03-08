import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vimopay_application/customs/constants.dart';
import 'package:vimopay_application/network/http_service.dart';
import 'package:vimopay_application/network/models/biller_details_response_model.dart';
import 'package:vimopay_application/network/models/cms_get_billers_response.dart';

class CMSServiceScreen extends StatefulWidget {
  @override
  _CMSServiceScreenState createState() => _CMSServiceScreenState();
}

class _CMSServiceScreenState extends State<CMSServiceScreen> {
  String partnerId = Constants.SHARED_PREF_CMS_PARTNER_ID;
  List<String> listOfOperators = List();
  List<Billers> listOfBillers = List();
  List<TextEditingController> listOfControllers = List();
  List<String> listOfPostKeys = List();

  String selectedBillerUrl = "";
  String selectedBillerName = "";
  Billers selectedBiller;

  bool _showBillerDetails = false;
  bool _showDetailsProgress = false;
  bool _showProgress = false;

  List<Fields> listOfFields = List();
  String mainWalletBalance = "";
  String authToken = "";

  @override
  void initState() {
    super.initState();

    getUserDetails();

    fetchBillerList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: SafeArea(
            child: Scaffold(
                backgroundColor: Color(0xffd3d3d3),
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
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'CMS Service',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          Container(
                              padding: EdgeInsets.all(15),
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
                        ],
                      )),
                ),
                body: SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    padding: EdgeInsets.fromLTRB(10, 40, 10, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Operator',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 18,
                          ),
                        ),
                        DropdownButton(
                            isExpanded: true,
                            value: selectedBiller,
                            onChanged: (value) {
                              setState(() {
                                selectedBiller = value;

                                selectedBillerUrl = selectedBiller.fetchUrl;
                                selectedBillerName = selectedBiller.name;

                                fetchBillerDetails(selectedBillerUrl);
                              });
                            },
                            items: listOfBillers.map((biller) {
                              return DropdownMenuItem(
                                child: Text(
                                  biller.name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black),
                                ),
                                value: biller,
                              );
                            }).toList()),
                        _showBillerDetails
                            ? buildDynamicLayout()
                            : _showDetailsProgress
                                ? Container(
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : Container(),
                        _showBillerDetails
                            ? _showProgress
                                ? Container(
                                    margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                                    alignment: Alignment.center,
                                    child: CircularProgressIndicator())
                                : Container(
                                    margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                                    alignment: Alignment.center,
                                    child: MaterialButton(
                                      onPressed: () {
                                        fetchBillDetails();
                                      },
                                      child: Text(
                                        'Submit',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                      minWidth: 150,
                                      color: Colors.blue[900],
                                      padding: EdgeInsets.all(8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  )
                            : Container(),
                      ],
                    ),
                  ),
                ))),
        onWillPop: onBackPressed);
  }

  Future<bool> onBackPressed() async {
    Navigator.of(context).pop();
    return true;
  }

  void fetchBillerList() {
    HTTPService().fetchCMSBillers(partnerId).then((response) {
      if (response.statusCode == 200) {
        CMSBillersResponseModel responseModel =
            CMSBillersResponseModel.fromJson(json.decode(response.body));
        if (responseModel.data != null) {
          responseModel.data.billers.forEach((biller) {
            listOfOperators.add(biller.name);
          });
          setState(() {
            listOfBillers = responseModel.data.billers;
            selectedBiller = listOfBillers[0];
            selectedBillerUrl = listOfBillers[0].fetchUrl;
            selectedBillerName = listOfBillers[0].name;

            fetchBillerDetails(selectedBillerUrl);
          });
        } else {}
      } else {}
    });
  }

  Widget buildDynamicLayout() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return listOfFields[index].isVisible == "true"
            ? Container(
                margin: EdgeInsets.fromLTRB(0, 10, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listOfFields[index].label,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18,
                      ),
                    ),
                    Container(
                      height: 50,
                      margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                      child: listOfFields[index].type != "D"
                          ? TextField(
                              controller: listOfControllers[index],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: listOfFields[index].label,
                                hintStyle: TextStyle(
                                    color: Colors.black54, fontSize: 16),
                                enabled:
                                    listOfFields[index].isEditable == "true"
                                        ? true
                                        : false,
                              ),
                              keyboardType: listOfFields[index].type == "N" ||
                                      listOfFields[index].type == "PWDN"
                                  ? TextInputType.number
                                  : TextInputType.text,
                              obscureText: listOfFields[index].type == "PWD" ||
                                      listOfFields[index].type == "PWDN"
                                  ? true
                                  : false,
                            )
                          : Container(),
                    ),
                  ],
                ),
              )
            : Container();
      },
      itemCount: listOfFields.length,
      shrinkWrap: true,
    );
  }

  void fetchBillerDetails(String billerURL) {
    setState(() {
      _showDetailsProgress = true;
      _showBillerDetails = false;
    });

    HTTPService().fetchBillerDetails(partnerId, billerURL).then((response) {
      setState(() {
        _showDetailsProgress = false;
      });

      if (response.statusCode == 200) {
        BillerDetailsResponseModel responseModel =
            BillerDetailsResponseModel.fromJson(json.decode(response.body));

        List<Fields> list = List();

        responseModel.data.fields.forEach((field) {
          TextEditingController textEditingController = TextEditingController();
          if (field.isVisible == "true") {
            list.add(field);
            listOfControllers.add(textEditingController);
            listOfPostKeys.add(field.postKey);
          }
        });

        setState(() {
          _showBillerDetails = true;
          listOfFields = list;
        });
      } else {}
    });
  }

  void fetchBillDetails() {
    setState(() {
      _showProgress = true;
    });

    HashMap<String, String> hashMap = HashMap();

    for (int i = 0; i < listOfFields.length; i++) {
      Fields field = listOfFields[i];
      TextEditingController textEditingController = listOfControllers[i];

      Map<String, String> map = Map();
      map[field.postKey] = textEditingController.text;
      hashMap.addAll(map);
    }

    print(hashMap.toString());
  }

  void getUserDetails() {
    SharedPreferences.getInstance().then((sharedPrefs) {
      authToken = sharedPrefs.getString(Constants.SHARED_PREF_TOKEN);
      mainWalletBalance =
          sharedPrefs.getString(Constants.SHARED_PREF_MAIN_WALLET_BALANCE);
    });
  }
}
