import 'dart:io';
import 'dart:math';

import 'package:data_to_json/Controller/c_root.dart';
import 'package:data_to_json/Model/m_people.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:graphview/GraphView.dart' as g;

class MyDateTime extends DateTime{
  MyDateTime(int year,
      [int month = 1,
        int day = 1,
        int hour = 0,
        int minute = 0,
        int second = 0,
        int millisecond = 0,
        int microsecond = 0]) : super(year,month,day,hour,minute,second);

  Map<String, dynamic> toJson(){
    Map<String, dynamic> myDateTimeMay = {};
    myDateTimeMay['year'] = year;
    myDateTimeMay['month'] = month;
    myDateTimeMay['day'] = day;
    myDateTimeMay['hour'] = hour;
    myDateTimeMay['minute'] = minute;
    myDateTimeMay['second'] = second;
    return myDateTimeMay;
  }

  factory MyDateTime.fromJson(Map<String, dynamic> json){
    return MyDateTime(
      json['year'], json['month'], json['day'],json['hour'],json['minute'],json['second'],
    );
  }

  @override
  String toString() {
    return '$year年$month月$day日';
  }
}

class PVPickDate extends StatelessWidget{
  final ValueChanged<DateTime> onDateTimeChanged;
  final String title;

  const PVPickDate({
    Key? key,
    required this.onDateTimeChanged,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 216,
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          onTap: () {},
          child: SafeArea(
            top: false,
            child: CupertinoDatePicker(
              initialDateTime: DateTime(618),
              minimumYear: 528,
              maximumYear: 1007,
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: onDateTimeChanged,
            ),
          ),
        ),
      ),
    );
  }
  timePick1(BuildContext context,){
    return Row(
      children: [
        TextButton(
          onPressed: (){
            showCupertinoModalPopup(context: context, builder: (BuildContext context){
              return PVPickDate(onDateTimeChanged: onDateTimeChanged, title: title,);
            });
          },
          child: Text(title),
        ),
      ],
    );
  }
}

class PVPhotoView extends StatelessWidget{
  final String title;

  const PVPhotoView({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Colors.white,
      child: Center(
        child: InkWell(
          child: Hero(tag: title.hashCode,
            child: Image.file(File(title),fit: BoxFit.contain,),
          ),
          onTap: (){
            Get.to(()=>Scaffold(
              backgroundColor: Colors.black,
              body: Stack(
                children: [
                  Center(
                    child: InteractiveViewer(
                      maxScale: 30,
                      child: Hero(tag: title.hashCode,
                        child: Image.file(File(title),fit: BoxFit.contain,filterQuality: FilterQuality.high,),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(top: Get.height*0.06),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: (){Get.back();},
                          icon: const Icon(Icons.arrow_back_ios,color: Colors.white,),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
          },
        ),
      ),
    );
  }
}

class PVOtherDetailView extends StatelessWidget{
  final String title;
  final List data;
  final String Function(int) dataIndex;
  final String Function(int) trailing;
  final List<Widget>? actions;

  const PVOtherDetailView({
    Key? key,
    required this.title,
    required this.data,
    required this.dataIndex,
    required this.trailing ,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: actions,
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index){
          return ListTile(
            title: Text(dataIndex(index)),
            trailing: Text(trailing(index)),
            onLongPress: (){
              Clipboard.setData(ClipboardData(text: dataIndex(index)));
              Get.showSnackbar(GetSnackBar(message: '复制 $title 成功',duration: const Duration(seconds: 1),));
            },
            //leading: SizedBox(
            //  width: Get.width*0.1,
            //  height: Get.width*0.1,
            //  child: data[index].images.isEmpty==''
            //      ?const Icon(Icons.photo)
            //      :Hero(tag: data[index].images[0].hashCode,
            //    child: Image.file(File(data[index].images[0]),fit: BoxFit.cover,),
            //  ),
            //),
          );
        },
      ),
    );
  }
}

class PVFamilyTree extends StatelessWidget{

  PVFamilyTree({Key? key}) : super(key: key);

  final g.Graph graph = g.Graph()..isTree = true;
  g.BuchheimWalkerConfiguration builder = g.BuchheimWalkerConfiguration();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GetX<CRoot>(
      initState: (s){
        var mf = s.controller?.mFamily?.familyMembers;
        List sour = [];
        List des = [];
        //if(mf != null){
        //  for(int i = 0; i<mf.length; i++){
        //    if(mf[i].level==0){
        //      sour.add(g.Node.Id(i));
        //    }else{
        //      des.add(g.Node.Id(i));
        //    }
        //  }
        //  graph.addEdge(sour[0], sour[1]);
        //  for(var a in des){
        //    graph.addEdge(sour[0], a);
        //  }
        //  for(var a in des){
        //    graph.addEdge(sour[1], a);
        //  }
        //}
        builder
          ..siblingSeparation = (200)
          ..levelSeparation = (50)
          ..subtreeSeparation = (150)
          ..orientation = (g.BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM);
      },
      builder: (c){
        return Scaffold(
          appBar: AppBar(
            title: Text('家谱-${c.mFamily?.familyMembers.length.toString()}人'),
          ),
          body: Center(
            child: InteractiveViewer(
              constrained: false,
              boundaryMargin: EdgeInsets.all(100),
              minScale: 0.01,
              maxScale: 5.6,
              child: g.GraphView(
                graph: _graph(),
                algorithm: g.BuchheimWalkerAlgorithm(builder, g.TreeEdgeRenderer(builder)),
                paint: Paint()
                  ..color = Colors.black
                  ..strokeWidth = 2
                  ..style = PaintingStyle.stroke,
                builder: (g.Node node) {
                  var a = node.key?.value as int;
                  return rectangleWidget(a,c);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  _graph(){
    graph.addEdge(g.Node.Id(0), g.Node.Id(1));
  }

  Widget rectangleWidget(int a, CRoot cRoot) {
    return InkWell(
      onTap: () {
        print('clicked$a');
      },
      child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(color: Colors.blue.shade100, spreadRadius: 1),
            ],
          ),
          child: Text(a.toString()),//getPeople(cRoot, cRoot.mFamily?.familyMembers[a].peopleUuid),
      ),
    );
  }

  getPeople(CRoot cRoot, uuid){
    if(uuid != ''){
      for(MPeople a in cRoot.allPeople){
        if(a.uuid == uuid){
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: Get.width*0.1,
                height: Get.width*0.1,
                child: a.images.isEmpty
                    ?const Icon(Icons.photo)
                    :Hero(tag: a.images[0].hashCode,
                  child: Image.file(File(a.images[0]),fit: BoxFit.cover,),
                ),
              ),
              SizedBox(
                width: Get.width*0.05,
              ),
              Text(a.nameList[0].fullName),
            ],
          );
        }
      }
    }
  }

}