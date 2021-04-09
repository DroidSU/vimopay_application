class CMSBillDetailsResponseMeta {
  String description;
  String status;
  String code;

  CMSBillDetailsResponseMeta({this.description, this.status, this.code});

  CMSBillDetailsResponseMeta.fromJson(Map<String, dynamic> json) {
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
