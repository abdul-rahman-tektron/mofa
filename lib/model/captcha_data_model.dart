class CaptchaDataModel {
  String? captchaTextValue;
  String? captchaTokenValue;

  CaptchaDataModel({
    this.captchaTextValue,
    this.captchaTokenValue,
  });

  CaptchaDataModel.fromJson(Map<String, dynamic> json) {
    captchaTextValue = json['dntCaptchaTextValue'];
    captchaTokenValue = json['dntCaptchaTokenValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dntCaptchaTextValue'] = captchaTextValue;
    data['dntCaptchaTokenValue'] = captchaTokenValue;
    return data;
  }
}