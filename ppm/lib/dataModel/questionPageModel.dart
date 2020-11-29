import 'package:flutter/cupertino.dart';

class QuestionPageModel{

  int pageIndexPart1 ;
  PageController pageControllerPart1 ;
  int pageIndexPart2 ;
  PageController pageControllerPart2 ;
  int pageIndexPart3 ;
  PageController pageControllerPart3 ;
  int pageIndexPartTest ;
  PageController pageControllerPartTest ;
  int pageIndexPartFavorite ;
  PageController pageControllerPartFavorite ;

  initialPage(){
    pageIndexPart1 = 0;
    pageControllerPart1 = PageController(initialPage: 0);
    pageIndexPart2 = 0;
    pageControllerPart2 = PageController(initialPage: 0);
    pageIndexPart3 = 0;
    pageControllerPart3 = PageController(initialPage: 0);
    pageIndexPartTest = 0;
    pageControllerPartTest = PageController(initialPage: 0);
    pageIndexPartFavorite = 0;
    pageControllerPartFavorite = PageController(initialPage: 0);
  }

  dispose(){
    pageControllerPart1.dispose();
    pageControllerPart2.dispose();
    pageControllerPart3.dispose();
    pageControllerPartTest.dispose();
    pageControllerPartFavorite.dispose();
  }
}