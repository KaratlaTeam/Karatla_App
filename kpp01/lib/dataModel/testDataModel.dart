

class TestAnswerAllModelList{
  TestAnswerAllModelList({this.testAnswerAllModel});

  final List<TestAnswerAllModel> testAnswerAllModel;

  factory TestAnswerAllModelList.from(Map<String, dynamic> json){
    if(json["testAnswerAllModel"] == null || json["testAnswerAllModel"] == ""){
      return TestAnswerAllModelList(
        testAnswerAllModel: List<TestAnswerAllModel>(),
      );
    }else{
      return TestAnswerAllModelList(
        testAnswerAllModel: (json["testAnswerAllModel"]  as List).map((e) => e != null ? TestAnswerAllModel.fromJson(e) : null).toList(),
      );
    }

  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> testAnswerAllModelList = Map<String, dynamic>();
    testAnswerAllModelList["testAnswerAllModel"] = this.testAnswerAllModel.map((e) => e != null ? e.toJson() : null).toList();

    return testAnswerAllModelList;
  }


}

class TestAnswerModel{

  TestAnswerModel({this.pageIndex, this.questionIndex, this.selectedAnswer, this.correctAnswer});

  /// index in 50 questions from 0
  final int pageIndex;

  /// index in all data from 0
  final int questionIndex;

  final String selectedAnswer;

  final String correctAnswer;

  factory TestAnswerModel.fromJson(Map<String, dynamic> json){
    return TestAnswerModel(
      pageIndex: json["pageIndex"],
      questionIndex: json["questionIndex"],
      selectedAnswer: json["selectedAnswer"],
      correctAnswer: json["correctAnswer"],
    );
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> testAnswerModel = new Map<String, dynamic>();
    testAnswerModel["pageIndex"] = this.pageIndex;
    testAnswerModel["questionIndex"] = this.questionIndex;
    testAnswerModel["selectedAnswer"] = this.selectedAnswer;
    testAnswerModel["correctAnswer"] = this.correctAnswer;

    return testAnswerModel;
  }

}

class TestQuestionIndexListPart{
  const TestQuestionIndexListPart({this.testQuestionIndexListPartList});
  final List<int> testQuestionIndexListPartList;

  factory TestQuestionIndexListPart.from(Map<String, dynamic> json){
    return TestQuestionIndexListPart(
      testQuestionIndexListPartList: List<int>.from(json["testQuestionIndexListPartList"]),
    );
  }

  Map<String, dynamic> toJson(){
   final Map<String, dynamic> testQuestionIndexListPart = Map<String, dynamic>();
   testQuestionIndexListPart["testQuestionIndexListPartList"] = this.testQuestionIndexListPartList;
   return testQuestionIndexListPart;
  }

}

class TestAnswerAllModel{

  const TestAnswerAllModel({
    this.testAnswerModelList,
    this.testQuestionIndexList,
    this.timeSpendSecond,
    this.time,
    this.correctAmount,});

  final List<TestAnswerModel> testAnswerModelList;

  final List<TestQuestionIndexListPart> testQuestionIndexList;

  final int timeSpendSecond;

  final List<int> time;

  final int correctAmount;

  factory TestAnswerAllModel.fromJson(Map<String, dynamic> json){
    return TestAnswerAllModel(
      testAnswerModelList: (json["testAnswerModelList"] as List).map((e) => e != null ? TestAnswerModel.fromJson(e) : null).toList(),
      testQuestionIndexList: (json["testQuestionIndexList"] as List).map((e) => e != null ? TestQuestionIndexListPart.from(e) : null).toList(),
      timeSpendSecond: json["timeSpendSecond"],
      time: List<int>.from(json["time"]),
      correctAmount: json["correctAmount"],
    );
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> testAnswerAllModel = Map<String, dynamic>();
    testAnswerAllModel["testAnswerModelList"] = this.testAnswerModelList.map((e) => e != null ? e.toJson() : null).toList();
    testAnswerAllModel["testQuestionIndexList"] = this.testQuestionIndexList.map((e) => e != null ? e.toJson() : null).toList();
    testAnswerAllModel["timeSpendSecond"] = this.timeSpendSecond;
    testAnswerAllModel["time"] = this.time;
    testAnswerAllModel["correctAmount"] = this.correctAmount;
    return testAnswerAllModel;
  }

}
