class LoginResponseData {
  String name;
  String mobile;
  String email;
  String profileimage;
  String userid;
  String token;

  LoginResponseData(
      {this.name,
      this.mobile,
      this.email,
      this.profileimage,
      this.userid,
      this.token});

  LoginResponseData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    mobile = json['mobile'];
    email = json['email'];
    profileimage = json['profileimage'];
    userid = json['userid'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['profileimage'] = this.profileimage;
    data['userid'] = this.userid;
    data['token'] = this.token;
    return data;
  }
}
