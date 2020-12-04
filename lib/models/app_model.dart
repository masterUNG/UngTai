class AppModel {
  int id;
  String tab;
  String href;
  String hrefIframe;
  String imgSrc;
  String text;
  String display;
  String newpage;

  AppModel(
      {this.id,
      this.tab,
      this.href,
      this.hrefIframe,
      this.imgSrc,
      this.text,
      this.display,
      this.newpage});

  AppModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    tab = json['Tab'];
    href = json['Href'];
    hrefIframe = json['Href_iframe'];
    imgSrc = json['ImgSrc'];
    text = json['Text'];
    display = json['Display'];
    newpage = json['Newpage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Tab'] = this.tab;
    data['Href'] = this.href;
    data['Href_iframe'] = this.hrefIframe;
    data['ImgSrc'] = this.imgSrc;
    data['Text'] = this.text;
    data['Display'] = this.display;
    data['Newpage'] = this.newpage;
    return data;
  }
}

