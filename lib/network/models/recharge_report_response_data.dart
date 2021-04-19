class RechargeReportResponseData {
  String? createDate;
  String? mobileNo;
  String? amount;
  String? trxnId;
  String? status;
  String? type;
  String? pK_Id;
  String? operatorName;

  RechargeReportResponseData(
      {this.createDate,
      this.mobileNo,
      this.amount,
      this.trxnId,
      this.status,
      this.type,
      this.pK_Id,
      this.operatorName});

  RechargeReportResponseData.fromJson(Map<String, dynamic> json) {
    createDate = json['createDate'];
    mobileNo = json['mobile_No'];
    amount = json['amount'];
    trxnId = json['trxn_Id'];
    status = json['status'];
    type = json['type'];
    pK_Id = json['pK_Id'];
    operatorName = json['operatorName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createDate'] = this.createDate;
    data['mobile_No'] = this.mobileNo;
    data['amount'] = this.amount;
    data['trxn_Id'] = this.trxnId;
    data['status'] = this.status;
    data['type'] = this.type;
    data['pK_Id'] = this.pK_Id;
    data['operatorName'] = this.operatorName;
    return data;
  }
}
