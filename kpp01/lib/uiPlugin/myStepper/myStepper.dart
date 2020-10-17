import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kpp01/uiPlugin/myStepper/stepper.dart' as MyStepper;

class MyNewStepper extends StatefulWidget{
  @override
  _MyNewStepperState createState() => _MyNewStepperState();
}

class _MyNewStepperState extends State<MyNewStepper>{

  int index ;
  List date = ["", "", "", "", ""];
  List time = ["", "", "", "", ""];
  List isActive = [true, true, true, true, true, ];


  @override
  initState(){
    super.initState();
    index = 0;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MyStepper.Stepper(
      currentStep: index,
      //physics: BouncingScrollPhysics(),
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
                this.date[index] = "${date.day} - ${date.month} - ${date.year}";
                this.time[index] = "${time.hour} : ${time.minute} - ${time2.hour} : ${time2.minute}";
              });
            }
          }
        }

      },
      controlsBuilder:  (BuildContext context, { VoidCallback onStepContinue, VoidCallback onStepCancel}){
        return Container(
          //color: Colors.red,
          child: Row(
            children: [
              TextButton(onPressed: onStepContinue, child: Text("State")),
              TextButton(onPressed: onStepCancel, child: Text("Time")),
            ],
          ),
        );
      },
      steps: [
        step(date[0], time[0], isActive[0]),
        step(date[1], time[1], isActive[1]),
        step(date[2], time[2], isActive[2]),
        step(date[3], time[3], isActive[3]),
        step(date[4], time[4], isActive[4]),
      ],
    ) ;
  }
  step(String date, String time, bool isActive){
    return MyStepper.Step(
      isActive: isActive,
      state: MyStepper.StepState.indexed,
      title: Text(date),
      subtitle: Text(time),
      content: Container(),
    );
  }
}