import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kpp01/dataModel/httpModel.dart';

class HttpSource{

  static const String getCode = "http://127.0.0.1:8080/api/account/validation/code/";
  static const String checkCode = "http://127.0.0.1:8080/api/account/validation/code/check/";
  static const String register = "http://127.0.0.1:8080/api/account/new";
  static const String login = "http://127.0.0.1:8080/api/account/login";
  static const String logout = "http://127.0.0.1:8080/api/account/logout";
  static const String getAccount = "http://127.0.0.1:8080/api/account/get";
  static const String checkLogin = "http://127.0.0.1:8080/api/account/check";


  static const Map<String,String> headers = {
    'Content-Type': 'application/json',
  };

  Future<HttpModel> requestGet(String url)async{
    print("send request get");

    var request = await http.get(
      url,
      headers: headers,
    );

    print('Response status: ${request.statusCode}');
    print('Response body: ${request.body}');

    var json = jsonDecode(request.body);
    HttpModel httpModel = HttpModel.fromJson(json);
    print(httpModel.data.toString());

    return httpModel;
  }

  Future<HttpModel> requestPost(Map body, String url, Map<String,String> headers)async{
    print("send request post");
    var request = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
    print('Response status: ${request.statusCode}');
    print('Response body: ${request.body}');

    var json = jsonDecode(request.body);
    HttpModel httpModel = HttpModel.fromJson(json);
    print(httpModel.data.toString());

    return httpModel;
  }

}

