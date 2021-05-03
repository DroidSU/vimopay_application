import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vimopay_application/customs/api_constants.dart';

class HTTPService {
  Future<http.Response> loginUser(
      String mobile, String password, String? deviceId) async {
    http.Response response =
        await http.post(Uri.parse(Uri.encodeFull(APIConstants.ENDPOINT_LOGIN)),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00 ',
              'Authorization': 'Basic Vmltb3BheTpWaW1vcGF5QDIwMjA=',
            },
            body: jsonEncode({
              "Mobile": mobile,
              "password": password,
              "DeviceId": deviceId,
            }));

    print('Login response: ${response.body}');
    return response;
  }

  Future<http.Response> forgotPassword(String mobile, String otp) async {
    http.Response response = await http.post(
        Uri.parse(Uri.encodeFull(APIConstants.ENDPOINT_FORGOT_PASSWORD)),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00 ',
          'Authorization': 'Basic Vmltb3BheTpWaW1vcGF5QDIwMjA=',
        },
        body: jsonEncode({
          "Mobile": mobile,
          "OTP": otp,
        }));

    print('Forgot Password response: ${response.body}');
    return response;
  }

  Future<http.Response> changePassword(
      String authToken, String password) async {
    http.Response response = await http.post(
        Uri.parse(Uri.encodeFull(APIConstants.ENDPOINT_CHANGE_PASSWORD)),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00 ',
          'Authorization': 'Basic Vmltb3BheTpWaW1vcGF5QDIwMjA=',
          'A-Token': authToken,
        },
        body: jsonEncode({
          "password": password,
        }));

    print('Change Password response: ${response.body}');
    return response;
  }

  Future<http.Response> getWallets(String authToken) async {
    http.Response response = await http.get(
      Uri.parse(Uri.encodeFull(APIConstants.ENDPOINT_GET_WALLETS)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00 ',
        'Authorization': 'Basic Vmltb3BheTpWaW1vcGF5QDIwMjA=',
        'A-Token': authToken,
      },
    );

    print('Get wallets response: ${response.body}');
    return response;
  }

  Future<http.Response> getBanner(String authToken) async {
    http.Response response = await http
        .get(
          Uri.parse(Uri.encodeFull(APIConstants.ENDPOINT_GET_BANNER)),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
            'Authorization': 'Basic Vmltb3BheTpWaW1vcGF5QDIwMjA=',
            'A-Token': authToken,
          },
        )
        .timeout(Duration(minutes: 1))
        // ignore: return_of_invalid_type_from_catch_error
        .catchError((error) => {print('Exception: ${error.toString()}')});

    print('Get Banner: ${response.body}');
    return response;
  }

  Future<http.Response> getNotice(String authToken) async {
    http.Response response = await http
        .post(
          Uri.parse(Uri.encodeFull(APIConstants.ENDPOINT_GET_NOTICE)),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
            'Authorization': 'Basic Vmltb3BheTpWaW1vcGF5QDIwMjA=',
            'A-Token': authToken,
          },
        )
        .timeout(Duration(minutes: 1))
        .catchError((error) => {print('Exception: ${error.toString()}')});

    print('Get Notice: ${response.body}');
    return response;
  }

  Future<http.Response> getAllCommissions(String authToken) async {
    http.Response response = await http
        .post(
          Uri.parse(Uri.encodeFull(APIConstants.ENDPOINT_GET_COMMISSIONS)),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
            'Authorization': 'Basic Vmltb3BheTpWaW1vcGF5QDIwMjA=',
            'A-Token': authToken,
          },
        )
        .timeout(Duration(minutes: 1))
        .catchError((error) => {print('Exception: ${error.toString()}')});

    print('Get Commissions: ${response.body}');
    return response;
  }

  Future<http.Response> sendComplain(String authToken, String complainStatus,
      String complainDescription) async {
    http.Response response = await http
        .post(
          Uri.parse(Uri.encodeFull(APIConstants.ENDPOINT_COMPLAIN)),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
            'Authorization': 'Basic Vmltb3BheTpWaW1vcGF5QDIwMjA=',
            'A-Token': authToken,
          },
          body: jsonEncode(
              {'Status': complainStatus, 'Description': complainDescription}),
        )
        .timeout(Duration(minutes: 1))
        .catchError((error) => {print('Exception: ${error.toString()}')});

    print('Complain Sent: ${response.body}');
    return response;
  }

  Future<http.Response> sendReportComplain(
      String authToken,
      String? complainStatus,
      String complainDescription,
      String rechargeRefId) async {
    http.Response response = await http
        .post(
          Uri.parse(Uri.encodeFull(APIConstants.ENDPOINT_REPORT_COMPLAIN)),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
            'Authorization': 'Basic Vmltb3BheTpWaW1vcGF5QDIwMjA=',
            'A-Token': authToken,
          },
          body: jsonEncode({
            'ComplainStatus': complainStatus,
            'ComDescription': complainDescription,
            'RechargeRefId': rechargeRefId,
            "Reply": "",
          }),
        )
        .timeout(Duration(minutes: 1))
        .catchError((error) => {print('Exception: ${error.toString()}')});

    print('Complain Sent: ${response.body}');
    return response;
  }

  Future<http.Response> getMainWalletTransactions(String authToken) async {
    http.Response response = await http
        .post(
          Uri.parse(Uri.encodeFull(APIConstants.ENDPOINT_FETCH_MAIN_TXNS)),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
            'Authorization': 'Basic Vmltb3BheTpWaW1vcGF5QDIwMjA=',
            'A-Token': authToken,
          },
        )
        .timeout(Duration(minutes: 1))
        .catchError((error) => {print('Exception: ${error.toString()}')});

    print('Main Wallet Transactions: ${response.body}');
    return response;
  }

  Future<http.Response> getWalletTransactions(String authToken) async {
    http.Response response = await http
        .post(
          Uri.parse(Uri.encodeFull(APIConstants.ENDPOINT_FETCH_WALLET_TXNS)),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
            'Authorization': 'Basic Vmltb3BheTpWaW1vcGF5QDIwMjA=',
            'A-Token': authToken,
          },
        )
        .timeout(Duration(minutes: 1))
        .catchError((error) => {print('Exception: ${error.toString()}')});

    print('Wallet Transactions: ${response.body}');
    return response;
  }

  Future<http.Response> getAdminList(String authToken) async {
    http.Response response = await http
        .post(
          Uri.parse(Uri.encodeFull(APIConstants.ENDPOINT_GET_ADMIN_LIST)),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
            'Authorization': 'Basic Vmltb3BheTpWaW1vcGF5QDIwMjA=',
            'A-Token': authToken,
          },
        )
        .timeout(Duration(minutes: 1))
        .catchError((error) => {print('Exception: ${error.toString()}')});

    print('Admin List: ${response.body}');
    return response;
  }

  Future<http.Response> addMoneyRetailer(
      {String authToken = "",
      String? adminId,
      String? amount,
      String? mode,
      String? referenceNumber,
      String? note}) async {
    http.Response response = await http
        .post(Uri.parse(Uri.encodeFull(APIConstants.ENDPOINT_ADD_MONEY)),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
              'Authorization': 'Basic Vmltb3BheTpWaW1vcGF5QDIwMjA=',
              'A-Token': authToken,
            },
            body: jsonEncode({
              'adminid': adminId,
              'TransactionAmt': amount,
              'Note': note,
              'mode': mode,
              'refno': referenceNumber
            }))
        .timeout(Duration(minutes: 1))
        .catchError((error) => {
              print('Exception: ${error.toString()}')
            }); // ignore: return_of_invalid_type_from_catch_error

    print('Add Money: ${response.body}');
    return response;
  }

  Future<http.Response> moneyTransfer(
      {String authToken = "",
      String? accountNumber,
      String? ifscCode,
      String? beneficiaryName,
      String? amount,
      String? mode,
      String? narration}) async {
    http.Response response = await http
        .post(Uri.parse(Uri.encodeFull(APIConstants.ENDPOINT_MONEY_TRANSFER)),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
              'Authorization': 'Basic Vmltb3BheTpWaW1vcGF5QDIwMjA=',
              'A-Token': authToken,
            },
            body: jsonEncode({
              'AccountNo': accountNumber,
              'IfscCode': ifscCode,
              'Ben_Name': beneficiaryName,
              "Amount": amount,
              "Mode": mode,
              "Narration": ""
            }))
        .timeout(Duration(minutes: 1))
        .catchError((error) => {print('Exception: ${error.toString()}')});

    print('Money Transfer: ${response.body}');
    return response;
  }

  Future<http.Response> fetchTransactionDetails(String authToken,
      String fromDate, String toDate, String? status, String? product) async {
    http.Response response = await http
        .post(
          Uri.parse(
              Uri.encodeFull(APIConstants.ENDPOINT_FETCH_TRANSACTION_REPORT)),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
            'Authorization': 'Basic Vmltb3BheTpWaW1vcGF5QDIwMjA=',
            'A-Token': authToken,
          },
          body: jsonEncode({
            'status': status,
            'dateform': fromDate,
            'dateto': toDate,
            'product': product
          }),
        )
        .timeout(Duration(minutes: 1))
        .catchError((error) => {print('Exception: ${error.toString()}')});

    print('Transaction request : ${jsonEncode({
      'status': status,
      'dateform': fromDate,
      'dateto': toDate,
      'product': product
    })}');
    print('Transaction Details: ${response.body}');
    return response;
  }

  Future<http.Response> bbpsAgentLogin() async {
    http.Response response = await http
        .post(
          Uri.parse(Uri.encodeFull(
              APIConstants.BBPS_BASE_URL + 'v2/agents/1269501754/login')),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'username': 'manoj.dewangan@iiml.org',
            'password': '^|m0|p@yv|m00063'
          }),
        )
        .timeout(Duration(minutes: 1))
        .catchError((error) => {print('Exception: ${error.toString()}')});

    print('BBPS Login: ${response.body}');
    return response;
  }

  Future<http.Response> bbpsBillFetch(
      String refID,
      String fieldValue,
      String? billerId,
      String jwt_token,
      String mobileNumber,
      String? field) async {
    http.Response response = await http
        .post(
          Uri.parse(Uri.encodeFull(
              APIConstants.BBPS_BASE_URL + 'v2/agents/1269501754/bill/fetch')),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'jwt_token': jwt_token,
          },
          body: jsonEncode({
            "ref_id": refID,
            "bill_details": {
              field: fieldValue,
              "sub_district": "",
              "sub_division": ""
            },
            "biller_details": {
              "biller_id": billerId,
            },
            "additional_info": {
              "bbpsAgentId": "PT01PT63AGTU00000002",
              "agent_id": "PT63",
              "initiating_channel": "AGT",
              "ip": "10.10.10.10",
              "imei": "183000006490",
              "os": "Android",
              "app": "2.0",
              "customer_mobile": mobileNumber,
              "postal_code": "700017",
              "geocode": "21.2819,74.3789",
              "si_txn": "Yes",
              "mobile": "7718313198",
              "terminal_id": "7718313198",
            }
          }),
        )
        .timeout(Duration(minutes: 1))
        .catchError((error) => {print('Exception: ${error.toString()}')});

    print('Electricity Bill Fetch: ${response.body}');
    return response;
  }

  Future<http.Response> payElectricityBill(
      String jwt_token,
      String? ref_id,
      String billNumber,
      String accountNumber,
      String mobileNumber,
      String amount,
      String? billerId,
      String? field,
      String fieldValue) async {
    http.Response response = await http.post(
        Uri.parse(Uri.encodeFull(
            APIConstants.BBPS_BASE_URL + 'v2/agents/1269501754/bill/pay')),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'jwt_token': jwt_token,
        },
        body: jsonEncode({
          "ref_id": ref_id,
          "biller_fetch_response": {},
          "bill_details": {
            field: fieldValue,
            "bill_number": billNumber,
            "account_number": accountNumber,
            "amount": amount,
            "sub_district": "",
            "sub_division": ""
          },
          "biller_details": {
            "biller_id": billerId,
          },
          "additional_info": {
            "bbpsAgentId": "PT01PT63AGTU00000002",
            "agent_id": "PT63",
            "initiating_channel": "AGT",
            "ip": "10.10.10.10",
            "imei": "183000006490",
            "os": "Android",
            "app_version": "2.0",
            "customer_mobile": mobileNumber,
            "mobile": "7718313198",
            "si_txn": "Yes",
            "postal_code": "700017",
            "geocode": "21.2819,74.3789",
            "terminal_id": "7718313198",
            "payment_mode": "Cash",
            "payment_bank": "Cash",
            "cou_cust_conv_fee": "0",
            "Remarks": "None",
          }
        }));

    print('Electricity Bill Recharge : ${response.body}');
    return response;
  }

  Future<http.Response> fetchBBPSBillers(
      String authToken, String serviceId) async {
    http.Response response = await http.post(
      Uri.parse(Uri.encodeFull(APIConstants.ENDPOINT_SERVICE_LIST)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00 ',
        'Authorization': 'Basic Vmltb3BheTpWaW1vcGF5QDIwMjA=',
        'A-Token': authToken,
      },
      body: jsonEncode({"ServiceId": serviceId}),
    );

    print('Fetch electricity billers response: ${response.body}');
    return response;
  }

  Future<http.Response> retailerSMSEnquire(
      {String authToken = "",
      String? retailerID,
      String? mobileNumber,
      String? name,
      String? message}) async {
    http.Response response = await http
        .post(
            Uri.parse(
                Uri.encodeFull(APIConstants.ENDPOINT_RETAILER_SMS_ENQUIRE)),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
              'Authorization': 'Basic Vmltb3BheTpWaW1vcGF5QDIwMjA=',
              'A-Token': authToken,
            },
            body: jsonEncode({
              'RetailerID': retailerID,
              'MobileNo': mobileNumber,
              'Name': name,
              'Message': message,
            }))
        .timeout(Duration(minutes: 1))
        .catchError((error) => {print('Exception: ${error.toString()}')});

    print('SMS Enquire: ${response.body}');
    return response;
  }

  Future<http.Response> changeMobileNumber(
      String authToken, String? mobileNumber, String? otp) async {
    http.Response response = await http.post(
      Uri.parse(Uri.encodeFull(APIConstants.ENDPOINT_CHANGE_MOBILE_NUMBER)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00 ',
        'Authorization': 'Basic Vmltb3BheTpWaW1vcGF5QDIwMjA=',
        'A-Token': authToken,
      },
      body: jsonEncode({
        "mobileno": mobileNumber,
        "OTP": otp,
      }),
    );

    print('Change Mobile Number response: ${response.body}');
    return response;
  }

  Future<http.Response> changeEmailAddress(
      String authToken, String? emailAddress, String otp) async {
    http.Response response = await http.post(
      Uri.parse(Uri.encodeFull(APIConstants.ENDPOINT_CHANGE_EMAIL_ADDRESS)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00 ',
        'Authorization': 'Basic Vmltb3BheTpWaW1vcGF5QDIwMjA=',
        'A-Token': authToken,
      },
      body: jsonEncode({
        "Emailid": emailAddress,
        "OTP": otp,
      }),
    );

    print('Change Email Address response: ${response.body}');
    return response;
  }

  Future<http.Response> updateProfileDetails(
      String authToken,
      String? name,
      String? address,
      String? city,
      String? state,
      String? pincode,
      String? aadharNumber,
      String? panNumber,
      String? gstNumber) async {
    http.Response response = await http.post(
      Uri.parse(Uri.encodeFull(APIConstants.ENDPOINT_UPDATE_PROFILE_DETAILS)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00 ',
        'Authorization': 'Basic Vmltb3BheTpWaW1vcGF5QDIwMjA=',
        'A-Token': authToken,
      },
      body: jsonEncode({
        'Name': name,
        'Address': address,
        'City': city,
        'State': state,
        'Pincode': pincode,
        'Adharno': aadharNumber,
        'Panno': panNumber,
      }),
    );

    print('Update profile details response: ${response.body}');
    return response;
  }

  Future<http.Response> updateBankDetails(String authToken, String? bankName,
      String? accountNumber, String? ifsc, String? holderName) async {
    http.Response response = await http.post(
      Uri.parse(Uri.encodeFull(APIConstants.ENDPOINT_UPDATE_BANK_DETAILS)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00 ',
        'Authorization': 'Basic Vmltb3BheTpWaW1vcGF5QDIwMjA=',
        'A-Token': authToken,
      },
      body: jsonEncode({
        "Bankname": bankName,
        "Acno": accountNumber,
        "IFSC": ifsc,
        "Acholder": holderName
      }),
    );

    print(jsonEncode({
      "Bankname": bankName,
      "Acno": accountNumber,
      "IFSC": ifsc,
      "Acholder": holderName
    }).toString());

    print('Change Update Bank response: ${response.body}');
    return response;
  }

  Future<http.Response> getBankDetails(String authToken) async {
    http.Response response = await http.post(
        Uri.parse(Uri.encodeFull(APIConstants.ENDPOINT_GET_BANK_DETAILS)),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00 ',
          'Authorization': 'Basic Vmltb3BheTpWaW1vcGF5QDIwMjA=',
          'A-Token': authToken,
        });

    print('Bank Details response: ${response.body}');
    return response;
  }

  Future<http.Response> getCommissionPlanPDF(String authToken) async {
    http.Response response = await http.post(
        Uri.parse(Uri.encodeFull(APIConstants.ENDPOINT_GET_COMMISSION_PLAN)),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00 ',
          'Authorization': 'Basic Vmltb3BheTpWaW1vcGF5QDIwMjA=',
          'A-Token': authToken,
        });

    print('Commission Plan response: ${response.body}');
    return response;
  }

  Future<http.Response> getChecksum(String authToken, String beneficiaryAccount,
      String beneficiaryIFSC, String amount) async {
    http.Response response = await http.post(
        Uri.parse(Uri.encodeFull(APIConstants.ENDPOINT_GET_CHECKSUM)),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00 ',
          'Authorization': 'Basic Vmltb3BheTpWaW1vcGF5QDIwMjA=',
          'A-Token': authToken,
        },
        body: jsonEncode({
          "subwalletGuid": "4ccfe9f5-bb17-11ghjghkea-b181-fa163e4dhdfh29e83",
          "beneficiaryAccount": beneficiaryAccount,
          "beneficiaryIFSC": beneficiaryIFSC,
          "amount": amount,
          "purpose": 'OTHERS',
        }));

    print('Checksum response: ${response.body}');
    return response;
  }

  Future<http.Response> initiatePayout(
      {String mid = "",
      String checkSum = "",
      String? orderId,
      String? amount,
      String? purpose,
      String? date,
      String? transferMode,
      String? beneficiaryAccount,
      String? beneficiaryIFSC,
      String? beneficiaryVPA,
      String? phoneNumber,
      String? beneficiaryContactRefId}) async {
    http.Response response = await http.post(
        Uri.parse(Uri.encodeFull(APIConstants.ENDPOINT_INITIATE_PAYOUT)),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'x-mid': mid,
          'x-checksum': checkSum,
        },
        body: jsonEncode({
          'orderId': orderId,
          'subwalletGuid': '4ccfe9f5-bb17-11ghjghkea-b181-fa163e4dhdfh29e83',
          'amount': amount,
          'purpose': 'OTHERS',
          'transferMode': transferMode,
          'beneficiaryAccount': beneficiaryAccount,
          'beneficiaryIFSC': beneficiaryIFSC,
          'beneficiaryPhoneNo': phoneNumber,
        }));

    print('Payout response: ${response.body}');
    return response;
  }

  Future<http.Response> prepaidRecharge(
    String authToken,
    String mobileNumber,
    String? operatorCode,
    String amount,
  ) async {
    http.Response response = await http.post(
      Uri.parse(Uri.encodeFull(APIConstants.ENDPOINT_PREPAID_RECHARGE)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00 ',
        'Authorization': 'Basic Vmltb3BheTpWaW1vcGF5QDIwMjA=',
        'A-Token': authToken,
      },
      body: jsonEncode(
          {"MNO": mobileNumber, "Operator": operatorCode, "Amount": amount}),
    );

    print('Prepaid Recharge response: ${response.body}');
    return response;
  }

  Future<http.Response> dthRecharge(
    String authToken,
    String subscriberId,
    String? operatorCode,
    String amount,
  ) async {
    http.Response response = await http.post(
      Uri.parse(
        Uri.encodeFull(APIConstants.ENDPOINT_DTH_RECHARGE),
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00 ',
        'Authorization': 'Basic Vmltb3BheTpWaW1vcGF5QDIwMjA=',
        'A-Token': authToken,
      },
      body: jsonEncode({
        "Subscriberid": subscriberId,
        "Operator": operatorCode,
        "Amount": amount
      }),
    );

    print('DTH Recharge response: ${response.body}');
    return response;
  }

  Future<http.Response> verifyIFSC(
    String authToken,
    String ifscCode,
    String accountNumber,
  ) async {
    http.Response response = await http.post(
      Uri.parse(Uri.encodeFull(APIConstants.ENDPOINT_VERIFY_IFSC)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00 ',
        'Authorization': 'Basic Vmltb3BheTpWaW1vcGF5QDIwMjA=',
        'A-Token': authToken,
      },
      body: jsonEncode({"Accountno": accountNumber, "IFSCCode": ifscCode}),
    );

    print('Verify IFSC response: ${response.body}');
    return response;
  }

  Future<http.Response> getCommissionReport(
      String authToken, String fromDate, String toDate, String? product) async {
    http.Response response = await http.post(
      Uri.parse(Uri.encodeFull(APIConstants.ENDPOINT_COMMISSION_REPORT)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00 ',
        'Authorization': 'Basic Vmltb3BheTpWaW1vcGF5QDIwMjA=',
        'A-Token': authToken,
      },
      body: jsonEncode(
          {'product': product, 'dateform': fromDate, 'dateto': toDate}),
    );

    print('Commission request : ${jsonEncode({
      'status': product,
      'dateform': fromDate,
      'dateto': toDate
    })}');
    print('Commission Report : ${response.body}');
    return response;
  }

  Future<http.Response> getRechargeReport(
      String authToken, String fromDate, String toDate, String? status) async {
    http.Response response = await http.post(
      Uri.parse(Uri.encodeFull(APIConstants.ENDPOINT_RECHARGE_REPORT)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00 ',
        'Authorization': 'Basic Vmltb3BheTpWaW1vcGF5QDIwMjA=',
        'A-Token': authToken,
      },
      body: jsonEncode(
          {'status': status, 'dateform': fromDate, 'dateto': toDate}),
    );

    print('Recharge Report : ${response.body}');
    return response;
  }

  Future<http.Response> getATMReportsScreen(
      String authToken, String fromDate, String toDate, String status) async {
    http.Response response = await http.post(
      Uri.parse(Uri.encodeFull(APIConstants.ENDPOINT_ATM_REPORT)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00 ',
        'Authorization': 'Basic Vmltb3BheTpWaW1vcGF5QDIwMjA=',
        'A-Token': authToken,
      },
      body: jsonEncode(
          {'status': status, 'dateform': fromDate, 'dateto': toDate}),
    );

    print('ATM Report : ${response.body}');
    return response;
  }

  Future<http.Response> fetchCMSBillers(String partnerId) async {
    String url =
        "https://apbuat.airtelbank.com:5050/v1/openCms/partner/$partnerId/billers/";
    http.Response response = await http
        .get(Uri.parse(Uri.encodeFull(url)), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Basic b2JjbXM6b2JjbXMxMzM3',
    });

    print('Fetch CMS Biller : ${response.body}');
    return response;
  }

  Future<http.Response> fetchBillerDetails(
      String partnerId, String? billerURL) async {
    String url =
        "https://apbuat.airtelbank.com:5050/v1/openCms/partner/$partnerId$billerURL";
    http.Response response = await http
        .get(Uri.parse(Uri.encodeFull(url)), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Basic b2JjbXM6b2JjbXMxMzM3',
    });

    print('Fetch Biller Details : ${response.body}');
    return response;
  }

  Future<http.Response> fetchBillDetails(
      String partnerId, String? billerURL, String keyValuePairs) async {
    String url =
        "https://apbuat.airtelbank.com:5050/v1/openCms/partner/$partnerId$billerURL/fetch";
    http.Response response = await http.post(Uri.parse(Uri.encodeFull(url)),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Basic b2JjbXM6b2JjbXMxMzM3',
        },
        body: keyValuePairs);

    print('Url : $url');
    print('Bill details request : $keyValuePairs');
    print('Fetch Bill Details : ${response.body}');
    return response;
  }

  Future<http.Response> payBill(
      String partnerId, String? billerURL, String keyValuePairs) async {
    String url =
        "https://apbuat.airtelbank.com:5050/v1/openCms/partner/$partnerId$billerURL/submit";
    http.Response response = await http.post(Uri.parse(Uri.encodeFull(url)),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Basic b2JjbXM6b2JjbXMxMzM3',
        },
        body: keyValuePairs);

    print('Url : $url');
    print('Pay bill request : $keyValuePairs');
    print('Pay Bill Details : ${response.body}');
    return response;
  }

  Future<http.Response> getVerifiedAccounts(
      String authToken, String fromDate, String toDate, String? status) async {
    http.Response response = await http.post(
        Uri.parse(Uri.encodeFull(APIConstants.ENDPOINT_DMT_VERIFIED_ACCOUTNS)),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00 ',
          'Authorization': 'Basic Vmltb3BheTpWaW1vcGF5QDIwMjA=',
          'A-Token': authToken,
        },
        body: jsonEncode(
            {'status': status, 'dateform': fromDate, 'dateto': toDate}));

    print('Request: ${jsonEncode({
      'status': status,
      'dateform': fromDate,
      'dateto': toDate
    })}');
    print('DMT Verified Accounts : ${response.body}');
    return response;
  }

  Future<http.Response> getDMTReports(
      String authToken, String fromDate, String toDate, String? status) async {
    http.Response response = await http.post(
        Uri.parse(Uri.encodeFull(APIConstants.ENDPOINT_DMT_REPORTS)),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00 ',
          'Authorization': 'Basic Vmltb3BheTpWaW1vcGF5QDIwMjA=',
          'A-Token': authToken,
        },
        body: jsonEncode(
            {'status': status, 'dateform': fromDate, 'dateto': toDate}));

    print('Request: ${jsonEncode({
      'status': status,
      'dateform': fromDate,
      'dateto': toDate
    })}');
    print('DMT Report : ${response.body}');
    return response;
  }

  Future<http.Response> getCommissionChart(String authToken) async {
    http.Response response = await http.post(
      Uri.parse(Uri.encodeFull(APIConstants.ENDPOINT_GET_COMMISSION_CHART)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
        'Authorization': 'Basic Vmltb3BheTpWaW1vcGF5QDIwMjA=',
        'A-Token': authToken,
      },
    );

    print('Commission chart : ${response.body}');
    return response;
  }

  Future<http.Response> transferToWallet(
      String authToken, String amount) async {
    http.Response response = await http.post(
        Uri.parse(Uri.encodeFull(APIConstants.ENDPOINT_TRANSFER_TO_WALLET)),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
          'Authorization': 'Basic Vmltb3BheTpWaW1vcGF5QDIwMjA=',
          'A-Token': authToken,
        },
        body: jsonEncode({'TransactionAmt': amount}));

    print('Transfer to wallet: ${response.body}');
    return response;
  }

  Future<http.Response> getAEPSToken() async {
    http.Response response = await http.post(
        Uri.parse(Uri.encodeFull(APIConstants.AEPS_TOKEN_FETCH)),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'bc_id': 'BC319061250',
          'phone1': '8145661425',
          'ip': '104.98.216.00',
          'userid': '814566',
          'saltkey': '8C3327E8D9D5CE419247DC3826806427',
          'secretkey': 'MH2503191003444694137MK'
        }));

    print('AEPS Token : ${response.body}');
    return response;
  }

  Future<http.Response> bbpsBillPay(
      String authToken,
      String refId,
      String? operator,
      String amount,
      String? operatorId,
      String txnId,
      bool status) async {
    http.Response response = await http.post(
      Uri.parse(Uri.encodeFull(APIConstants.ENDPOINT_BBPS_BILL_PAY)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00 ',
        'Authorization': 'Basic Vmltb3BheTpWaW1vcGF5QDIwMjA=',
        'A-Token': authToken,
      },
      body: jsonEncode({
        "Refno": refId,
        "Operator": operator,
        "Amount": amount,
        "Service": "Electricity Bill",
        "OperatorID": operatorId,
        "TxnId": txnId,
        "Status": status.toString()
      }),
    );

    print('BBPS bill pay response: ${response.body}');
    return response;
  }
}
