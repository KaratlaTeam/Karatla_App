import 'package:data_to_json/Controller/c_root.dart';
import 'package:data_to_json/Model/m_family.dart';
import 'package:data_to_json/Model/m_fang.dart';
import 'package:data_to_json/Model/m_people.dart';
import 'package:data_to_json/Plugin/p_string.dart';
import 'package:data_to_json/Plugin/p_v.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class VDetailFamily extends StatelessWidget{
  VDetailFamily({Key? key}) : super(key: key);
  final cRoot = Get.find<CRoot>();

  final String s = ':  ';
  final TextStyle _textStyle = const TextStyle(fontWeight: FontWeight.bold, color: Colors.black);
  final TextStyle _textStyle2 = const TextStyle(color: Colors.black54);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Obx(()=>Scaffold(
      appBar: AppBar(
        title: Text(cRoot.mFamily?.familyName??''),
        actions: [
          TextButton(onPressed: (){
            Get.toNamed(PS.editFamily);
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
            _myRow("ID$s", cRoot.mFamily!.uuid, textStyle: _textStyle2,
              onLongPress: (){
                _longPressCallback(cRoot.mFamily?.uuid??'','ID');
              },),
            _myRow("Family Name$s", cRoot.mFamily?.familyName??'', textStyle: _textStyle2,
              onLongPress: (){_longPressCallback(_getName(),'Family Name');},
            ),
            _myRow('StartDay$s', cRoot.mFamily?.startFamilyDay.toString()??'', textStyle: _textStyle2,
              onLongPress: (){_longPressCallback(cRoot.mFamily?.startFamilyDay.toString()??'','StartDay');},),
            _myRow('EndDay$s', cRoot.mFamily?.endFamilyDay.toString()??'', textStyle: _textStyle2,
              onLongPress: (){_longPressCallback(cRoot.mFamily?.endFamilyDay.toString()??'','EndDay');},),

            _myRow('Location$s', _getLocation2(), textStyle: _textStyle2,
              onLongPress: (){_longPressCallback(_getLocation2(),'Location');},),
            _myRow("Content$s", '',textStyle: _textStyle2,
              onLongPress: (){_longPressCallback(cRoot.mFamily?.content??'','Content');},),
            _myContent(cRoot.mFamily?.content??''),
          ],elevation: 0),
          _card([
            _myRow('Other', '',textStyle: _textStyle),
            _myRow("家庭成员$s", cRoot.mFamily?.familyMembers.length.toString()??'', textStyle: _textStyle2,onTap: (){
              Get.to(()=> PVOtherDetailView(
                title: '家庭成员',
                data: cRoot.mFamily?.familyMembers??[],
                trailing: (index){
                  return cRoot.mFamily?.familyMembers[index].role.role??'';
                },
                dataIndex: (index){
                  if(cRoot.mFamily?.familyMembers[index].peopleUuid != ''){
                    for(MPeople a in cRoot.allPeople){
                      if(a.uuid == cRoot.mFamily?.familyMembers[index].peopleUuid){
                        return a.nameList[0].fullName;
                      }
                    }
                  }
                  return '';
                },
                //actions: [
                //  TextButton(onPressed: (){
                //    //Get.to(()=>PVFamilyTree());
                //  }, child: const Text('家谱',style: TextStyle(color: Colors.white),))
                //],
              ));
            }),
          ],elevation: 0,bottom: 10),
        ],
      ),
    ));
  }
  String _getName(){
    var a1 = cRoot.getByUuid(cRoot.mFamily?.familyMembers[0].peopleUuid??'', cRoot.allPeople);
    return a1.toString();
  }

  String _getLocation2(){
    var a1 = cRoot.getByUuid(cRoot.mFamily?.mLocationUuids[0]??'', cRoot.mFangList.value.mFangList) as MFang;
    var a2 = cRoot.getByUuid(cRoot.mEvent?.mLocationUuids[1]??'', a1.buildings.mBuildingList);
    return a1.toString()+' - '+a2.toString();
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
      height: cRoot.mFamily?.images.isNotEmpty??false ? Get.height*0.2 : 5,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cRoot.mFamily?.images.length,
        itemBuilder: (context, index){
          return Card(
            elevation: 0,
            child: InkWell(
              child: PVPhotoView(title: cRoot.mFamily?.images[index]??'',),
            ),
          );
        },
      ),
    );
  }
}