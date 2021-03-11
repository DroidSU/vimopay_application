/*
 * Created by Sujoy Datta. Copyright (c) 2021. All rights reserved.
 *
 * To the person who is reading this..
 * When you finally understand how this works, please do explain it to me too at sujoydatta26@gmail.com
 * P.S.: In case you are planning to use this without mentioning me, you will be met with mean judgemental looks and sarcastic comments.
 */

class VerifiedAccountResponseModel {
  List<VerifiedAccountsResponseData> data;
  String message;
  bool status;

  VerifiedAccountResponseModel({this.data, this.message, this.status});

  VerifiedAccountResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<VerifiedAccountsResponseData>();
      json['data'].forEach((v) {
        data.add(new VerifiedAccountsResponseData.fromJson(v));
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

class VerifiedAccountsResponseData {
  String createDate;
  String pKId;
  String accNumber;
  String accName;
  String status;
  String ifsc;
  String amount;
  String pMode;
  String uniqueReq;
  String failureReson;
  String beneficiaryId;
  String narration;
  String beneficiaryBranch;
  String beneficiaryName;
  String beneficiaryAccNo;
  String beneficiaryIFSC;
  String serviceCharge;
  String gsTAmt;

  VerifiedAccountsResponseData(
      {this.createDate,
      this.pKId,
      this.accNumber,
      this.accName,
      this.status,
      this.ifsc,
      this.amount,
      this.pMode,
      this.uniqueReq,
      this.failureReson,
      this.beneficiaryId,
      this.narration,
      this.beneficiaryBranch,
      this.beneficiaryName,
      this.beneficiaryAccNo,
      this.beneficiaryIFSC,
      this.serviceCharge,
      this.gsTAmt});

  VerifiedAccountsResponseData.fromJson(Map<String, dynamic> json) {
    createDate = json['createDate'];
    pKId = json['pK_Id'];
    accNumber = json['accNumber'];
    accName = json['accName'];
    status = json['status'];
    ifsc = json['ifsc'];
    amount = json['amount'];
    pMode = json['p_Mode'];
    uniqueReq = json['unique_Req'];
    failureReson = json['failure_reson'];
    beneficiaryId = json['beneficiary_id'];
    narration = json['narration'];
    beneficiaryBranch = json['beneficiary_Branch'];
    beneficiaryName = json['beneficiary_Name'];
    beneficiaryAccNo = json['beneficiary_AccNo'];
    beneficiaryIFSC = json['beneficiary_IFSC'];
    serviceCharge = json['service_charge'];
    gsTAmt = json['gsT_amt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createDate'] = this.createDate;
    data['pK_Id'] = this.pKId;
    data['accNumber'] = this.accNumber;
    data['accName'] = this.accName;
    data['status'] = this.status;
    data['ifsc'] = this.ifsc;
    data['amount'] = this.amount;
    data['p_Mode'] = this.pMode;
    data['unique_Req'] = this.uniqueReq;
    data['failure_reson'] = this.failureReson;
    data['beneficiary_id'] = this.beneficiaryId;
    data['narration'] = this.narration;
    data['beneficiary_Branch'] = this.beneficiaryBranch;
    data['beneficiary_Name'] = this.beneficiaryName;
    data['beneficiary_AccNo'] = this.beneficiaryAccNo;
    data['beneficiary_IFSC'] = this.beneficiaryIFSC;
    data['service_charge'] = this.serviceCharge;
    data['gsT_amt'] = this.gsTAmt;
    return data;
  }
}
