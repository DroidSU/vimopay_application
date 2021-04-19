class NoticeResponseModel {
  List<NoticeResponseData>? data;
  String? message;
  bool? status;

  NoticeResponseModel({this.data, this.message, this.status});

  NoticeResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <NoticeResponseData>[];
      json['data'].forEach((v) {
        data!.add(new NoticeResponseData.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class NoticeResponseData {
  String? heading;
  String? description;

  NoticeResponseData({this.heading, this.description});

  NoticeResponseData.fromJson(Map<String, dynamic> json) {
    heading = json['heading'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['heading'] = this.heading;
    data['description'] = this.description;
    return data;
  }
}
