class TransactionReportResponseModel {
  List<TransactionReportResponseData> data;
  String message;
  bool status;

  TransactionReportResponseModel({this.data, this.message, this.status});

  TransactionReportResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<TransactionReportResponseData>();
      json['data'].forEach((v) {
        data.add(new TransactionReportResponseData.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class TransactionReportResponseData {
  String createDate;
  String transactionType;
  String transactionId;
  String refno;
  String status;
  String amount;

  TransactionReportResponseData(
      {this.createDate,
      this.transactionType,
      this.transactionId,
      this.refno,
      this.status,
      this.amount});

  TransactionReportResponseData.fromJson(Map<String, dynamic> json) {
    createDate = json['createDate'];
    transactionType = json['transactionType'];
    transactionId = json['transactionId'];
    refno = json['refno'];
    status = json['status'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createDate'] = this.createDate;
    data['transactionType'] = this.transactionType;
    data['transactionId'] = this.transactionId;
    data['refno'] = this.refno;
    data['status'] = this.status;
    data['amount'] = this.amount;
    return data;
  }
}
