class CommissionReportResponseData {
  String? _cratedate;
  String? _commissionAmount;
  String? _type;
  String? _comment;
  String? _product;

  CommissionReportResponseData(
      {String? cratedate,
      String? commissionAmount,
      String? type,
      String? comment,
      String? product}) {
    this._cratedate = cratedate;
    this._commissionAmount = commissionAmount;
    this._type = type;
    this._comment = comment;
    this._product = product;
  }

  String? get cratedate => _cratedate;
  set cratedate(String? cratedate) => _cratedate = cratedate;
  String? get commissionAmount => _commissionAmount;
  set commissionAmount(String? commissionAmount) =>
      _commissionAmount = commissionAmount;
  String? get type => _type;
  set type(String? type) => _type = type;
  String? get comment => _comment;
  set comment(String? comment) => _comment = comment;
  String? get product => _product;
  set product(String? product) => _product = product;

  CommissionReportResponseData.fromJson(Map<String, dynamic> json) {
    _cratedate = json['cratedate'];
    _commissionAmount = json['commissionAmount'];
    _type = json['type'];
    _comment = json['comment'];
    _product = json['product'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cratedate'] = this._cratedate;
    data['commissionAmount'] = this._commissionAmount;
    data['type'] = this._type;
    data['comment'] = this._comment;
    data['product'] = this._product;
    return data;
  }
}
