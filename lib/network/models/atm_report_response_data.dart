class ATMRechargeReportData {
  String createDate;
  String pkAEPSWallet;
  String transactionAmt;
  String transactionType;
  String nowBalance;
  String comment;
  String mobileNo;
  String amount;
  String trxnId;
  String status;
  String type;

  ATMRechargeReportData(
      {this.createDate,
      this.pkAEPSWallet,
      this.transactionAmt,
      this.transactionType,
      this.nowBalance,
      this.comment,
      this.mobileNo,
      this.amount,
      this.trxnId,
      this.status,
      this.type});

  ATMRechargeReportData.fromJson(Map<String, dynamic> json) {
    createDate = json['createDate'];
    pkAEPSWallet = json['pk_AEPSWallet'];
    transactionAmt = json['transactionAmt'];
    transactionType = json['transactionType'];
    nowBalance = json['nowBalance'];
    comment = json['comment'];
    mobileNo = json['mobile_No'];
    amount = json['amount'];
    trxnId = json['trxn_Id'];
    status = json['status'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createDate'] = this.createDate;
    data['pk_AEPSWallet'] = this.pkAEPSWallet;
    data['transactionAmt'] = this.transactionAmt;
    data['transactionType'] = this.transactionType;
    data['nowBalance'] = this.nowBalance;
    data['comment'] = this.comment;
    data['mobile_No'] = this.mobileNo;
    data['amount'] = this.amount;
    data['trxn_Id'] = this.trxnId;
    data['status'] = this.status;
    data['type'] = this.type;
    return data;
  }
}
