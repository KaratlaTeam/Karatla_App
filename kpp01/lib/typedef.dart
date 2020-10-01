import 'package:flutter/material.dart';


typedef ListColorsWithIndexCallback = List<Color> Function(int index);

typedef IndexCallback = void Function(int index);

enum AccountDataEnum{
 ALL,NAME,PHOTO,PONE,EMAIL,TEST_RESULT_LIST,FAVORITE_QUESTION
}

//enum LoginType{EMAIL,PHONE}

enum HttpType{GET,POST}