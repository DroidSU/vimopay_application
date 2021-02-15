class BannerResponseData {
  String photo;
  String heading;
  String description;

  BannerResponseData({this.photo, this.heading, this.description});

  BannerResponseData.fromJson(Map<String, dynamic> json) {
    photo = json['photo'];
    heading = json['heading'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['photo'] = this.photo;
    data['heading'] = this.heading;
    data['description'] = this.description;
    return data;
  }
}
