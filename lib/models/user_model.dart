class UserModel {
  String employeeID;
  String fullName;
  String firstName;
  String lastName;
  String email;
  String telephoneNumber;
  String jobTitle;
  ProcessResult processResult;

  UserModel(
      {this.employeeID,
      this.fullName,
      this.firstName,
      this.lastName,
      this.email,
      this.telephoneNumber,
      this.jobTitle,
      this.processResult});

  UserModel.fromJson(Map<String, dynamic> json) {
    employeeID = json['EmployeeID'];
    fullName = json['FullName'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    email = json['Email'];
    telephoneNumber = json['TelephoneNumber'];
    jobTitle = json['JobTitle'];
    processResult = json['ProcessResult'] != null
        ? new ProcessResult.fromJson(json['ProcessResult'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EmployeeID'] = this.employeeID;
    data['FullName'] = this.fullName;
    data['FirstName'] = this.firstName;
    data['LastName'] = this.lastName;
    data['Email'] = this.email;
    data['TelephoneNumber'] = this.telephoneNumber;
    data['JobTitle'] = this.jobTitle;
    if (this.processResult != null) {
      data['ProcessResult'] = this.processResult.toJson();
    }
    return data;
  }
}

class ProcessResult {
  String message;
  bool isError;

  ProcessResult({this.message, this.isError});

  ProcessResult.fromJson(Map<String, dynamic> json) {
    message = json['Message'];
    isError = json['IsError'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Message'] = this.message;
    data['IsError'] = this.isError;
    return data;
  }
}

