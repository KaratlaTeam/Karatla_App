
import 'package:flutter/cupertino.dart';

abstract class QuestionFavoriteEvent{
  const QuestionFavoriteEvent();
}

class QuestionFavoriteEventOnPressed extends QuestionFavoriteEvent{
  const QuestionFavoriteEventOnPressed({@required this.questionIndex,@required this.questionPartId,});
  final int questionIndex;
  final int questionPartId;
}