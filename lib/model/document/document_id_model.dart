class DocumentIdModel {
  final String labelEn;
  final String labelAr;
  final int value;

  DocumentIdModel({
    required this.labelEn,
    required this.labelAr,
    required this.value,
  });

  factory DocumentIdModel.fromJson(Map<String, dynamic> json) {
    return DocumentIdModel(
      labelEn: json['labelEn'],
      labelAr: json['labelAr'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'labelEn': labelEn, 'labelAr': labelAr, 'value': value};
  }
}
