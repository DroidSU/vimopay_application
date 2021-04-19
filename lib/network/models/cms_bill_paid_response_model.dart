class CMSBillPaidResponseModel {
  CMSBillPaidMeta? meta;

  CMSBillPaidResponseModel({this.meta});

  CMSBillPaidResponseModel.fromJson(Map<String, dynamic> json) {
    meta = json['meta'] != null
        ? new CMSBillPaidMeta.fromJson(json['meta'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    return data;
  }
}

class CMSBillPaidMeta {
  String? code;
  String? description;
  String? status;

  CMSBillPaidMeta({this.code, this.description, this.status});

  CMSBillPaidMeta.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    description = json['description'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['description'] = this.description;
    data['status'] = this.status;
    return data;
  }
}
