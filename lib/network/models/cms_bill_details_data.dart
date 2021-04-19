class CMSBillDetailsResponseData {
  String? id;
  String? actionUrl;
  String? action;
  List<BillDetailsField>? fields;

  CMSBillDetailsResponseData(
      {this.id, this.actionUrl, this.action, this.fields});

  CMSBillDetailsResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    actionUrl = json['actionUrl'];
    action = json['action'];
    if (json['fields'] != null) {
      fields = <BillDetailsField>[];
      json['fields'].forEach((v) {
        fields!.add(new BillDetailsField.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['actionUrl'] = this.actionUrl;
    data['action'] = this.action;
    if (this.fields != null) {
      data['fields'] = this.fields!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BillDetailsField {
  String? id;
  String? formId;
  String? label;
  String? orderId;
  String? value;
  String? type;
  String? isEditable;
  String? isVisible;
  Validation? validation;
  String? postKey;
  String? url;
  String? actionUrl;
  String? isDynamic;
  String? parentId;
  String? isRequired;
  String? subLabel;
  String? identifier;
  String? subHeader;
  String? fieldLayout;
  String? smsLabel;
  String? isUniqueRef;

  BillDetailsField(
      {this.id,
      this.formId,
      this.label,
      this.orderId,
      this.value,
      this.type,
      this.isEditable,
      this.isVisible,
      this.validation,
      this.postKey,
      this.url,
      this.actionUrl,
      this.isDynamic,
      this.parentId,
      this.isRequired,
      this.subLabel,
      this.identifier,
      this.subHeader,
      this.fieldLayout,
      this.smsLabel,
      this.isUniqueRef});

  BillDetailsField.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    formId = json['formId'];
    label = json['label'];
    orderId = json['orderId'];
    value = json['value'];
    type = json['type'];
    isEditable = json['isEditable'];
    isVisible = json['isVisible'];
    validation = json['validation'] != null
        ? new Validation.fromJson(json['validation'])
        : null;
    postKey = json['postKey'];
    url = json['url'];
    actionUrl = json['actionUrl'];
    isDynamic = json['isDynamic'];
    parentId = json['parentId'];
    isRequired = json['isRequired'];
    subLabel = json['subLabel'];
    identifier = json['identifier'];
    subHeader = json['subHeader'];
    fieldLayout = json['fieldLayout'];
    smsLabel = json['smsLabel'];
    isUniqueRef = json['isUniqueRef'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['formId'] = this.formId;
    data['label'] = this.label;
    data['orderId'] = this.orderId;
    data['value'] = this.value;
    data['type'] = this.type;
    data['isEditable'] = this.isEditable;
    data['isVisible'] = this.isVisible;
    if (this.validation != null) {
      data['validation'] = this.validation!.toJson();
    }
    data['postKey'] = this.postKey;
    data['url'] = this.url;
    data['actionUrl'] = this.actionUrl;
    data['isDynamic'] = this.isDynamic;
    data['parentId'] = this.parentId;
    data['isRequired'] = this.isRequired;
    data['subLabel'] = this.subLabel;
    data['identifier'] = this.identifier;
    data['subHeader'] = this.subHeader;
    data['fieldLayout'] = this.fieldLayout;
    data['smsLabel'] = this.smsLabel;
    data['isUniqueRef'] = this.isUniqueRef;
    return data;
  }
}

class Validation {
  String? max;
  String? min;
  String? regex;
  String? maxValue;
  String? minValue;

  Validation({this.max, this.min, this.regex, this.maxValue, this.minValue});

  Validation.fromJson(Map<String, dynamic> json) {
    max = json['max'];
    min = json['min'];
    regex = json['regex'];
    maxValue = json['maxValue'];
    minValue = json['minValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['max'] = this.max;
    data['min'] = this.min;
    data['regex'] = this.regex;
    data['maxValue'] = this.maxValue;
    data['minValue'] = this.minValue;
    return data;
  }
}
