class NewsModel {
  int id;
  String subject;
  String subjectType;
  String content;
  String imageFile;
  String personalID;
  String createdDate;

  NewsModel(
      {this.id,
      this.subject,
      this.subjectType,
      this.content,
      this.imageFile,
      this.personalID,
      this.createdDate});

  NewsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subject = json['subject'];
    subjectType = json['subjectType'];
    content = json['content'];
    imageFile = json['imageFile'];
    personalID = json['personalID'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subject'] = this.subject;
    data['subjectType'] = this.subjectType;
    data['content'] = this.content;
    data['imageFile'] = this.imageFile;
    data['personalID'] = this.personalID;
    data['createdDate'] = this.createdDate;
    return data;
  }
}

