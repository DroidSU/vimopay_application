import 'atm_report_response_data.dart';

class ATMReportResponseModel {
  String message;
  bool status;
  List<ATMRechargeReportData> data;

  ATMReportResponseModel({this.message, this.status, this.data});

  ATMReportResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    if (json['data'] != null) {
      data = new List<ATMRechargeReportData>();
      json['data'].forEach((v) {
        data.add(new ATMRechargeReportData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
