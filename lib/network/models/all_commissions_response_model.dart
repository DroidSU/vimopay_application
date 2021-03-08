class AllCommissionsResponseModel {
  String message;
  bool status;
  AllCommissionsResponseData data;

  AllCommissionsResponseModel({this.message, this.status, this.data});

  AllCommissionsResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = json['data'] != null
        ? new AllCommissionsResponseData.fromJson(json['data'])
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

class AllCommissionsResponseData {
  String youearned;
  String transcationcount;
  String totaltxn;

  AllCommissionsResponseData(
      {this.youearned, this.transcationcount, this.totaltxn});

  AllCommissionsResponseData.fromJson(Map<String, dynamic> json) {
    youearned = json['youearned'];
    transcationcount = json['transcationcount'];
    totaltxn = json['totaltxn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['youearned'] = this.youearned;
    data['transcationcount'] = this.transcationcount;
    data['totaltxn'] = this.totaltxn;
    return data;
  }
}
