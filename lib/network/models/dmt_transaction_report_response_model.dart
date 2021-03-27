class DMTTransactionsResponseModel {
  List<DMTReportResponseData> data;
  String message;
  bool status;

  DMTTransactionsResponseModel({this.data, this.message, this.status});

  DMTTransactionsResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<DMTReportResponseData>();
      json['data'].forEach((v) {
        data.add(new DMTReportResponseData.fromJson(v));
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

class DMTReportResponseData {
  String createDate;
  String pKId;
  Null accNumber;
  Null accName;
  Null status;
  Null ifsc;
  String amount;
  String pMode;
  Null uniqueReq;
  Null failureReson;
  Null beneficiaryId;
  Null narration;
  Null beneficiaryBranch;
  String beneficiaryName;
  String beneficiaryAccNo;
  String beneficiaryIFSC;
  Null serviceCharge;
  Null gsTAmt;

  DMTReportResponseData(
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

  DMTReportResponseData.fromJson(Map<String, dynamic> json) {
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
