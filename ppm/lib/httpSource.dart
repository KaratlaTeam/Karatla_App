import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:PPM/dataModel/httpModel.dart';

class HttpSource{

  //static const String webUrl = "https://karatla.com";
  static const String webUrl = "http://localhost:8080";
  //static const String webUrl = "https://192.168.0.139:443";

  static const String checkInternet = "https://baidu.com";
  static const String getCode = "$webUrl/api/account/validation/code/";
  static const String checkCode = "$webUrl/api/account/validation/code/check/";
  static const String register = "$webUrl/api/account/new";
  static const String login = "$webUrl/api/account/login";
  static const String logout = "$webUrl/api/account/logout";
  static const String getAccount = "$webUrl/api/account/get";
  static const String checkLogin = "$webUrl/api/account/check";
  static const String checkQuestionVersion = "$webUrl/api/question/version";

  static const String getQuestionJsonData = "$webUrl/api/json/question/";
  static const String getQcademyJsonData = "$webUrl/api/json/academy/";

  static const String getQuestionImages = "$webUrl/api/images/question/";
  static const String getAcademyImages = "$webUrl/api/images/academy/";


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

  Future<HttpModel> requestPost(Map body, String url, Map<String,String> headers, )async{

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

  //checkInternetEvent(InternetCheckBloc internetCheckBloc, InternetCheckEventCheck internetCheckEventCheck, Object function)async*{
  //  internetCheckBloc.add(internetCheckEventCheck);
  //  await Future.delayed(Duration(milliseconds: 800));
  //  if(internetCheckBloc.state is InternetCheckStateGod){
  //    yield* function;
  //  }
  //}

}

