class BBPSLoginFailedModel {
  String message;

  BBPSLoginFailedModel({this.message});

  BBPSLoginFailedModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    return data;
  }
}
