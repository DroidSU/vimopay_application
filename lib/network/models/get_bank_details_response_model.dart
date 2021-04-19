class GetBankDetailsResponseModel {
  String? message;
  bool? status;
  GetBankDetailsResponseData? data;

  GetBankDetailsResponseModel({this.message, this.status, this.data});

  GetBankDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = json['data'] != null
        ? new GetBankDetailsResponseData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class GetBankDetailsResponseData {
  String? bankname;
  String? acno;
  String? ifsc;
  String? acholder;

  GetBankDetailsResponseData(
      {this.bankname, this.acno, this.ifsc, this.acholder});

  GetBankDetailsResponseData.fromJson(Map<String, dynamic> json) {
    bankname = json['bankname'];
    acno = json['acno'];
    ifsc = json['ifsc'];
    acholder = json['acholder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bankname'] = this.bankname;
    data['acno'] = this.acno;
    data['ifsc'] = this.ifsc;
    data['acholder'] = this.acholder;
    return data;
  }
}
