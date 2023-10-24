import 'package:data_to_json/Controller/c_root.dart';
import 'package:data_to_json/Model/m_building.dart';
import 'package:data_to_json/Model/m_event.dart';
import 'package:data_to_json/Model/m_family.dart';
import 'package:data_to_json/Model/m_fang.dart';
import 'package:data_to_json/Model/m_prop.dart';
import 'package:data_to_json/Plugin/p_string.dart';
import 'package:data_to_json/Plugin/p_v.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class VDetailPeople extends StatelessWidget{
  VDetailPeople({Key? key}) : super(key: key);
  final cRoot = Get.find<CRoot>();

  final String s = ':  ';
  final TextStyle _textStyle = const TextStyle(fontWeight: FontWeight.bold, color: Colors.black);
  final TextStyle _textStyle2 = const TextStyle(color: Colors.black54);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Obx(()=>Scaffold(
      appBar: AppBar(
        title: Text("${cRoot.mPeople?.nameList[0].fullName}"),
        actions: [
          TextButton(onPressed: (){
            Get.toNamed(PS.editPeople);
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
            _myRow("ID$s", cRoot.mPeople!.uuid, textStyle: _textStyle2,
            onLongPress: (){
              _longPressCallback(cRoot.mPeople?.uuid??'','ID');
            },),
            _myRow("Name$s", cRoot.mPeople.toString(), textStyle: _textStyle2,
              onLongPress: (){_longPressCallback(cRoot.mPeople.toString(),'Name');},
            ),
            _myRow('Gender$s', cRoot.mPeople?.gender??'', textStyle: _textStyle2,
              onLongPress: (){_longPressCallback(cRoot.mPeople?.gender??'','Gender');},),
            _myRow('Birthday$s', cRoot.mPeople?.birthday.toString()??'', textStyle: _textStyle2,
              onLongPress: (){_longPressCallback(cRoot.mPeople?.birthday.toString()??'','Birthday');},),
            _myRow('DeadDay$s', cRoot.mPeople?.deadDay.toString()??'', textStyle: _textStyle2,
              onLongPress: (){_longPressCallback(cRoot.mPeople?.deadDay.toString()??'','DeaDay');},),
            _myRow('Location$s', _getLocation(), textStyle: _textStyle2,
              onLongPress: (){_longPressCallback(_getLocation(),'Location');},),
            _myRow("Content$s", '',textStyle: _textStyle2,
              onLongPress: (){_longPressCallback(cRoot.mPeople?.content??'','Content');},),
            _myContent(cRoot.mPeople?.content??''),
          ],elevation: 0),
          _card([
            _myRow('Other', '',textStyle: _textStyle),
            _myRow('Work$s', cRoot.mPeople?.mWorkingList.length.toString()??'', textStyle: _textStyle2,
              onTap: (){
                Get.to(()=> PVOtherDetailView(
                  title: '工作',
                  trailing: (index){
                    return cRoot.mPeople?.mWorkingList[index].mProfession.type.type??'-';
                  },
                  data: cRoot.mPeople?.mWorkingList??[],
                  dataIndex: (index){
                    return cRoot.mPeople?.mWorkingList[index].mProfession.title??'-';
                  },
                ));
              },),
            _myRow('Family$s', _getFamily().length.toString(), textStyle: _textStyle2,
              onTap: (){
                Get.to(()=> PVOtherDetailView(
                  title: '家庭',
                  trailing: (index){return '';},
                  data: _getFamily(),
                  dataIndex: (index){
                    return _getFamily()[index].familyName;
                  },
                  //actions: [
                  //  TextButton(onPressed: (){
                  //    Get.to(()=> PVFamilyTree());
                  //  }, child: const Text('家谱',style: TextStyle(color: Colors.white),))
                  //],
                ));
              },),
            _myRow('Event$s', _getEvent().length.toString(), textStyle: _textStyle2,
              onTap: (){
                Get.to(()=> PVOtherDetailView(
                  title: '事件',
                  trailing: (index){return '';},
                  data: _getEvent(),
                  dataIndex: (index){
                    return _getEvent()[index].title;
                  },
                ));
              },),
            _myRow('Building$s', _getBuilding().length.toString(), textStyle: _textStyle2,
              onTap: (){
                Get.to(()=> PVOtherDetailView(
                  title: '建筑',
                  trailing: (index){return '';},
                  data: _getBuilding(),
                  dataIndex: (index){
                    return _getBuilding()[index].name;
                  },
                ));
              },),
            _myRow('Prop$s', _getProp().length.toString(), textStyle: _textStyle2,
              onTap: (){
                Get.to(()=> PVOtherDetailView(
                  title: '道具',
                  trailing: (index){return '';},
                  data: _getProp(),
                  dataIndex: (index){
                    return _getProp()[index].name;
                  },
                ));
              },),
          ],elevation: 0,bottom: 10),
        ],
      ),
    ));
  }

  List<MBuilding> _getBuilding(){
    List<MBuilding> data = [];
    for(MBuilding a in cRoot.allBuilding){
      for(var b in a.ownerUuid){
        if(b == cRoot.mPeople?.uuid){
          data.add(a);
          break;
        }
      }
    }
    return data;
  }

  List<MEvent> _getEvent(){
    List<MEvent> data = [];
    for(MEvent a in cRoot.allEvent){
      for(var b in a.relationPeopleUuids){
        if(b == cRoot.mPeople?.uuid){
          data.add(a);
          break;
        }
      }
    }
    return data;
  }

  List<MProp> _getProp(){
    List<MProp> data = [];
    for(MProp a in cRoot.mPropList.value.mPropList){
      for(var b in a.ownerUuid){
        if(b == cRoot.mPeople?.uuid){
          data.add(a);
          break;
        }
      }
    }
    return data;
  }

  List<MFamily> _getFamily(){
    List<MFamily> data = [];
    for(MFamily a in cRoot.allFamily){
      for(var b in a.familyMembers){
        if(b.peopleUuid == cRoot.mPeople?.uuid){
          data.add(a);
          break;
        }
      }
    }
    return data;
  }

  String _getLocation(){
    var a1 = cRoot.getByUuid(cRoot.mPeople?.mLocationUuids[0], cRoot.mFangList.value.mFangList) as MFang;
    return a1.toString();
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
      height: cRoot.mPeople?.images.isNotEmpty??false ? Get.height*0.2 : 5,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cRoot.mPeople?.images.length,
        itemBuilder: (context, index){
          return Card(
            elevation: 0,
            child: InkWell(
              child: PVPhotoView(title: cRoot.mPeople?.images[index]??'',),
            ),
          );
        },
      ),
    );
  }

}