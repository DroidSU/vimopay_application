class CMSBillersResponseModel {
  CMSBillersResponseData data;
  Meta meta;

  CMSBillersResponseModel({this.data, this.meta});

  CMSBillersResponseModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null
        ? new CMSBillersResponseData.fromJson(json['data'])
        : null;
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    if (this.meta != null) {
      data['meta'] = this.meta.toJson();
    }
    return data;
  }
}

class CMSBillersResponseData {
  List<Billers> billers;

  CMSBillersResponseData({this.billers});

  CMSBillersResponseData.fromJson(Map<String, dynamic> json) {
    if (json['billers'] != null) {
      billers = new List<Billers>();
      json['billers'].forEach((v) {
        billers.add(new Billers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.billers != null) {
      data['billers'] = this.billers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Billers {
  String name;
  String fetchUrl;
  String type;

  Billers({this.name, this.fetchUrl, this.type});

  Billers.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    fetchUrl = json['fetchUrl'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['fetchUrl'] = this.fetchUrl;
    data['type'] = this.type;
    return data;
  }
}

class Meta {
  String description;
  String status;
  String code;

  Meta({this.description, this.status, this.code});

  Meta.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    status = json['status'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['status'] = this.status;
    data['code'] = this.code;
    return data;
  }
}
