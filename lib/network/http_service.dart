import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vimopay_application/customs/api_constants.dart';

class HTTPService {
  Future<http.Response> loginUser(
      String mobile, String password, String deviceId) async {
    http.Response response =
        await http.post(Uri.encodeFull(APIConstants.ENDPOINT_LOGIN),
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

  Future<http.Response> changePassword(String mobile, String otp) async {
    http.Response response =
        await http.post(Uri.encodeFull(APIConstants.ENDPOINT_FORGOT_PASSWORD),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00 ',
              'Authorization': 'Basic Vmltb3BheTpWaW1vcGF5QDIwMjA=',
            },
            body: jsonEncode({
              "Mobile": mobile,
              "OTP": otp,
            }));

    print('Change Password response: ${response.body}');
    return response;
  }

  Future<http.Response> getWallets(String authToken) async {
    http.Response response = await http.get(
      Uri.encodeFull(APIConstants.ENDPOINT_GET_WALLETS),
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
          Uri.encodeFull(APIConstants.ENDPOINT_GET_BANNER),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
            'Authorization': 'Basic Vmltb3BheTpWaW1vcGF5QDIwMjA=',
            'A-Token': authToken,
          },
        )
        .timeout(Duration(minutes: 1))
        .catchError((error) => {print('Exception: ${error.toString()}')});

    print('Get Banner: ${response.body}');
    return response;
  }

  Future<http.Response> changeMobileNumber(
      String authToken, String mobileNumber, String otp) async {
    http.Response response = await http.post(
      Uri.encodeFull(APIConstants.ENDPOINT_CHANGE_MOBILE_NUMBER),
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
      String authToken, String emailAddress, String otp) async {
    http.Response response = await http.post(
      Uri.encodeFull(APIConstants.ENDPOINT_CHANGE_EMAIL_ADDRESS),
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
      String name,
      String address,
      String city,
      String state,
      String pincode,
      String aadharNumber,
      String panNumber,
      String gstNumber) async {
    http.Response response = await http.post(
      Uri.encodeFull(APIConstants.ENDPOINT_UPDATE_PROFILE_DETAILS),
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

  Future<http.Response> updateBankDetails(String authToken, String bankName,
      String accountNumber, String ifsc, String holderName) async {
    http.Response response = await http.post(
      Uri.encodeFull(APIConstants.ENDPOINT_UPDATE_BANK_DETAILS),
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
      Uri.encodeFull(APIConstants.ENDPOINT_GET_BANK_DETAILS),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00 ',
        'Authorization': 'Basic Vmltb3BheTpWaW1vcGF5QDIwMjA=',
        'A-Token': authToken,
      },
    );

    print('Bank Details response: ${response.body}');
    return response;
  }

  Future<http.Response> prepaidRecharge(
    String authToken,
    String mobileNumber,
    String operatorCode,
    String amount,
  ) async {
    http.Response response = await http.post(
      Uri.encodeFull(APIConstants.ENDPOINT_PREPAID_RECHARGE),
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
    String operatorCode,
    String amount,
  ) async {
    http.Response response = await http.post(
      Uri.encodeFull(APIConstants.ENDPOINT_DTH_RECHARGE),
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
      Uri.encodeFull(APIConstants.ENDPOINT_VERIFY_IFSC),
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
}
