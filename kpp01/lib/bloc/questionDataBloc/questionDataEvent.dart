import 'package:flutter/material.dart';
import 'package:kpp01/bloc/questionDataBloc/bloc.dart';
import 'package:kpp01/typedef.dart';

abstract class QuestionDataEvent {
  const QuestionDataEvent();
}

class QuestionDataEventGetQuestionData extends QuestionDataEvent{
      final String systemLanguage;
      const QuestionDataEventGetQuestionData({
        @required this.systemLanguage,
      }):assert(systemLanguage != null);
}

class QuestionDataEventGetQuestionDataFromInternet extends QuestionDataEvent{
  final String systemLanguage;
      const QuestionDataEventGetQuestionDataFromInternet({
        @required this.systemLanguage,
      }):assert(systemLanguage != null);
}