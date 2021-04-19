class PrepaidRechargeResponse {
  String? message;
  bool? status;

  PrepaidRechargeResponse({this.message, this.status});

  PrepaidRechargeResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}
