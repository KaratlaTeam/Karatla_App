class QuestionPartModel<T>{
   T of<T>(){
    T value;
    return value;
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
