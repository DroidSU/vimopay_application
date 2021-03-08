class BillerDetailsResponseModel {
  BillerDetailsResponseData data;

  BillerDetailsResponseModel({this.data});

  BillerDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null
        ? new BillerDetailsResponseData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class BillerDetailsResponseData {
  Meta meta;
  List<Fields> fields;

  BillerDetailsResponseData({this.meta, this.fields});

  BillerDetailsResponseData.fromJson(Map<String, dynamic> json) {
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
    if (json['fields'] != null) {
      fields = new List<Fields>();
      json['fields'].forEach((v) {
        fields.add(new Fields.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.meta != null) {
      data['meta'] = this.meta.toJson();
    }
    if (this.fields != null) {
      data['fields'] = this.fields.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// class Form {
//   String id;
//   String actionUrl;
//   String action;
//   List<Fields> fields;
//
//   Form({this.id, this.actionUrl, this.action, this.fields});
//
//   Form.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     actionUrl = json['actionUrl'];
//     action = json['action'];
//     if (json['fields'] != null) {
//       fields = new List<Fields>();
//       json['fields'].forEach((v) {
//         fields.add(new Fields.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['actionUrl'] = this.actionUrl;
//     data['action'] = this.action;
//     if (this.fields != null) {
//       data['fields'] = this.fields.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

class Fields {
  String label;
  String orderId;
  String type;
  String value;
  String isEditable;
  String isVisible;
  Validation validation;
  String postKey;

  Fields(
      {this.label,
      this.orderId,
      this.type,
      this.value,
      this.isEditable,
      this.isVisible,
      this.validation,
      this.postKey});

  Fields.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    orderId = json['orderId'];
    type = json['type'];
    value = json['value'];
    isEditable = json['isEditable'];
    isVisible = json['isVisible'];
    validation = json['validation'] != null
        ? new Validation.fromJson(json['validation'])
        : null;
    postKey = json['postKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['orderId'] = this.orderId;
    data['type'] = this.type;
    data['value'] = this.value;
    data['isEditable'] = this.isEditable;
    data['isVisible'] = this.isVisible;
    if (this.validation != null) {
      data['validation'] = this.validation.toJson();
    }
    data['postKey'] = this.postKey;
    return data;
  }
}

class Validation {
  String regex;
  String minLength;
  String maxLength;
  String minValue;
  String maxValue;

  Validation(
      {this.regex,
      this.minLength,
      this.maxLength,
      this.minValue,
      this.maxValue});

  Validation.fromJson(Map<String, dynamic> json) {
    regex = json['regex'];
    minLength = json['minLength'];
    maxLength = json['maxLength'];
    minValue = json['minValue'];
    maxValue = json['maxValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['regex'] = this.regex;
    data['minLength'] = this.minLength;
    data['maxLength'] = this.maxLength;
    data['minValue'] = this.minValue;
    data['maxValue'] = this.maxValue;
    return data;
  }
}

class Meta {
  String description;
  String status;
  String code;
  String sessionId;

  Meta({this.description, this.status, this.code, this.sessionId});

  Meta.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    status = json['status'];
    code = json['code'];
    sessionId = json['sessionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['status'] = this.status;
    data['code'] = this.code;
    data['sessionId'] = this.sessionId;
    return data;
  }
}
