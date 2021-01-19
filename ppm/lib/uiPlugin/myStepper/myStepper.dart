import 'package:PPM/bloc/systemLanguage/systemLanguage_bloc.dart';
import 'package:PPM/dataModel/systemLanguageModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:PPM/bloc/appDataBloc/appDataBloc.dart';
import 'package:PPM/uiPlugin/myStepper/stepper.dart' as MyStepper;

class MyNewStepper extends StatefulWidget{
  const MyNewStepper({
    Key key,
    this.index: 0,
    this.date,
    this.time,
    this.content,
    this.isActive,
    this.onStepTapped,
    this.onStepContinue,
    this.onStepCancel,
    this.onPressedMark,
  }):super(key: key);

  final int index ;
  final List<String> date ;
  final List<String>  time ;
  final List<String>  content ;
  final List<bool>  isActive ;
  final ValueChanged<int> onStepTapped;
  final VoidCallback onStepContinue;
  final VoidCallback onStepCancel;
  //final VoidCallback onPressedMark;
  final ValueChanged<TextEditingController> onPressedMark;

  @override
  _MyNewStepperState createState() => _MyNewStepperState();
}

class _MyNewStepperState extends State<MyNewStepper>{

  TextEditingController textEditingController;

  @override
  initState(){
    textEditingController = TextEditingController(text: "");
    super.initState();
  }


  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemLanguageModel systemLanguageModel = BlocProvider.of<SystemLanguageBloc>(context).systemLanguageModel;
    return ListView(
      padding: EdgeInsets.only(bottom: BlocProvider.of<AppDataBloc>(context).appDataModel.dataAppSizePlugin.scaleH*40),
      children: [
        MyStepper.Stepper(

          currentStep: widget.index,
          physics: NeverScrollableScrollPhysics(),
          onStepTapped: widget.onStepTapped,
          onStepContinue: widget.onStepContinue,
          onStepCancel: widget.onStepCancel,
          controlsBuilder:  (BuildContext context, { VoidCallback onStepContinue, VoidCallback onStepCancel}){
            return Container(
              //color: Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(onPressed: onStepContinue, child: Text(systemLanguageModel.profileMainPageState)),
                  TextButton(onPressed: onStepCancel, child: Text(systemLanguageModel.profileMainPageTime)),
                  TextButton(
                    onPressed: (){
                      widget.onPressedMark(textEditingController);
                    },
                    child: Text(systemLanguageModel.profileMainPageMark),
                  ),
                ],
              ),
            );
          },
          steps: [
            step(widget.date[0], widget.time[0], widget.content[0], widget.isActive[0]),
            step(widget.date[1], widget.time[1], widget.content[1], widget.isActive[1]),
            step(widget.date[2], widget.time[2], widget.content[2], widget.isActive[2]),
            step(widget.date[3], widget.time[3], widget.content[3], widget.isActive[3]),
            step(widget.date[4], widget.time[4], widget.content[4], widget.isActive[4]),
          ],
        )
      ],
    );
  }
  step(String date, String time, String content, bool isActive){
    return MyStepper.Step(
      isActive: isActive,
      state: MyStepper.StepState.indexed,
      title: Text("$date"+"${content != "" ? " ("+content+")" : ""}"),
      subtitle: Text(time),
      content: Text(""),
    );
  }
}