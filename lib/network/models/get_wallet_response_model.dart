import 'get_wallet_response_data.dart';

class GetWalletsResponseModel {
  GetWalletResponseData data;
  String message;
  bool status;

  GetWalletsResponseModel({this.data, this.message, this.status});

  GetWalletsResponseModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null
        ? new GetWalletResponseData.fromJson(json['data'])
        : null;
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}
