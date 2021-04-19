class CommissionPlanResponseModel {
  String? message;
  bool? status;
  CommissionPlanResponseData? data;

  CommissionPlanResponseModel({this.message, this.status, this.data});

  CommissionPlanResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = json['data'] != null
        ? new CommissionPlanResponseData.fromJson(json['data'])
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

class CommissionPlanResponseData {
  String? pDF;

  CommissionPlanResponseData({this.pDF});

  CommissionPlanResponseData.fromJson(Map<String, dynamic> json) {
    pDF = json['PDF'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PDF'] = this.pDF;
    return data;
  }
}
