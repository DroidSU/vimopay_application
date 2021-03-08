class BillerListResponseModel {
  String message;
  bool status;
  List<BillerListResponseData> data;

  BillerListResponseModel({this.message, this.status, this.data});

  BillerListResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    if (json['data'] != null) {
      data = new List<BillerListResponseData>();
      json['data'].forEach((v) {
        data.add(new BillerListResponseData.fromJson(v));
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

class BillerListResponseData {
  String createDate;
  var mobileNo;
  var amount;
  var trxnId;
  var status;
  var type;
  var serviceId;
  String cateName;
  String value;
  String field;
  var txnId;
  var operatorID;

  BillerListResponseData(
      {this.createDate,
      this.mobileNo,
      this.amount,
      this.trxnId,
      this.status,
      this.type,
      this.serviceId,
      this.cateName,
      this.value,
      this.field,
      this.txnId,
      this.operatorID});

  BillerListResponseData.fromJson(Map<String, dynamic> json) {
    createDate = json['createDate'];
    mobileNo = json['mobile_No'];
    amount = json['amount'];
    trxnId = json['trxn_Id'];
    status = json['status'];
    type = json['type'];
    serviceId = json['serviceId'];
    cateName = json['cateName'];
    value = json['value'];
    field = json['field'];
    txnId = json['txnId'];
    operatorID = json['operatorID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createDate'] = this.createDate;
    data['mobile_No'] = this.mobileNo;
    data['amount'] = this.amount;
    data['trxn_Id'] = this.trxnId;
    data['status'] = this.status;
    data['type'] = this.type;
    data['serviceId'] = this.serviceId;
    data['cateName'] = this.cateName;
    data['value'] = this.value;
    data['field'] = this.field;
    data['txnId'] = this.txnId;
    data['operatorID'] = this.operatorID;
    return data;
  }
}
