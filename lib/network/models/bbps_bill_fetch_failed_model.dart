class BBPSBillFetchFailed {
  String status;
  String message;
  String errorCode;

  BBPSBillFetchFailed({this.status, this.message, this.errorCode});

  BBPSBillFetchFailed.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    errorCode = json['errorCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['errorCode'] = this.errorCode;
    return data;
  }
}
