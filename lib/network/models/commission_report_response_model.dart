import 'commission_report_response_data.dart';

class CommissionReportResponseModel {
  String _message;
  bool _status;
  List<CommissionReportResponseData> _data;

  CommissionReportResponseModel(
      {String message, bool status, List<CommissionReportResponseData> data}) {
    this._message = message;
    this._status = status;
    this._data = data;
  }

  String get message => _message;
  set message(String message) => _message = message;
  bool get status => _status;
  set status(bool status) => _status = status;
  List<CommissionReportResponseData> get data => _data;
  set data(List<CommissionReportResponseData> data) => _data = data;

  CommissionReportResponseModel.fromJson(Map<String, dynamic> json) {
    _message = json['message'];
    _status = json['status'];
    if (json['data'] != null) {
      _data = new List<CommissionReportResponseData>();
      json['data'].forEach((v) {
        _data.add(new CommissionReportResponseData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this._message;
    data['status'] = this._status;
    if (this._data != null) {
      data['data'] = this._data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
