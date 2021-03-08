class MainTransactionsResponseModel {
  String message;
  bool status;
  List<MainTransactionResponseData> data;

  MainTransactionsResponseModel({this.message, this.status, this.data});

  MainTransactionsResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    if (json['data'] != null) {
      data = new List<MainTransactionResponseData>();
      json['data'].forEach((v) {
        data.add(new MainTransactionResponseData.fromJson(v));
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

class MainTransactionResponseData {
  String transactionType;
  String createDate;
  double transactionAmt;
  String extra1;
  int isStatus;
  String transactionId;
  String comment;

  MainTransactionResponseData(
      {this.transactionType,
      this.createDate,
      this.transactionAmt,
      this.extra1,
      this.isStatus,
      this.transactionId,
      this.comment});

  MainTransactionResponseData.fromJson(Map<String, dynamic> json) {
    transactionType = json['transactionType'];
    createDate = json['createDate'];
    transactionAmt = json['transactionAmt'];
    extra1 = json['extra1'];
    isStatus = json['isStatus'];
    transactionId = json['transactionId'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transactionType'] = this.transactionType;
    data['createDate'] = this.createDate;
    data['transactionAmt'] = this.transactionAmt;
    data['extra1'] = this.extra1;
    data['isStatus'] = this.isStatus;
    data['transactionId'] = this.transactionId;
    data['comment'] = this.comment;
    return data;
  }
}
