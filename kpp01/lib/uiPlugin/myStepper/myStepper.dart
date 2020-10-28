import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpp01/bloc/appDataBloc/appDataBloc.dart';
import 'package:kpp01/dataModel/appDataModel.dart';
import 'package:kpp01/uiPlugin/myStepper/stepper.dart' as MyStepper;
import 'package:kpp01/uiPlugin/myTextField/myTextFaild.dart';

class MyNewStepper extends StatefulWidget{
  @override
  _MyNewStepperState createState() => _MyNewStepperState();
}

class _MyNewStepperState extends State<MyNewStepper>{

  int index ;
  List date = ["", "", "", "", ""];
  List time = ["", "", "", "", ""];
  List content = ["", "", "", "", ""];
  List isActive = [true, true, true, true, true, ];
  bool showSchedule = true;

  TextEditingController textEditingController;

  @override
  initState(){
    index = 0;
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
    // TODO: implement build
    return ListView(
      padding: EdgeInsets.only(bottom: BlocProvider.of<AppDataBloc>(context).appDataModel.dataAppSizePlugin.scaleH*40),
      children: [
        MyStepper.Stepper(

          currentStep: index,
          physics: NeverScrollableScrollPhysics(),
          onStepTapped: (int index){
            setState(() {
              this.index = index;
            });
          },
          onStepContinue: (){
            if(this.isActive[index] == false){
              setState(() {
                this.isActive[index] = true;
              });
            }else{
              setState(() {
                this.isActive[index] = false;
              });
            }

          },

          onStepCancel: ()async{

            DateTime dateTime;
            DateTime dateTime2;

            var date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(DateTime.now().year - 1),
              lastDate: DateTime(DateTime.now().year + 2),
            );

            if(date != null){
              var time = await showTimePicker(
                context: context ,
                initialTime: TimeOfDay.now(),
                helpText: "SELECT START TIME",
              );
              if(time != null){
                var time2 = await showTimePicker(
                  context: context ,
                  initialTime: TimeOfDay.now(),
                  helpText: "SELECT FINISH TIME",
                );
                if(time2 != null){
                  dateTime = DateTime(date.year,date.month,date.day,time.hour,time.minute);
                  dateTime2 = DateTime(date.year,date.month,date.day,time2.hour,time2.minute);
                  print("$dateTime - $dateTime2");
                  setState(() {
                    this.date[index] = "${date.month} - ${date.day} - ${date.year}";
                    this.time[index] = "${time.hour} : ${time.minute} ~ ${time2.hour} : ${time2.minute}";
                  });
                }
              }
            }

          },
          controlsBuilder:  (BuildContext context, { VoidCallback onStepContinue, VoidCallback onStepCancel}){
            return Container(
              //color: Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(onPressed: onStepContinue, child: Text("State")),
                  TextButton(onPressed: onStepCancel, child: Text("Time")),
                  TextButton(
                    onPressed: (){
                      showDialog(context: context, builder: (build) {
                        return SimpleDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          title: Text("Mark Schedule"),
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              height: 50,
                              width: 300,
                              child: MyTextField(
                                lengthLimiting: 30,
                                filterPattern: RegExp("[a-zA-Z0-9!,.?\\s]"),
                                textEditingController: textEditingController,
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: FlatButton(
                                onPressed: () {
                                  setState(() {
                                    content[index] = textEditingController.text;
                                    textEditingController.clear();
                                    Navigator.pop(context);
                                  });
                                },
                                child: Text("Ok"),
                              ),
                            ),
                          ],
                        );
                      });

                    },
                    child: Text("Mark"),
                  ),
                ],
              ),
            );
          },
          steps: [
            step(date[0], time[0], content[0], isActive[0]),
            step(date[1], time[1], content[1], isActive[1]),
            step(date[2], time[2], content[2], isActive[2]),
            step(date[3], time[3], content[3], isActive[3]),
            step(date[4], time[4], content[4], isActive[4]),
          ],
        )
      ],
    );
  }
  step(String date, String time, String content, bool isActive){
    return MyStepper.Step(
      isActive: isActive,
      state: MyStepper.StepState.indexed,
      title: Text(date),
      subtitle: Text(time),
      content: Text(content),
    );
  }
}