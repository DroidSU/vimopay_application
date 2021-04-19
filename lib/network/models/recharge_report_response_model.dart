import 'package:vimopay_application/network/models/recharge_report_response_data.dart';

class RechargeReportResponseModel {
  String? message;
  bool? status;
  List<RechargeReportResponseData>? data;

  RechargeReportResponseModel({this.message, this.status, this.data});

  RechargeReportResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    if (json['data'] != null) {
      data = <RechargeReportResponseData>[];
      json['data'].forEach((v) {
        data!.add(new RechargeReportResponseData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
