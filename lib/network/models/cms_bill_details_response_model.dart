import 'package:vimopay_application/network/models/cms_bill_details_data.dart';
import 'package:vimopay_application/network/models/cms_bill_details_meta.dart';

class CMSBillDetailsResponseModel {
  CMSBillDetailsResponseMeta? meta;
  CMSBillDetailsResponseData? data;

  CMSBillDetailsResponseModel({this.meta, this.data});

  CMSBillDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    meta = json['meta'] != null
        ? new CMSBillDetailsResponseMeta.fromJson(json['meta'])
        : null;
    data = json['data'] != null
        ? new CMSBillDetailsResponseData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
