import 'package:flutter/cupertino.dart';

abstract class QuestionPageEvent{
  const QuestionPageEvent();
}

class QuestionPageEventChangePagePartNumber extends QuestionPageEvent{

  const QuestionPageEventChangePagePartNumber({
    @required this.pageIndex,
    @required this.partID,
  }):assert(pageIndex != null,partID != null);
  final int partID;
  final int pageIndex;

}