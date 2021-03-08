// class BBPSOperatorListResponseModel {
//   String status;
//   BBPSOperatorResponseData data;
//
//   BBPSOperatorListResponseModel({this.status, this.data});
//
//   BBPSOperatorListResponseModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     data = json['data'] != null
//         ? new BBPSOperatorResponseData.fromJson(json['data'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     if (this.data != null) {
//       data['data'] = this.data.toJson();
//     }
//     return data;
//   }
// }
//
// class BBPSOperatorResponseData {
//   List<BillersDetails> billersDetails;
//
//   BBPSOperatorResponseData({this.billersDetails});
//
//   BBPSOperatorResponseData.fromJson(Map<String, dynamic> json) {
//     if (json['billers_details'] != null) {
//       billersDetails = new List<BillersDetails>();
//       json['billers_details'].forEach((v) {
//         billersDetails.add(new BillersDetails.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.billersDetails != null) {
//       data['billers_details'] =
//           this.billersDetails.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class BillersDetails {
//   String billerId;
//   String billerName;
//   String billerCategory;
//   List<BillDetailsInputParameters> billDetailsInputParameters;
//   int hasGrouping;
//
//   BillersDetails(
//       {this.billerId,
//       this.billerName,
//       this.billerCategory,
//       this.billDetailsInputParameters,
//       this.hasGrouping});
//
//   BillersDetails.fromJson(Map<String, dynamic> json) {
//     billerId = json['biller_id'];
//     billerName = json['biller_name'];
//     billerCategory = json['biller_category'];
//     if (json['bill_details_input_parameters'] != null) {
//       billDetailsInputParameters = new List<BillDetailsInputParameters>();
//       json['bill_details_input_parameters'].forEach((v) {
//         billDetailsInputParameters
//             .add(new BillDetailsInputParameters.fromJson(v));
//       });
//     }
//     hasGrouping = json['has_grouping'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['biller_id'] = this.billerId;
//     data['biller_name'] = this.billerName;
//     data['biller_category'] = this.billerCategory;
//     if (this.billDetailsInputParameters != null) {
//       data['bill_details_input_parameters'] =
//           this.billDetailsInputParameters.map((v) => v.toJson()).toList();
//     }
//     data['has_grouping'] = this.hasGrouping;
//     return data;
//   }
// }
//
// class BillDetailsInputParameters {
//   String fieldName;
//   String regExp;
//   String displayValue;
//   bool required;
//   Values values;
//
//   BillDetailsInputParameters(
//       {this.fieldName,
//       this.regExp,
//       this.displayValue,
//       this.required,
//       this.values});
//
//   BillDetailsInputParameters.fromJson(Map<String, dynamic> json) {
//     fieldName = json['field_name'];
//     regExp = json['reg_exp'];
//     displayValue = json['display_value'];
//     required = json['required'];
//     values =
//         json['values'] != null ? new Values.fromJson(json['values']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['field_name'] = this.fieldName;
//     data['reg_exp'] = this.regExp;
//     data['display_value'] = this.displayValue;
//     data['required'] = this.required;
//     if (this.values != null) {
//       data['values'] = this.values.toJson();
//     }
//     return data;
//   }
// }
//
// class Values {
//   GroupingHeirarchy groupingHeirarchy;
//   List<String> groupingKeys;
//
//   Values({this.groupingHeirarchy, this.groupingKeys});
//
//   Values.fromJson(Map<String, dynamic> json) {
//     groupingHeirarchy = json['groupingHeirarchy'] != null
//         ? new GroupingHeirarchy.fromJson(json['groupingHeirarchy'])
//         : null;
//     groupingKeys = json['groupingKeys'].cast<String>();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.groupingHeirarchy != null) {
//       data['groupingHeirarchy'] = this.groupingHeirarchy.toJson();
//     }
//     data['groupingKeys'] = this.groupingKeys;
//     return data;
//   }
// }
//
// class GroupingHeirarchy {
//   Hajipur hajipur;
//   Hajipur begusarai;
//   ChapraEast chapraEast;
//   Samastipur samastipur;
//   Bettiah bettiah;
//   Hajipur sheohar;
//   MujaffarpurRURAL mujaffarpurRURAL;
//   Hajipur gopalganj;
//   Kishanganj kishanganj;
//   Siwan siwan;
//   Katihar katihar;
//   DarbhangaUrban darbhangaUrban;
//   DarbhangaRural darbhangaRural;
//   Forbesganj forbesganj;
//
//   GroupingHeirarchy(
//       {this.hajipur,
//       this.begusarai,
//       this.chapraEast,
//       this.samastipur,
//       this.bettiah,
//       this.sheohar,
//       this.mujaffarpurRURAL,
//       this.gopalganj,
//       this.kishanganj,
//       this.siwan,
//       this.katihar,
//       this.darbhangaUrban,
//       this.darbhangaRural,
//       this.forbesganj});
//
//   GroupingHeirarchy.fromJson(Map<String, dynamic> json) {
//     hajipur =
//         json['Hajipur'] != null ? new Hajipur.fromJson(json['Hajipur']) : null;
//     begusarai = json['Begusarai'] != null
//         ? new Hajipur.fromJson(json['Begusarai'])
//         : null;
//     chapraEast = json['Chapra (East)'] != null
//         ? new ChapraEast.fromJson(json['Chapra (East)'])
//         : null;
//     samastipur = json['Samastipur'] != null
//         ? new Samastipur.fromJson(json['Samastipur'])
//         : null;
//     bettiah =
//         json['Bettiah'] != null ? new Bettiah.fromJson(json['Bettiah']) : null;
//     sheohar =
//         json['Sheohar'] != null ? new Hajipur.fromJson(json['Sheohar']) : null;
//     mujaffarpurRURAL = json['Mujaffarpur (RURAL)'] != null
//         ? new MujaffarpurRURAL.fromJson(json['Mujaffarpur (RURAL)'])
//         : null;
//     gopalganj = json['Gopalganj'] != null
//         ? new Hajipur.fromJson(json['Gopalganj'])
//         : null;
//     kishanganj = json['Kishanganj'] != null
//         ? new Kishanganj.fromJson(json['Kishanganj'])
//         : null;
//     siwan = json['Siwan'] != null ? new Siwan.fromJson(json['Siwan']) : null;
//     katihar =
//         json['Katihar'] != null ? new Katihar.fromJson(json['Katihar']) : null;
//     darbhangaUrban = json['Darbhanga (Urban)'] != null
//         ? new DarbhangaUrban.fromJson(json['Darbhanga (Urban)'])
//         : null;
//     darbhangaRural = json['Darbhanga (Rural)'] != null
//         ? new DarbhangaRural.fromJson(json['Darbhanga (Rural)'])
//         : null;
//     forbesganj = json['Forbesganj'] != null
//         ? new Forbesganj.fromJson(json['Forbesganj'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.hajipur != null) {
//       data['Hajipur'] = this.hajipur.toJson();
//     }
//     if (this.begusarai != null) {
//       data['Begusarai'] = this.begusarai.toJson();
//     }
//     if (this.chapraEast != null) {
//       data['Chapra (East)'] = this.chapraEast.toJson();
//     }
//     if (this.samastipur != null) {
//       data['Samastipur'] = this.samastipur.toJson();
//     }
//     if (this.bettiah != null) {
//       data['Bettiah'] = this.bettiah.toJson();
//     }
//     if (this.sheohar != null) {
//       data['Sheohar'] = this.sheohar.toJson();
//     }
//     if (this.mujaffarpurRURAL != null) {
//       data['Mujaffarpur (RURAL)'] = this.mujaffarpurRURAL.toJson();
//     }
//     if (this.gopalganj != null) {
//       data['Gopalganj'] = this.gopalganj.toJson();
//     }
//     if (this.kishanganj != null) {
//       data['Kishanganj'] = this.kishanganj.toJson();
//     }
//     if (this.siwan != null) {
//       data['Siwan'] = this.siwan.toJson();
//     }
//     if (this.katihar != null) {
//       data['Katihar'] = this.katihar.toJson();
//     }
//     if (this.darbhangaUrban != null) {
//       data['Darbhanga (Urban)'] = this.darbhangaUrban.toJson();
//     }
//     if (this.darbhangaRural != null) {
//       data['Darbhanga (Rural)'] = this.darbhangaRural.toJson();
//     }
//     if (this.forbesganj != null) {
//       data['Forbesganj'] = this.forbesganj.toJson();
//     }
//     return data;
//   }
// }
//
// class HajipurGroup {
//   List<Hajipur> hajipur;
//   List<Mahua> mahua;
//
//   HajipurGroup({this.hajipur, this.mahua});
//
//   HajipurGroup.fromJson(Map<String, dynamic> json) {
//     if (json['Hajipur'] != null) {
//       hajipur = new List<Hajipur>();
//       json['Hajipur'].forEach((v) {
//         hajipur.add(new Hajipur.fromJson(v));
//       });
//     }
//     if (json['Mahua'] != null) {
//       mahua = new List<Mahua>();
//       json['Mahua'].forEach((v) {
//         mahua.add(new Mahua.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.hajipur != null) {
//       data['Hajipur'] = this.hajipur.map((v) => v.toJson()).toList();
//     }
//     if (this.mahua != null) {
//       data['Mahua'] = this.mahua.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Hajipur {
//   int required;
//   String fieldName;
//   String regExp;
//   String displayValue;
//
//   Hajipur({this.required, this.fieldName, this.regExp, this.displayValue});
//
//   Hajipur.fromJson(Map<String, dynamic> json) {
//     required = json['required'];
//     fieldName = json['field_name'];
//     regExp = json['reg_exp'];
//     displayValue = json['display_value'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['required'] = this.required;
//     data['field_name'] = this.fieldName;
//     data['reg_exp'] = this.regExp;
//     data['display_value'] = this.displayValue;
//     return data;
//   }
// }
//
// class Begusarai {
//   List<Begusarai> begusarai;
//
//   Begusarai({this.begusarai});
//
//   Begusarai.fromJson(Map<String, dynamic> json) {
//     if (json['Begusarai'] != null) {
//       begusarai = new List<Begusarai>();
//       json['Begusarai'].forEach((v) {
//         begusarai.add(new Begusarai.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.begusarai != null) {
//       data['Begusarai'] = this.begusarai.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class ChapraEast {
//   List<Sonepur> sonepur;
//   List<Marhaurah> marhaurah;
//
//   ChapraEast({this.sonepur, this.marhaurah});
//
//   ChapraEast.fromJson(Map<String, dynamic> json) {
//     if (json['Sonepur'] != null) {
//       sonepur = new List<Sonepur>();
//       json['Sonepur'].forEach((v) {
//         sonepur.add(new Sonepur.fromJson(v));
//       });
//     }
//     if (json['Marhaurah'] != null) {
//       marhaurah = new List<Marhaurah>();
//       json['Marhaurah'].forEach((v) {
//         marhaurah.add(new Marhaurah.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.sonepur != null) {
//       data['Sonepur'] = this.sonepur.map((v) => v.toJson()).toList();
//     }
//     if (this.marhaurah != null) {
//       data['Marhaurah'] = this.marhaurah.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Samastipur {
//   List<Kalyanpur> kalyanpur;
//
//   Samastipur({this.kalyanpur});
//
//   Samastipur.fromJson(Map<String, dynamic> json) {
//     if (json['Kalyanpur'] != null) {
//       kalyanpur = new List<Kalyanpur>();
//       json['Kalyanpur'].forEach((v) {
//         kalyanpur.add(new Kalyanpur.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.kalyanpur != null) {
//       data['Kalyanpur'] = this.kalyanpur.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Bettiah {
//   List<Narkatiaganj> narkatiaganj;
//
//   Bettiah({this.narkatiaganj});
//
//   Bettiah.fromJson(Map<String, dynamic> json) {
//     if (json['Narkatiaganj'] != null) {
//       narkatiaganj = new List<Narkatiaganj>();
//       json['Narkatiaganj'].forEach((v) {
//         narkatiaganj.add(new Narkatiaganj.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.narkatiaganj != null) {
//       data['Narkatiaganj'] = this.narkatiaganj.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Sheohar {
//   List<Sheohar> sheohar;
//
//   Sheohar({this.sheohar});
//
//   Sheohar.fromJson(Map<String, dynamic> json) {
//     if (json['Sheohar'] != null) {
//       sheohar = new List<Sheohar>();
//       json['Sheohar'].forEach((v) {
//         sheohar.add(new Sheohar.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.sheohar != null) {
//       data['Sheohar'] = this.sheohar.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class MujaffarpurRURAL {
//   List<Saraiya> saraiya;
//   List<Motipur> motipur;
//
//   MujaffarpurRURAL({this.saraiya, this.motipur});
//
//   MujaffarpurRURAL.fromJson(Map<String, dynamic> json) {
//     if (json['Saraiya'] != null) {
//       saraiya = new List<Saraiya>();
//       json['Saraiya'].forEach((v) {
//         saraiya.add(new Saraiya.fromJson(v));
//       });
//     }
//     if (json['Motipur'] != null) {
//       motipur = new List<Motipur>();
//       json['Motipur'].forEach((v) {
//         motipur.add(new Motipur.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.saraiya != null) {
//       data['Saraiya'] = this.saraiya.map((v) => v.toJson()).toList();
//     }
//     if (this.motipur != null) {
//       data['Motipur'] = this.motipur.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Motipur {
//   int required;
//   String fieldName;
//   String displayValue;
//
//   Motipur({this.required, this.fieldName, this.displayValue});
//
//   Motipur.fromJson(Map<String, dynamic> json) {
//     required = json['required'];
//     fieldName = json['field_name'];
//     displayValue = json['display_value'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['required'] = this.required;
//     data['field_name'] = this.fieldName;
//     data['display_value'] = this.displayValue;
//     return data;
//   }
// }
//
// class Gopalganj {
//   List<Mirganj> mirganj;
//   List<Gopalganj> gopalganj;
//   List<Barauli> barauli;
//
//   Gopalganj({this.mirganj, this.gopalganj, this.barauli});
//
//   Gopalganj.fromJson(Map<String, dynamic> json) {
//     if (json['Mirganj'] != null) {
//       mirganj = new List<Mirganj>();
//       json['Mirganj'].forEach((v) {
//         mirganj.add(new Mirganj.fromJson(v));
//       });
//     }
//     if (json['Gopalganj'] != null) {
//       gopalganj = new List<Gopalganj>();
//       json['Gopalganj'].forEach((v) {
//         gopalganj.add(new Gopalganj.fromJson(v));
//       });
//     }
//     if (json['Barauli'] != null) {
//       barauli = new List<Barauli>();
//       json['Barauli'].forEach((v) {
//         barauli.add(new Barauli.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.mirganj != null) {
//       data['Mirganj'] = this.mirganj.map((v) => v.toJson()).toList();
//     }
//     if (this.gopalganj != null) {
//       data['Gopalganj'] = this.gopalganj.map((v) => v.toJson()).toList();
//     }
//     if (this.barauli != null) {
//       data['Barauli'] = this.barauli.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Kishanganj {
//   List<Bahadurganj> bahadurganj;
//
//   Kishanganj({this.bahadurganj});
//
//   Kishanganj.fromJson(Map<String, dynamic> json) {
//     if (json['Bahadurganj'] != null) {
//       bahadurganj = new List<Bahadurganj>();
//       json['Bahadurganj'].forEach((v) {
//         bahadurganj.add(new Bahadurganj.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.bahadurganj != null) {
//       data['Bahadurganj'] = this.bahadurganj.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Siwan {
//   List<Mairwa> mairwa;
//
//   Siwan({this.mairwa});
//
//   Siwan.fromJson(Map<String, dynamic> json) {
//     if (json['Mairwa'] != null) {
//       mairwa = new List<Mairwa>();
//       json['Mairwa'].forEach((v) {
//         mairwa.add(new Mairwa.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.mairwa != null) {
//       data['Mairwa'] = this.mairwa.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Mairwa {
//   int required;
//   String field_name;
//   String reg_exp;
//   String display_value;
//
//   Mairwa({this.required, this.field_name, this.reg_exp, this.display_value});
//
//   Mairwa.fromJson(Map<String, dynamic> json) {
//     required = json['required'];
//     field_name = json['field_name'];
//     reg_exp = json['reg_exp'];
//     display_value = json['display_value'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['required'] = this.required;
//     data['field_name'] = this.field_name;
//     data['reg_exp'] = this.reg_exp;
//     data['display_value'] = this.display_value;
//
//     return data;
//   }
// }
//
// class Katihar {
//   List<Barsoi> barsoi;
//   List<KatiharRural> katiharRural;
//
//   Katihar({this.barsoi, this.katiharRural});
//
//   Katihar.fromJson(Map<String, dynamic> json) {
//     if (json['Barsoi'] != null) {
//       barsoi = new List<Barsoi>();
//       json['Barsoi'].forEach((v) {
//         barsoi.add(new Barsoi.fromJson(v));
//       });
//     }
//     if (json['Katihar(Rural)'] != null) {
//       katiharRural = new List<KatiharRural>();
//       json['Katihar(Rural)'].forEach((v) {
//         katiharRural.add(new KatiharRural.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.barsoi != null) {
//       data['Barsoi'] = this.barsoi.map((v) => v.toJson()).toList();
//     }
//     if (this.katiharRural != null) {
//       data['Katihar(Rural)'] =
//           this.katiharRural.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class KatiharRural {
//   int required;
//   String field_name;
//   String reg_exp;
//   String display_value;
//
//   KatiharRural(
//       {this.required, this.field_name, this.reg_exp, this.display_value});
//
//   KatiharRural.fromJson(Map<String, dynamic> json) {
//     required = json['required'];
//     field_name = json['field_name'];
//     reg_exp = json['reg_exp'];
//     display_value = json['display_value'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['required'] = this.required;
//     data['field_name'] = this.field_name;
//     data['reg_exp'] = this.reg_exp;
//     data['display_value'] = this.display_value;
//
//     return data;
//   }
// }
//
// class Barsoi {
//   int required;
//   String field_name;
//   String reg_exp;
//   String display_value;
//
//   Barsoi({this.required, this.field_name, this.reg_exp, this.display_value});
//
//   Barsoi.fromJson(Map<String, dynamic> json) {
//     required = json['required'];
//     field_name = json['field_name'];
//     reg_exp = json['reg_exp'];
//     display_value = json['display_value'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['required'] = this.required;
//     data['field_name'] = this.field_name;
//     data['reg_exp'] = this.reg_exp;
//     data['display_value'] = this.display_value;
//
//     return data;
//   }
// }
//
// class DarbhangaUrban {
//   List<Laheriasarai> laheriasarai;
//
//   DarbhangaUrban({this.laheriasarai});
//
//   DarbhangaUrban.fromJson(Map<String, dynamic> json) {
//     if (json['Laheriasarai'] != null) {
//       laheriasarai = new List<Laheriasarai>();
//       json['Laheriasarai'].forEach((v) {
//         laheriasarai.add(new Laheriasarai.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.laheriasarai != null) {
//       data['Laheriasarai'] = this.laheriasarai.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Laheriasarai {
//   int required;
//   String field_name;
//   String reg_exp;
//   String display_value;
//
//   Laheriasarai(
//       {this.required, this.field_name, this.reg_exp, this.display_value});
//
//   Laheriasarai.fromJson(Map<String, dynamic> json) {
//     required = json['required'];
//     field_name = json['field_name'];
//     reg_exp = json['reg_exp'];
//     display_value = json['display_value'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['required'] = this.required;
//     data['field_name'] = this.field_name;
//     data['reg_exp'] = this.reg_exp;
//     data['display_value'] = this.display_value;
//
//     return data;
//   }
// }
//
// class DarbhangaRural {
//   List<Sakri> sakri;
//
//   DarbhangaRural({this.sakri});
//
//   DarbhangaRural.fromJson(Map<String, dynamic> json) {
//     if (json['Sakri'] != null) {
//       sakri = new List<Sakri>();
//       json['Sakri'].forEach((v) {
//         sakri.add(new Sakri.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.sakri != null) {
//       data['Sakri'] = this.sakri.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Sakri {
//   int required;
//   String field_name;
//   String reg_exp;
//   String display_value;
//
//   Sakri({this.required, this.field_name, this.reg_exp, this.display_value});
//
//   Sakri.fromJson(Map<String, dynamic> json) {
//     required = json['required'];
//     field_name = json['field_name'];
//     reg_exp = json['reg_exp'];
//     display_value = json['display_value'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['required'] = this.required;
//     data['field_name'] = this.field_name;
//     data['reg_exp'] = this.reg_exp;
//     data['display_value'] = this.display_value;
//
//     return data;
//   }
// }
//
// class Forbesganj {
//   List<Farbisganj> farbisganj;
//
//   Forbesganj({this.farbisganj});
//
//   Forbesganj.fromJson(Map<String, dynamic> json) {
//     if (json['Farbisganj'] != null) {
//       farbisganj = new List<Farbisganj>();
//       json['Farbisganj'].forEach((v) {
//         farbisganj.add(new Farbisganj.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.farbisganj != null) {
//       data['Farbisganj'] = this.farbisganj.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Farbisganj {
//   int required;
//   String field_name;
//   String reg_exp;
//   String display_value;
//
//   Farbisganj(
//       {this.required, this.field_name, this.reg_exp, this.display_value});
//
//   Farbisganj.fromJson(Map<String, dynamic> json) {
//     required = json['required'];
//     field_name = json['field_name'];
//     reg_exp = json['reg_exp'];
//     display_value = json['display_value'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['required'] = this.required;
//     data['field_name'] = this.field_name;
//     data['reg_exp'] = this.reg_exp;
//     data['display_value'] = this.display_value;
//
//     return data;
//   }
// }
