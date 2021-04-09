import 'dart:collection';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vimopay_application/customs/constants.dart';
import 'package:vimopay_application/customs/custom_dialog.dart';
import 'package:vimopay_application/network/http_service.dart';
import 'package:vimopay_application/network/models/biller_details_response_model.dart';
import 'package:vimopay_application/network/models/cms_bill_details_data.dart';
import 'package:vimopay_application/network/models/cms_bill_details_response_model.dart';
import 'package:vimopay_application/network/models/cms_bill_paid_response_model.dart';
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
  List<TextEditingController> billDetailsControllerList = List();
  List<String> listOfPostKeys = List();
  List<String> billDetailsPostKeys = List();

  String selectedBillerUrl = "";
  String selectedBillerName = "";
  Billers selectedBiller;

  bool _showBillerDetails = false;
  bool _showDetailsProgress = false;
  bool _showProgress = false;
  bool _showPaymentProgress = false;
  bool _showBillDetails = false;

  List<Fields> listOfFields = List();
  List<BillDetailsField> billDetailsFields = List();
  String mainWalletBalance = "";
  String authToken = "";
  String sessionId = "";
  String billActionType = "";

  String partnerTxnId = "";
  String hash = "";

  CMSBillDetailsResponseData _billDetailsResponseData;

  @override
  void initState() {
    super.initState();

    getUserDetails();

    fetchBillerList();
  }

  @override
  void dispose() {
    super.dispose();

    listOfControllers.forEach((controller) {
      controller.dispose();
    });

    billDetailsControllerList.forEach((controller) {
      controller.dispose();
    });
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
                                        if (billActionType == "FETCH")
                                          fetchBillDetails();
                                      },
                                      child: Text(
                                        billActionType,
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
                        _showBillDetails && _billDetailsResponseData != null
                            ? Container(
                                child: buildDetailsLayout(),
                              )
                            : Container(),
                        _showBillDetails
                            ? !_showPaymentProgress
                                ? Container(
                                    margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                                    alignment: Alignment.center,
                                    child: MaterialButton(
                                      onPressed: () {
                                        payBill();
                                      },
                                      child: Text(
                                        "Submit",
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
                                : Container(
                                    child: Center(
                                    child: CircularProgressIndicator(),
                                  ))
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
                    listOfFields[index].type != "FETCH" &&
                            listOfFields[index].type != "SUBMIT"
                        ? Text(
                            listOfFields[index].label,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 18,
                            ),
                          )
                        : SizedBox(
                            height: 1,
                            width: 1,
                          ),
                    Container(
                      height: 50,
                      margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                      child: listOfFields[index].type != "D" &&
                              listOfFields[index].type != "FETCH" &&
                              listOfFields[index].type != "SUBMIT"
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
                          : SizedBox(
                              height: 1,
                              width: 1,
                            ),
                    ),
                  ],
                ),
              )
            : SizedBox(
                height: 1,
                width: 1,
              );
      },
      itemCount: listOfFields.length,
      shrinkWrap: true,
    );
  }

  void fetchBillerDetails(String billerURL) {
    setState(() {
      _showDetailsProgress = true;

      _showBillerDetails = false;
      _showBillDetails = false;
    });

    HTTPService().fetchBillerDetails(partnerId, billerURL).then((response) {
      setState(() {
        _showDetailsProgress = false;
        _showBillDetails = false;
      });

      if (response.statusCode == 200) {
        BillerDetailsResponseModel responseModel =
            BillerDetailsResponseModel.fromJson(json.decode(response.body));

        List<Fields> list = List();

        responseModel.data.fields.forEach((field) {
          TextEditingController textEditingController = TextEditingController();
          if (field.type != "SUBMIT" &&
              field.type != "FETCH" &&
              field.isVisible == "true") {
            list.add(field);
            listOfControllers.add(textEditingController);
            listOfPostKeys.add(field.postKey);
          }

          if (field.type == "SUBMIT" || field.type == "FETCH") {
            billActionType = field.type;
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

    // partnerTxnId = DateTime.now().microsecondsSinceEpoch.toString();

    HashMap<String, String> bodyMap = HashMap();

    for (int i = 0; i < listOfFields.length; i++) {
      Fields field = listOfFields[i];
      TextEditingController textEditingController = listOfControllers[i];

      Map<String, String> map = Map();
      if (textEditingController.text.isEmpty)
        map[field.postKey] = field.value;
      else
        map[field.postKey] = textEditingController.text;

      bodyMap.addAll(map);
    }

    hash = generateHash();

    Map<String, String> sessionMap = Map();
    sessionMap['feSessionId'] = sessionId;
    bodyMap.addAll(sessionMap);

    Map<String, String> hashMap = Map();
    hashMap['hash'] = hash;
    bodyMap.addAll(hashMap);

    Map<String, String> partnerTxnMap = Map();
    partnerTxnMap['partnerTxnId'] = partnerTxnId;
    // bodyMap.addAll(partnerTxnMap);
    bodyMap.addAll(partnerTxnMap);

    Map<String, String> partnerIdMap = Map();
    partnerIdMap['partnerId'] = partnerId;
    bodyMap.addAll(partnerIdMap);

    selectedBillerUrl =
        "/billers${selectedBillerUrl.substring(selectedBillerUrl.lastIndexOf("/"))}";

    List<BillDetailsField> list = List();

    HTTPService()
        .fetchBillDetails(partnerId, selectedBillerUrl, jsonEncode(bodyMap))
        .then((response) {
      if (response.statusCode == 200) {
        CMSBillDetailsResponseModel responseModel =
            CMSBillDetailsResponseModel.fromJson(json.decode(response.body));
        _billDetailsResponseData = responseModel.data;
        if (responseModel.meta.status == "0") {
          responseModel.data.fields.forEach((field) {
            TextEditingController textEditingController =
                TextEditingController();
            if (field.type != "SUBMIT" &&
                field.type != "FETCH" &&
                field.isVisible == "true") {
              list.add(field);
              textEditingController.text = field.value;
              billDetailsControllerList.add(textEditingController);
              billDetailsPostKeys.add(field.postKey);
            }

            if (field.type == "SUBMIT" || field.type == "FETCH") {
              billActionType = field.type;
            }

            setState(() {
              _showProgress = false;
              _showBillDetails = true;
              _showBillerDetails = false;

              billDetailsFields = list;
            });
          });
        } else {
          showErrorDialog(responseModel.meta.description);
          print('Error code : ${responseModel.meta.code}');
        }
      } else {
        setState(() {
          _showProgress = false;
          _showBillDetails = false;

          billDetailsFields.clear();
        });
      }
    });
  }

  void getUserDetails() {
    SharedPreferences.getInstance().then((sharedPrefs) {
      authToken = sharedPrefs.getString(Constants.SHARED_PREF_TOKEN);
      mainWalletBalance =
          sharedPrefs.getString(Constants.SHARED_PREF_MAIN_WALLET_BALANCE);
    });
  }

  String generateHash() {
    sessionId = DateTime.now().microsecondsSinceEpoch.toString();
    // partnerTxnId = "Txn_${DateTime.now().millisecondsSinceEpoch.toString()}";
    partnerTxnId = sessionId;
    String salt = "7fabdc58";

    var bytes = utf8.encode('$sessionId#$partnerId#$partnerTxnId#$salt');
    Digest sha512Result = sha512.convert(bytes);

    return sha512Result.toString();
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

  Widget buildDetailsLayout() {
    return ListView.builder(
        itemCount: billDetailsFields.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return billDetailsFields[index].isVisible == "true"
              ? Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      billDetailsFields[index].type != "FETCH" &&
                              billDetailsFields[index].type != "SUBMIT"
                          ? Text(
                              billDetailsFields[index].label,
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 18,
                              ),
                            )
                          : SizedBox(
                              height: 1,
                              width: 1,
                            ),
                      Container(
                        height: 50,
                        margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                        child: billDetailsFields[index].type != "D" &&
                                billDetailsFields[index].type != "FETCH" &&
                                billDetailsFields[index].type != "SUBMIT"
                            ? TextField(
                                controller: billDetailsControllerList[index],
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: billDetailsFields[index].label,
                                  hintStyle: TextStyle(
                                      color: Colors.black54, fontSize: 16),
                                  enabled:
                                      billDetailsFields[index].isEditable ==
                                              "true"
                                          ? true
                                          : false,
                                ),
                                keyboardType: billDetailsFields[index].type ==
                                            "N" ||
                                        billDetailsFields[index].type == "PWDN"
                                    ? TextInputType.number
                                    : TextInputType.text,
                                obscureText: billDetailsFields[index].type ==
                                            "PWD" ||
                                        billDetailsFields[index].type == "PWDN"
                                    ? true
                                    : false,
                              )
                            : SizedBox(
                                height: 1,
                                width: 1,
                              ),
                      ),
                    ],
                  ),
                )
              : SizedBox(
                  height: 1,
                  width: 1,
                );
        });
  }

  void payBill() {
    setState(() {
      _showPaymentProgress = true;
    });

    // partnerTxnId = DateTime.now().microsecondsSinceEpoch.toString();

    HashMap<String, String> bodyMap = HashMap();

    for (int i = 0; i < billDetailsFields.length; i++) {
      BillDetailsField field = billDetailsFields[i];
      TextEditingController textEditingController =
          billDetailsControllerList[i];

      Map<String, String> map = Map();
      if (textEditingController.text.isEmpty)
        map[field.postKey] = field.value;
      else
        map[field.postKey] = textEditingController.text;

      bodyMap.addAll(map);
    }

    // String hash = generateHash();

    Map<String, String> sessionMap = Map();
    sessionMap['feSessionId'] = sessionId;
    bodyMap.addAll(sessionMap);

    Map<String, String> assistCustMap = Map();
    assistCustMap['assistCustId'] = "7718313198";
    bodyMap.addAll(assistCustMap);

    Map<String, String> hashMap = Map();
    hashMap['hash'] = hash;
    bodyMap.addAll(hashMap);

    Map<String, String> partnerTxnMap = Map();
    partnerTxnMap['partnerTxnId'] = partnerTxnId;
    // bodyMap.addAll(partnerTxnMap);
    bodyMap.addAll(partnerTxnMap);

    Map<String, String> customerIdMap = Map();
    customerIdMap['customerId'] = partnerId;
    bodyMap.addAll(customerIdMap);

    Map<String, String> partnerIdMap = Map();
    partnerIdMap['partnerId'] = partnerId;
    bodyMap.addAll(partnerIdMap);

    selectedBillerUrl =
        "/billers${selectedBillerUrl.substring(selectedBillerUrl.lastIndexOf("/"))}";

    HTTPService()
        .payBill(partnerId, selectedBillerUrl, jsonEncode(bodyMap))
        .then((response) {
      setState(() {
        _showPaymentProgress = false;
      });

      if (response.statusCode == 200) {
        CMSBillPaidResponseModel responseModel =
            CMSBillPaidResponseModel.fromJson(json.decode(response.body));
        if (responseModel.meta.status == "0")
          showSuccessDialog(context, responseModel.meta.description);
        else
          showErrorDialog(responseModel.meta.description);
      } else {
        showErrorDialog("Payment failed!");
      }
    });
  }
}
