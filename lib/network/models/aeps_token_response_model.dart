class AEPSTokenResponseModel {
  String message;
  String statusCode;
  String result;

  AEPSTokenResponseModel({this.message, this.statusCode, this.result});

  AEPSTokenResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['Message'];
    statusCode = json['StatusCode'];
    result = json['Result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Message'] = this.message;
    data['StatusCode'] = this.statusCode;
    data['Result'] = this.result;
    return data;
  }
}
