import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maybrowser/Logic/tabRootL.dart';
import 'package:maybrowser/Model/tabRootM.dart';
import 'package:maybrowser/View/tabV.dart';
import 'package:maybrowser/plugin/flip_card.dart';

class TabRootV extends StatefulWidget{
  TabRootV({Key? key}) : super(key: key);

  @override
  _TabRootVState createState() => _TabRootVState();
}
class _TabRootVState extends State<TabRootV>{

  double move = 0;
  double moveLength = 0;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GetBuilder<TabRootL>(
        builder: (_){
          TabRootM tabRootM = _.tabS!.tabRootM;
          List<TabV> tabVList = _.tabS!.tabRootM.tabVList;
          return Scaffold(
            appBar: _.tabS!.webShow == 0 ? null : AppBar(
              leading: IconButton(icon: Icon(Icons.arrow_back),onPressed: (){
                _.showWeb();
              },),
              actions: [
                IconButton(icon: Icon(Icons.add),onPressed: (){
                  _.addTabView("null");
                },),
              ],
            ),
            body: Container(

              child: IndexedStack(
                index: _.tabS!.webShow,
                children: [
                  tabVList.length == 0
                      ? Container()
                      : tabVList[tabRootM.showIndex],
                  Stack(
                    children: _body(tabRootM, _),
                  ),
                ],
              ),
            ),
          );
        },
    );
  }

  List<Widget> _body(TabRootM tabRootM, TabRootL tabRootL){
    List<Widget> body = [];
    body.add(Container(width: Get.width, height: Get.height, color: Colors.grey),);

    if(tabRootM.tabVList.length != 0){
      for(int i = 0; i < tabRootM.tabVList.length; i++){
        double a = 160 * i.toDouble();
        body.add(_tabCard(a, Colors.white, i, tabRootL),);
      }
    }

    var tap = GestureDetector(
      onVerticalDragUpdate: (detail){
        move = detail.delta.direction*detail.delta.distance;
        moveLength += move;
        //print(move);
        setState(() {});
      },
    );
    body.add(tap);
    return body;
  }

  _tabCard(double top, Color color, int showIndex, TabRootL tabRootL){
    var value = tabRootL.tabS!.tabRootM.tabVMod[showIndex].screenshot;
    var url = tabRootL.tabS!.tabRootM.tabVMod[showIndex].url;
    return Positioned(
      top: top+moveLength,
      width: 300,
      left: Get.width/2-300/2,
      height: 550,
      child: Transform(
        transform: Matrix4.identity()..setEntry(3, 2, 0.001)..rotateX(0.7),
        alignment: Alignment.center,
        child: InkWell(
          onTap: () {
            tabRootL.changeShowIndex(showIndex);
            tabRootL.showWeb();
          },
          child: Card(
            color: color,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 20,
            child: Column(
              children: [
                Text("${url??""}",style: TextStyle(fontSize: 10),),
                value != null ? Image.memory(value) : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

}