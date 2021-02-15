class PrepaidRechargeResponseModel {
  String error;
  PrepaidRechargeResponseData data;

  PrepaidRechargeResponseModel({this.error, this.data});

  PrepaidRechargeResponseModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    data = json['data'] != null
        ? new PrepaidRechargeResponseData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class PrepaidRechargeResponseData {
  int trnxId;
  String status;
  String operatorId;
  String message;
  String msg;

  PrepaidRechargeResponseData(
      {this.trnxId, this.status, this.operatorId, this.message, this.msg});

  PrepaidRechargeResponseData.fromJson(Map<String, dynamic> json) {
    trnxId = json['trnx_id'];
    status = json['status'];
    operatorId = json['operator_id'];
    message = json['message'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trnx_id'] = this.trnxId;
    data['status'] = this.status;
    data['operator_id'] = this.operatorId;
    data['message'] = this.message;
    data['msg'] = this.msg;
    return data;
  }
}
