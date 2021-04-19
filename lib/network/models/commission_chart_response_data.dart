class CommissionChartResponseData {
  String? parentMenuName;
  String? serviceType;
  String? providerName;
  String? commisisontype;
  String? percentage;
  String? flatform;
  String? flatto;
  String? flatamnt;

  CommissionChartResponseData(
      {this.parentMenuName,
      this.serviceType,
      this.providerName,
      this.commisisontype,
      this.percentage,
      this.flatform,
      this.flatto,
      this.flatamnt});

  CommissionChartResponseData.fromJson(Map<String, dynamic> json) {
    parentMenuName = json['parentMenuName'];
    serviceType = json['serviceType'];
    providerName = json['providerName'];
    commisisontype = json['commisisontype'];
    percentage = json['percentage'];
    flatform = json['flatform'];
    flatto = json['flatto'];
    flatamnt = json['flatamnt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['parentMenuName'] = this.parentMenuName;
    data['serviceType'] = this.serviceType;
    data['providerName'] = this.providerName;
    data['commisisontype'] = this.commisisontype;
    data['percentage'] = this.percentage;
    data['flatform'] = this.flatform;
    data['flatto'] = this.flatto;
    data['flatamnt'] = this.flatamnt;
    return data;
  }
}
