import 'package:flutter/material.dart';
import 'package:kpp01/dataModel/questionDataModel.dart';
import 'package:kpp01/dataModel/testDataModel.dart';
import 'package:kpp01/ui/kpp01/test/testResultDetailPage.dart';

class TestResult extends StatefulWidget {

  TestResult({
    Key key,
    this.questionDataModel,
    this.testQuestionIndexList,
    this.testAnswerModelList,
  }) :super(key: key);

  final QuestionDataModel questionDataModel;
  final List<TestQuestionIndexListPart> testQuestionIndexList ;
  final List<TestAnswerModel> testAnswerModelList;

  @override
  _TestResultState createState() => _TestResultState();
}
class _TestResultState extends State<TestResult>{

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: ListView.builder(
          padding: EdgeInsets.all(20),
          itemCount: 50,
          itemBuilder: (BuildContext context,int index){
            QuestionData questionData;
            String selectedAnswer = "No answer";

            if(index<15&&index >=0){
              questionData = widget.questionDataModel.questionDataModelDetail.questionPart1.questionData[widget.testQuestionIndexList[0].testQuestionIndexListPartList[index]];
            }else if(index >=15 &&index <40){
              questionData = widget.questionDataModel.questionDataModelDetail.questionPart2.questionData[widget.testQuestionIndexList[1].testQuestionIndexListPartList[index-15]];
            }else if(index >=40 &&index <50){
              questionData = widget.questionDataModel.questionDataModelDetail.questionPart3.questionData[widget.testQuestionIndexList[2].testQuestionIndexListPartList[index-40]];
            }

            if(widget.testAnswerModelList[index] != null){
              selectedAnswer = widget.testAnswerModelList[index].selectedAnswer;
            }

            return Container(
              margin: EdgeInsets.only(top: 10),
              child: ListTile(
                title: Text('${questionData.question.questionDetail}',style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,maxLines: 2,),
                leading: Text("${index+1}",),
                subtitle: Text("$selectedAnswer",),
                trailing: Text("${questionData.answer}"),
                isThreeLine: false,
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>
                      TestResultDetailPage(
                        questionData: questionData,
                        selectedAnswer: selectedAnswer,
                        answerLetter: widget.questionDataModel.questionDataModelDetail.answerLetter,
                        choicesLetter: widget.questionDataModel.questionDataModelDetail.choicesLetter,
                  )));
                },
              ),
            );
          },
        ),
      ),
    );
  }
}