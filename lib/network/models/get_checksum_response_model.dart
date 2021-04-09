class GetChecksumResponseModel {
  String message;
  bool status;
  GetChecksumResponseData data;

  GetChecksumResponseModel({this.message, this.status, this.data});

  GetChecksumResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = json['data'] != null
        ? new GetChecksumResponseData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class GetChecksumResponseData {
  String checksum;
  String orderid;

  GetChecksumResponseData({this.checksum, this.orderid});

  GetChecksumResponseData.fromJson(Map<String, dynamic> json) {
    checksum = json['checksum'];
    orderid = json['orderid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['checksum'] = this.checksum;
    data['orderid'] = this.orderid;
    return data;
  }
}
