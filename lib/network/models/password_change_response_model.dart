import 'password_change_response_data.dart';

class PasswordChangeResponseModel {
  String? message;
  bool? status;
  PasswordChangeResponseData? data;

  PasswordChangeResponseModel({this.message, this.status, this.data});

  PasswordChangeResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = json['data'] != null
        ? new PasswordChangeResponseData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
