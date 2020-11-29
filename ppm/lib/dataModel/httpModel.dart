
class HttpModel {
  int code;
  Map<String, dynamic> data;

  HttpModel({this.code, this.data});

  factory HttpModel.fromJson(Map<String, dynamic> json) {
    return HttpModel(
      code: json['code'],
      data: json['data'],
    );
  }
}