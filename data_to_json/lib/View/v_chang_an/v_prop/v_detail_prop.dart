import 'package:data_to_json/Controller/c_root.dart';
import 'package:data_to_json/Model/m_fang.dart';
import 'package:data_to_json/Model/m_people.dart';
import 'package:data_to_json/Plugin/p_string.dart';
import 'package:data_to_json/Plugin/p_v.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class VDetailProp extends StatelessWidget{
  VDetailProp({Key? key}) : super(key: key);
  final cRoot = Get.find<CRoot>();

  final String s = ':  ';
  final TextStyle _textStyle = const TextStyle(fontWeight: FontWeight.bold, color: Colors.black);
  final TextStyle _textStyle2 = const TextStyle(color: Colors.black54);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Obx(()=>Scaffold(
      appBar: AppBar(
        title: Text(cRoot.mProp?.name??''),
        actions: [
          TextButton(onPressed: (){
            Get.toNamed(PS.editProp);
          }, child: const Text('Edit',style: TextStyle(color: Colors.white),),),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(5),
        children: [
          _card([
            _myRow('Photo', '',textStyle: _textStyle),
            _photoListView()
          ],elevation: 0),
          _card([
            _myRow('Profile', '',textStyle: _textStyle),
            _myRow("ID$s", cRoot.mProp!.uuid, textStyle: _textStyle2,
              onLongPress: (){
                _longPressCallback(cRoot.mProp?.uuid??'','ID');
              },),
            _myRow('Name$s', cRoot.mProp?.name.toString()??'', textStyle: _textStyle2,
              onLongPress: (){_longPressCallback(cRoot.mProp?.name.toString()??'','StartDay');},),
            _myRow('Type$s', cRoot.mProp?.mPropType.type.toString()??'', textStyle: _textStyle2,
              onLongPress: (){_longPressCallback(cRoot.mProp?.mPropType.type.toString()??'','Type');},),

            _myRow("Content$s", '',textStyle: _textStyle2,
              onLongPress: (){_longPressCallback(cRoot.mProp?.content??'','Content');},),
            _myContent(cRoot.mProp?.content??''),
          ],elevation: 0),
          _card([
            _myRow('Other', '',textStyle: _textStyle),
            _myRow("Owner$s", cRoot.mProp?.ownerUuid.length.toString()??'', textStyle: _textStyle2,onTap: (){
              Get.to(()=> PVOtherDetailView(
                title: 'Owner',
                data: cRoot.mProp?.ownerUuid??[],
                trailing: (index){return '';},
                dataIndex: (index){
                  if(cRoot.mProp?.ownerUuid[index] != ''){
                    for(MPeople a in cRoot.allPeople){
                      if(a.uuid == cRoot.mProp?.ownerUuid[index]){
                        return a.nameList[0].fullName;
                      }
                    }
                  }
                  return '';
                },
              ));
            }),
          ],elevation: 0,bottom: 10),
        ],
      ),
    ));
  }

  _card(List<Widget> children, {double elevation = 5, double bottom = 0}){
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: elevation,
      child: Container(
        margin: EdgeInsets.only(top: 10,left: 10,right: 10, bottom: bottom),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  _longPressCallback (String text, String title){
    Clipboard.setData(ClipboardData(text: text));
    Get.showSnackbar(GetSnackBar(message: '复制 $title 成功',duration: const Duration(seconds: 1),));
  }

  _myRow(String title, String data, {TextStyle textStyle = const TextStyle(), GestureTapCallback? onTap, GestureLongPressCallback? onLongPress}){
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.only(top: 7.5, bottom: 7.5),
        child: Row(
          children: [
            RichText(text: TextSpan(
                children: [
                  TextSpan(text: title, style: textStyle),
                  TextSpan(text: data,style: const TextStyle(color: Colors.black)),
                ]
            )),
          ],
        ),
      ),
    );
  }

  _myContent(String data){
    return Container(
      margin: const EdgeInsets.only(top: 15),
      color: Colors.grey.shade50,
      height: 100,
      child: ListView(
        children: [
          Text(data),
        ],
      ),
    );
  }


  _photoListView(){
    return Container(
      padding: const EdgeInsets.all(2),
      height: cRoot.mProp?.images.isNotEmpty??false ? Get.height*0.2 : 5,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cRoot.mProp?.images.length,
        itemBuilder: (context, index){
          return Card(
            elevation: 0,
            child: PVPhotoView(title: cRoot.mProp?.images[index]??'',),
          );
        },
      ),
    );
  }
}