class MoneyTransferRequestData {
  Data? data;

  MoneyTransferRequestData({this.data});

  MoneyTransferRequestData.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  TransferRequest? transferRequest;

  Data({this.transferRequest});

  Data.fromJson(Map<String, dynamic> json) {
    transferRequest = json['transfer_request'] != null
        ? new TransferRequest.fromJson(json['transfer_request'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.transferRequest != null) {
      data['transfer_request'] = this.transferRequest!.toJson();
    }
    return data;
  }
}

class TransferRequest {
  String? id;
  String? uniqueRequestNumber;
  String? failureReason;
  String? beneficiaryId;
  String? createdAt;
  String? uniqueTransactionReference;
  String? paymentMode;
  double? amount;
  String? currency;
  String? narration;
  String? beneficiaryBankName;
  String? beneficiaryAccountName;
  String? beneficiaryAccountNumber;
  String? beneficiaryAccountIfsc;
  Null beneficiaryUpiHandle;
  double? serviceCharge;
  double? gstAmount;
  double? serviceChargeWithGst;
  String? status;
  bool? queueOnLowBalance;
  String? transferDate;
  Null udf1;
  Null udf2;
  Null udf3;
  Null udf4;
  Null udf5;
  Null createdBy;

  TransferRequest(
      {this.id,
      this.uniqueRequestNumber,
      this.failureReason,
      this.beneficiaryId,
      this.createdAt,
      this.uniqueTransactionReference,
      this.paymentMode,
      this.amount,
      this.currency,
      this.narration,
      this.beneficiaryBankName,
      this.beneficiaryAccountName,
      this.beneficiaryAccountNumber,
      this.beneficiaryAccountIfsc,
      this.beneficiaryUpiHandle,
      this.serviceCharge,
      this.gstAmount,
      this.serviceChargeWithGst,
      this.status,
      this.queueOnLowBalance,
      this.transferDate,
      this.udf1,
      this.udf2,
      this.udf3,
      this.udf4,
      this.udf5,
      this.createdBy});

  TransferRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uniqueRequestNumber = json['unique_request_number'];
    failureReason = json['failure_reason'];
    beneficiaryId = json['beneficiary_id'];
    createdAt = json['created_at'];
    uniqueTransactionReference = json['unique_transaction_reference'];
    paymentMode = json['payment_mode'];
    amount = json['amount'];
    currency = json['currency'];
    narration = json['narration'];
    beneficiaryBankName = json['beneficiary_bank_name'];
    beneficiaryAccountName = json['beneficiary_account_name'];
    beneficiaryAccountNumber = json['beneficiary_account_number'];
    beneficiaryAccountIfsc = json['beneficiary_account_ifsc'];
    beneficiaryUpiHandle = json['beneficiary_upi_handle'];
    serviceCharge = json['service_charge'];
    gstAmount = json['gst_amount'];
    serviceChargeWithGst = json['service_charge_with_gst'];
    status = json['status'];
    queueOnLowBalance = json['queue_on_low_balance'];
    transferDate = json['transfer_date'];
    udf1 = json['udf1'];
    udf2 = json['udf2'];
    udf3 = json['udf3'];
    udf4 = json['udf4'];
    udf5 = json['udf5'];
    createdBy = json['created_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['unique_request_number'] = this.uniqueRequestNumber;
    data['failure_reason'] = this.failureReason;
    data['beneficiary_id'] = this.beneficiaryId;
    data['created_at'] = this.createdAt;
    data['unique_transaction_reference'] = this.uniqueTransactionReference;
    data['payment_mode'] = this.paymentMode;
    data['amount'] = this.amount;
    data['currency'] = this.currency;
    data['narration'] = this.narration;
    data['beneficiary_bank_name'] = this.beneficiaryBankName;
    data['beneficiary_account_name'] = this.beneficiaryAccountName;
    data['beneficiary_account_number'] = this.beneficiaryAccountNumber;
    data['beneficiary_account_ifsc'] = this.beneficiaryAccountIfsc;
    data['beneficiary_upi_handle'] = this.beneficiaryUpiHandle;
    data['service_charge'] = this.serviceCharge;
    data['gst_amount'] = this.gstAmount;
    data['service_charge_with_gst'] = this.serviceChargeWithGst;
    data['status'] = this.status;
    data['queue_on_low_balance'] = this.queueOnLowBalance;
    data['transfer_date'] = this.transferDate;
    data['udf1'] = this.udf1;
    data['udf2'] = this.udf2;
    data['udf3'] = this.udf3;
    data['udf4'] = this.udf4;
    data['udf5'] = this.udf5;
    data['created_by'] = this.createdBy;
    return data;
  }
}
