
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpp01/bloc/accountDataBloc/bloc.dart';
import 'package:kpp01/bloc/questionDataBloc/bloc.dart';
import 'package:kpp01/bloc/questionTestBloc/bloc.dart';
import 'package:kpp01/dataModel/testDataModel.dart';
import 'package:kpp01/ui/kpp01/test/testResult.dart';

class TestHistory extends StatelessWidget{
  TestHistory({
    Key key,
    this.questionTestBloc,
    this.questionDataBloc,
}):super(key:key);

  final QuestionTestBloc questionTestBloc;
  final QuestionDataBloc questionDataBloc;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<AccountDataBloc,AccountDataState>(
      builder: (context,accountDataState){
        List<TestAnswerAllModel> testAnswerAllModelList = List<TestAnswerAllModel>();
        if(accountDataState is AccountDataStateFinish){
          testAnswerAllModelList = accountDataState.accountDataModel.myTestAnswerAllModelList.testAnswerAllModel;
        }
        return BlocBuilder<QuestionDataBloc,QuestionDataState>(
          cubit: questionDataBloc,
          builder: (context,questionDataState){
            QuestionDataList questionDataList;
            if(questionDataState is QuestionDataStateGotQuestionData){
              questionDataList = questionDataState.questionDataList;
            }
            if(testAnswerAllModelList.isEmpty){
              return Scaffold(
                appBar: AppBar(),
                body: Center(child: Text("No test history!"),),
              );
            }else{
              return Scaffold(
                appBar: AppBar(elevation: 0,),
                body: Container(
                  child: ListView.builder(
                    padding: EdgeInsets.all(20),
                    itemCount: testAnswerAllModelList.length,
                    itemBuilder: (BuildContext context,int index){
                      return Container(
                        margin: EdgeInsets.only(top: 10),
                        child: ListTile(
                          title: Text('${testAnswerAllModelList[index].correctAmount}/50'),
                          leading: testAnswerAllModelList[index].correctAmount >= 42 ? Text( "Pass",style: TextStyle(color:  Colors.green),) : Text( "Fail",style: TextStyle(color:  Colors.red),),
                          subtitle: Text("${testAnswerAllModelList[index].time[0]}-${testAnswerAllModelList[index].time[1]}-${testAnswerAllModelList[index].time[2]} ${testAnswerAllModelList[index].time[3]}:${testAnswerAllModelList[index].time[4]}:${testAnswerAllModelList[index].time[5]}",style: TextStyle(fontSize: 12)),
                          trailing: Text("${testAnswerAllModelList[index].timeSpendSecond} second"),
                          isThreeLine: false,
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                              return TestResult(
                                //index: index,
                                questionDataList: questionDataList,
                                testAnswerModelList: testAnswerAllModelList[index].testAnswerModelList,
                                testQuestionIndexList: testAnswerAllModelList[index].testQuestionIndexList,
                              );
                            }));
                          },
                        ),
                      );
                    },
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}