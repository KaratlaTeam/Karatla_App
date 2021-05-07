import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hm/logic/houseL.dart';
import 'package:hm/model/houseM.dart';
import 'package:hm/model/roomM.dart';


class FixFeeTypeModelV extends StatefulWidget{
  @override
  _FixFeeTypeModelVState createState() => _FixFeeTypeModelVState();
}
class _FixFeeTypeModelVState extends State<FixFeeTypeModelV>{

  Map fixFeeTypeMap ;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context){

    return GetBuilder<HouseL>(
      builder: (_){
        return Scaffold(
          appBar: AppBar(
            title: Text('费用类型校正'),
            actions: [
              IconButton(icon: Icon(Icons.refresh), onPressed: (){
                setState(() {});
              }),
            ],
          ),
          body: FutureBuilder<Map>(
            future: _.getFixFeeType(),
            builder: (context, snapshot){
              if (snapshot.connectionState == ConnectionState.done) {
                if(snapshot.hasData){
                  this.fixFeeTypeMap = snapshot.data;
                  //print(_data[0].fixFeeTypeMap);
                  return Container(
                    child: ListView(
                      children: [
                        BuildExpandedV(
                          fixFeeTypeMap: this.fixFeeTypeMap,
                          data: generateItems(3,this.fixFeeTypeMap),
                          callback: (){
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  );
                }else{
                  return Center(child: Text('No data'),);
                }

              }else{
                return Center(child: CircularProgressIndicator(),);
              }
            },
          )
        );
      },
    );
  }
}

class BuildExpandedV extends StatefulWidget{
  BuildExpandedV({
    Key key,
    this.fixFeeTypeMap,
    this.data,
    this.callback,
}):super(key: key);
  final Map fixFeeTypeMap ;
  final List<Item> data;
  final Function callback;

  @override
  _BuildExpandedVState createState() => _BuildExpandedVState();
}

class _BuildExpandedVState extends State<BuildExpandedV>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ExpansionPanelList(
      dividerColor: Colors.white,
      elevation: 0,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          widget.data[index].isExpanded = !isExpanded;
        });
      },
      children: widget.data.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(item.headerValue + ' - (${item.feeTypeCostList.length})'),
            );
          },
          body: Container(

            child: Column(
              children: item.feeTypeCostList.map((item) {
                return ListTile(
                    title: Text('${item.type}'),
                    trailing: Icon(CupertinoIcons.arrow_right_arrow_left),
                  onTap: (){

                    Get.bottomSheet(
                      Container(
                        height: 200,
                        child: ListView(

                          children: Get.find<HouseL>().houseState.housesM.feeTypeList.map((e) {
                            return Container(
                              child: ListTile(
                                title: Text(e),
                                onTap: (){
                                  Get.defaultDialog(
                                      middleText: "是否确认替换，建议替换前进行备份。",
                                      onConfirm: (){
                                        item.type = e;
                                        Get.back();
                                        this.widget.callback();
                                      },
                                      onCancel: (){}
                                  );
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      backgroundColor: Colors.white,
                    );
                  },
                );
              }).toList(),
            ),
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}
class Item {
  Item({
    this.headerValue,
    this.isExpanded = true,
    this.feeTypeCostList,
    ///this.feeTypeCostListFromHouseM,
    this.index,
  });

  String headerValue;
  bool isExpanded;
  List<FeeTypeCost> feeTypeCostList;
  ///List<HouseM> feeTypeCostListFromHouseM;
  int index;
}

List<Item> generateItems(int numberOfItems, Map fixFeeTypeMap) {
  return List.generate(numberOfItems, (int index) {
    if(index == 0){
      return Item(
        headerValue: '支出记录',
        feeTypeCostList: matchFeeType(fixFeeTypeMap['expendH'], Get.find<HouseL>()),
        index: index,
      );
    }else if(index == 1){
      return Item(
        headerValue: '房间模版',
        feeTypeCostList: matchFeeType(fixFeeTypeMap['roomM'], Get.find<HouseL>()),
        index: index,
      );
    }else if(index == 2){
      return Item(
        headerValue: '房租记录',
        feeTypeCostList: matchFeeType(fixFeeTypeMap['roomH'], Get.find<HouseL>()),
        index: index,
      );
    }else{
      return Item();
    }
  });
}

List<FeeTypeCost> matchFeeType(List<FeeTypeCost> feeTypeList, HouseL houseL){
  List<FeeTypeCost> feeTL = [];
  for(var a in feeTypeList){
    if(!houseL.houseState.housesM.feeTypeList.contains(a.type)){
      feeTL.add(a);
    }
  }
  return feeTL;
}