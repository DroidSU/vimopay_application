class GetWalletResponseData {
  String wBalance;
  String mBalance;
  String aBalance;

  GetWalletResponseData({this.wBalance, this.mBalance, this.aBalance});

  GetWalletResponseData.fromJson(Map<String, dynamic> json) {
    wBalance = json['wBalance'];
    mBalance = json['mBalance'];
    aBalance = json['aBalance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['wBalance'] = this.wBalance;
    data['mBalance'] = this.mBalance;
    data['aBalance'] = this.aBalance;
    return data;
  }
}
