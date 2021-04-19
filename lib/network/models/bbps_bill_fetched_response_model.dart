class BBPSBillFetchResponseModel {
  String? refId;
  String? status;
  BBPSBillFetchResponseData? data;

  BBPSBillFetchResponseModel({this.refId, this.status, this.data});

  BBPSBillFetchResponseModel.fromJson(Map<String, dynamic> json) {
    refId = json['ref_id'];
    status = json['status'];
    data = json['data'] != null
        ? new BBPSBillFetchResponseData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ref_id'] = this.refId;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class BBPSBillFetchResponseData {
  BillerDetails? billerDetails;
  BillDetails? billDetails;

  BBPSBillFetchResponseData({this.billerDetails, this.billDetails});

  BBPSBillFetchResponseData.fromJson(Map<String, dynamic> json) {
    billerDetails = json['biller_details'] != null
        ? new BillerDetails.fromJson(json['biller_details'])
        : null;
    billDetails = json['bill_details'] != null
        ? new BillDetails.fromJson(json['bill_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.billerDetails != null) {
      data['biller_details'] = this.billerDetails!.toJson();
    }
    if (this.billDetails != null) {
      data['bill_details'] = this.billDetails!.toJson();
    }
    return data;
  }
}

class BillerDetails {
  String? billerId;

  BillerDetails({this.billerId});

  BillerDetails.fromJson(Map<String, dynamic> json) {
    billerId = json['biller_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['biller_id'] = this.billerId;
    return data;
  }
}

class BillDetails {
  String? customerName;
  var amount;
  String? dueDate;
  bool? editable;
  var minAmount;
  var maxAmount;
  List<MoreInfo>? moreInfo;

  BillDetails(
      {this.customerName,
      this.amount,
      this.dueDate,
      this.editable,
      this.minAmount,
      this.maxAmount,
      this.moreInfo});

  BillDetails.fromJson(Map<String, dynamic> json) {
    customerName = json['Name'];
    amount = json['amount'];
    dueDate = json['Due Date'];
    editable = json['editable'];
    minAmount = json['minAmount'];
    maxAmount = json['maxAmount'];
    if (json['more_info'] != null) {
      moreInfo = <MoreInfo>[];
      json['more_info'].forEach((v) {
        moreInfo!.add(new MoreInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.customerName;
    data['amount'] = this.amount;
    data['Due Date'] = this.dueDate;
    data['editable'] = this.editable;
    data['minAmount'] = this.minAmount;
    data['maxAmount'] = this.maxAmount;
    if (this.moreInfo != null) {
      data['more_info'] = this.moreInfo!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MoreInfo {
  String? label;
  String? value;

  MoreInfo({this.label, this.value});

  MoreInfo.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['value'] = this.value;
    return data;
  }
}
