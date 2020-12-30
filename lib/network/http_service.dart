import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vimopay_application/customs/api_constants.dart';

class HTTPService {
  Future<http.Response> loginUser(String mobile, String password) async {
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

  Future<http.Response> changeMobileNumber(
      String authToken, String mobileNumber) async {
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
      }),
    );

    print('Change Mobile Number response: ${response.body}');
    return response;
  }

  Future<http.Response> changeEmailAddress(
      String authToken, String emailAddress) async {
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
      }),
    );

    print('Change Mobile Number response: ${response.body}');
    return response;
  }
}
