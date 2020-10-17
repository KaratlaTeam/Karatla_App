import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kpp01/bloc/internetCheckBloc/bloc.dart';
import 'package:kpp01/dataModel/httpModel.dart';

class HttpSource{

  static const String getCode = "https://karatla.com/api/account/validation/code/";
  static const String checkCode = "https://karatla.com/api/account/validation/code/check/";
  static const String register = "https://karatla.com/api/account/new";
  static const String login = "https://karatla.com/api/account/login";
  static const String logout = "https://karatla.com/api/account/logout";
  static const String getAccount = "https://karatla.com/api/account/get";
  static const String checkLogin = "https://karatla.com/api/account/check";


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

