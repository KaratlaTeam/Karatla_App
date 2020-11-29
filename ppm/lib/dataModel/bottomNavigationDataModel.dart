
import 'package:flutter/cupertino.dart';

class BottomNavigationDataModel{

  BottomNavigationDataModel({this.color1, this.color2, this.color3, this.size1,
      this.size2, this.size3, this.index});

  Color color1;
  Color color2;
  Color color3;

  double size1;
  double size2;
  double size3;

  int index;

  setData(Color color1,Color color2,Color color3,double size1,double size2,double size3,int index){
    this.color1 = color1;
    this.color2 = color2;
    this.color3 = color3;

    this.size1 = size1;
    this.size2 = size2;
    this.size3 = size3;

    this.index = index;
  }


}