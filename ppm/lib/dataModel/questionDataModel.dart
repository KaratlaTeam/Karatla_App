import 'dart:convert';

import 'package:PPM/typedef.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionDataModel {
  final QuestionDataModelDetail questionDataModelDetail;

  QuestionDataModel({this.questionDataModelDetail});

  factory QuestionDataModel.fromJson(Map<String, dynamic> json) {
    return QuestionDataModel(
      questionDataModelDetail: json["questionDataModelDetail"] != null ? QuestionDataModelDetail.fromJson(json["questionDataModelDetail"]) : null,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> questionDataModelMap = Map<String, dynamic>();
    if(this.questionDataModelDetail != null){
      questionDataModelMap["questionDataModelDetail"] = this.questionDataModelDetail.toJson();
    }
    
    return questionDataModelMap;
    }

    Future setSharePQuestionDataModel(QuestionDataModel questionDataModel, String systemLanguage) async{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setString("questionData_$systemLanguage",json.encode(questionDataModel.toJson()));
    }

    Future<QuestionDataModel> getSharePQuestionDataModel(QuestionDataModel questionDataModel, String systemLanguage) async{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      var jsonBody = sharedPreferences.getString("questionData_$systemLanguage");
      if (jsonBody != null) {
          var decodeJsonBody = await json.decode(jsonBody);
          questionDataModel = QuestionDataModel.fromJson(decodeJsonBody);
      }else {
          questionDataModel = null;
     }

      return questionDataModel;
    }
}

class QuestionDataModelDetail{
  QuestionDataModelDetail({
    this.version, this.answerLetter, this.choicesLetter, this.questionPart1, this.questionPart2, this.questionPart3,
  });

  final double version;
  final List<String> answerLetter;
  final List<String> choicesLetter;
  final QuestionPart1 questionPart1;
  final QuestionPart2 questionPart2;
  final QuestionPart3 questionPart3;

  factory QuestionDataModelDetail.fromJson(Map<String, dynamic> json) {
    return QuestionDataModelDetail(
      version: json["version"] != null ? json["version"] : null,
      answerLetter: json["answerLetter"] != null ? List<String>.from(json["answerLetter"]) : null,
      choicesLetter: json["choicesLetter"] != null ? List<String>.from(json["choicesLetter"]) : null,
      questionPart1: json["questionPart1"] != null ? QuestionPart1.fromJson(json["questionPart1"]): null,
      questionPart2: json["questionPart2"] != null ? QuestionPart2.fromJson(json["questionPart2"]): null,
      questionPart3: json["questionPart3"] != null ? QuestionPart3.fromJson(json["questionPart3"]): null,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> questionDataModelDetailMap = Map<String, dynamic>();
    if(this.version != null){
      questionDataModelDetailMap["version"] = this.version;
    }
    if(this.answerLetter != null){
      questionDataModelDetailMap["answerLetter"] = this.answerLetter;
    }
    if(this.choicesLetter != null){
      questionDataModelDetailMap["choicesLetter"] = this.choicesLetter;
    }
    if(this.questionPart1 != null){
      questionDataModelDetailMap["questionPart1"] = this.questionPart1.toJson();
      }
    if(this.questionPart2 != null){
      questionDataModelDetailMap["questionPart2"] = this.questionPart2.toJson();
      }
    if(this.questionPart3 != null){
      questionDataModelDetailMap["questionPart3"] = this.questionPart3.toJson();
      }
    
    return questionDataModelDetailMap;
    }
}


class QuestionPart1 {
  List<QuestionData> questionData;

  QuestionPart1({this.questionData});

  factory QuestionPart1.fromJson(Map<String, dynamic> json) {
    return QuestionPart1(
      questionData: json['questionData'] != null ? (json['questionData'] as List).map((i) => QuestionData.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> questionData = new Map<String, dynamic>();
    if (this.questionData != null) {
      questionData['questionData'] = this.questionData.map((v) => v.toJson()).toList();
    }
    return questionData;
  }
}

class QuestionPart2 {
  List<QuestionData> questionData;

  QuestionPart2({this.questionData});

  factory QuestionPart2.fromJson(Map<String, dynamic> json) {
    return QuestionPart2(
      questionData: json['questionData'] != null ? (json['questionData'] as List).map((i) => QuestionData.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> questionData = new Map<String, dynamic>();
    if (this.questionData != null) {
      questionData['questionData'] = this.questionData.map((v) => v.toJson()).toList();
    }
    return questionData;
  }
}

class QuestionPart3 {
  List<QuestionData> questionData;

  QuestionPart3({this.questionData});

  factory QuestionPart3.fromJson(Map<String, dynamic> json) {
    return QuestionPart3(
      questionData: json['questionData'] != null ? (json['questionData'] as List).map((i) => QuestionData.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> questionData = new Map<String, dynamic>();
    if (this.questionData != null) {
      questionData['questionData'] = this.questionData.map((v) => v.toJson()).toList();
    }
    return questionData;
  }
}


class QuestionData {
  String answer;
  _Choices choices;
  int id;
  _Question question;

  QuestionData({this.answer, this.choices, this.id, this.question});

  factory QuestionData.fromJson(Map<String, dynamic> json) {
    return QuestionData(
      answer: json['answer'],
      choices: json['choices'] != null ? _Choices.fromJson(json['choices']) : null,
      id: json['id'],
      question: json['question'] != null ? _Question.fromJson(json['question']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> questionData = new Map<String, dynamic>();
    questionData['answer'] = this.answer;
    questionData['id'] = this.id;
    if (this.choices != null) {
      questionData['choices'] = this.choices.toJson();
    }
    if (this.question != null) {
      questionData['question'] = this.question.toJson();
    }
    return questionData;
  }
}

class _Question {
  String questionDetail;
  List<String> questionDetailChoice;
  List<String> questionDetailImages;

  _Question({this.questionDetail, this.questionDetailChoice, this.questionDetailImages});

  factory _Question.fromJson(Map<String, dynamic> json) {
    return _Question(
      questionDetail: json['questionDetail'],
      questionDetailChoice: json['questionDetailChoice'] != null ? new List<String>.from(json['questionDetailChoice']) : null,
      questionDetailImages: json['questionDetailImages'] != null ? new List<String>.from(json['questionDetailImages']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> questionData = new Map<String, dynamic>();
    questionData['questionDetail'] = this.questionDetail;
    if (this.questionDetailChoice != null) {
      questionData['questionDetailChoice'] = this.questionDetailChoice;
    }
    if (this.questionDetailImages != null) {
      questionData['questionDetailImages'] = this.questionDetailImages;
    }
    return questionData;
  }
}

class _Choices {
  List<String> choiceDetail;
  List<String> choiceImage;

  _Choices({this.choiceDetail, this.choiceImage});

  factory _Choices.fromJson(Map<String, dynamic> json) {
    return _Choices(
      choiceDetail: json['choiceDetail'] != null ? new List<String>.from(json['choiceDetail']) : null,
      choiceImage: json['choiceImage'] != null ? new List<String>.from(json['choiceImage']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> questionData = new Map<String, dynamic>();
    if (this.choiceDetail != null) {
      questionData['choiceDetail'] = this.choiceDetail;
    }
    if (this.choiceImage != null) {
      questionData['choiceImage'] = this.choiceImage;
    }
    return questionData;
  }
}
