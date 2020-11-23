import 'package:flutter/material.dart';


typedef ListColorsWithIndexCallback = List<Color> Function(int index);

typedef IndexCallback = void Function(int index);

typedef ValueChanged<T> = void Function(T value);

typedef ValueCallback = void Function();

enum AccountDataEnum{
 ALL,NAME,PHOTO,PONE,EMAIL,TEST_RESULT_LIST,FAVORITE_QUESTION
}

//enum LoginType{EMAIL,PHONE}

enum HttpType{GET,POST}

enum SystemLanguage{EN,CN,MALAY}