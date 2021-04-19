class AdminListResponseModel {
  String? message;
  bool? status;
  List<AdminListResponseData>? data;

  AdminListResponseModel({this.message, this.status, this.data});

  AdminListResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    if (json['data'] != null) {
      data = <AdminListResponseData>[];
      json['data'].forEach((v) {
        data!.add(new AdminListResponseData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AdminListResponseData {
  int? adminid;
  String? adminname;
  String? admintype;

  AdminListResponseData({this.adminid, this.adminname, this.admintype});

  AdminListResponseData.fromJson(Map<String, dynamic> json) {
    adminid = json['adminid'];
    adminname = json['adminname'];
    admintype = json['admintype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['adminid'] = this.adminid;
    data['adminname'] = this.adminname;
    data['admintype'] = this.admintype;
    return data;
  }
}
