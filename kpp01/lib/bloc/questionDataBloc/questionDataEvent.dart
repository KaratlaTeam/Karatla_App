import 'package:flutter/material.dart';
import 'package:kpp01/bloc/questionPageBloc/questionPageEvent.dart';

abstract class QuestionDataEvent {
  const QuestionDataEvent();
}

class QuestionDataEventGetQuestionData extends QuestionDataEvent{
      final String systemLanguage;
      const QuestionDataEventGetQuestionData({
        @required this.systemLanguage,
      }):assert(systemLanguage != null);
}

class QuestionDataEventCheckInternetThenGet extends QuestionDataEvent{
  final String systemLanguage;
      const QuestionDataEventCheckInternetThenGet({
        @required this.systemLanguage,
      }):assert(systemLanguage != null);
}

class QuestionDataEventGetQuestionDataFromInternet extends QuestionDataEvent{}
