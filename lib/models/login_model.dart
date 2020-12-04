class LoginModel {
  int id;
  String personalID;
  String fullName;
  String mobileNo;
  String email;
  String department;
  String imageFile;

  LoginModel(
      {this.id,
      this.personalID,
      this.fullName,
      this.mobileNo,
      this.email,
      this.department,
      this.imageFile});

  LoginModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    personalID = json['personalID'];
    fullName = json['fullName'];
    mobileNo = json['mobileNo'];
    email = json['email'];
    department = json['department'];
    imageFile = json['imageFile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['personalID'] = this.personalID;
    data['fullName'] = this.fullName;
    data['mobileNo'] = this.mobileNo;
    data['email'] = this.email;
    data['department'] = this.department;
    data['imageFile'] = this.imageFile;
    return data;
  }
}

