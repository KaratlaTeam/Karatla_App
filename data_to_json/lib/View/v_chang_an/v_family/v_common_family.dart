import 'package:data_to_json/Controller/c_root.dart';
import 'package:data_to_json/Model/m_family.dart';
import 'package:data_to_json/Model/m_family_role.dart';
import 'package:data_to_json/Model/m_people.dart';
import 'package:data_to_json/Plugin/p_string.dart';
import 'package:data_to_json/Plugin/p_v.dart';
import 'package:data_to_json/View/v_chang_an/v_common_fang.dart';
import 'package:data_to_json/View/v_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class VCommonFamily extends StatelessWidget{
  final Function(Rx<MFamily>) initState;
  final Function(Rx<MFamily>) submit;
  final String title;
  final String submitTitle;
  VCommonFamily({
    Key? key,
    required this.initState,
    required this.submit,
    required this.title,
    required this.submitTitle,
  }) : super(key: key);

  final cRoot = Get.find<CRoot>();
  final _mFamily = MFamily.newOne().obs;

  final _familyNameController = TextEditingController().obs;
  final _contentController = TextEditingController().obs;

  final _oldImages = [].obs;

  @override
  Widget build(BuildContext context) {
    return GetX<CRoot>(
      initState: (state){
        initState(_mFamily);

        if(_mFamily.value.images.isNotEmpty){
          for (var element in _mFamily.value.images) {
            _oldImages.add(element);
          }
        }

       _contentController.value = TextEditingController(text: _mFamily.value.content);
       _familyNameController.value = TextEditingController(text: _mFamily.value.familyName);
      },
      dispose: (state){
        _contentController.value.dispose();
        _familyNameController.value.dispose();
      },
      builder: (c){
        return Scaffold(
          appBar: AppBar(
            title: Text(title),
            actions: [
              TextButton(
                child: Text(submitTitle, style: const TextStyle(color: Colors.white),),
                onPressed: (){
                  cRoot.saveImage(_mFamily.value.images, _oldImages, _mFamily.value.uuid).then((value) {
                    _mFamily.update((val) {
                      val?.content = _contentController.value.text;
                      val?.familyName = _familyNameController.value.text;
                      val?.mLocationUuids[0] = cRoot.mFang?.uuid??'';
                      val?.images = value;
                    });
                    submit(_mFamily);
                    Get.back();
                  });

                },
              ),
            ],
          ),
          body: ListView(
            //padding: EdgeInsets.all(Get.width*0.05),
            children: [
              _partCard([
                Row(
                  children: [
                    _myText('Photo'),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: (){
                            cRoot.pickImage((path){
                              _mFamily.update((val) {
                                val?.images.insert(0, path);
                              });
                            });
                          },
                          icon: const Icon(Icons.add),
                        ),
                      ),
                    ),
                  ],
                ),
                _photoListView(),
              ]),
              _partCard([
                Row(children: [_myText('Profile'),],),
                _myTextField(
                 _familyNameController.value,
                  'Family Name',
                  height: 1,
                ),
                _myTextField(
                  _contentController.value,
                  'Content',
                  height: 5,
                ),
                PVPickDate(
                  title: 'Start: '+_mFamily.value.startFamilyDay.toString(),
                  onDateTimeChanged: (value){
                    _mFamily.update((val) {
                      val?.startFamilyDay = MyDateTime(value.year,value.month,value.day);
                    });
                  },
                ).timePick1(context),
                PVPickDate(
                  title: 'End: '+_mFamily.value.endFamilyDay.toString(),
                  onDateTimeChanged: (value){
                    _mFamily.update((val) {
                      val?.endFamilyDay = MyDateTime(value.year,value.month,value.day);
                    });
                  },
                ).timePick1(context),
              ]),
              _partCard([
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  _myText('长辈'),
                  IconButton(
                    onPressed: (){
                      _mFamily.update((val) {
                        val?.familyMembers.insert(0, MFamilyMember.newOne()..role = cRoot.mFamilyRoleList.value.mFamilyRoleList[0]..level=0);
                      });
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],),
                _memberPart(context,0),
              ]),
              _partCard([
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _myText('小辈'),
                    IconButton(
                      onPressed: (){
                        _mFamily.update((val) {
                          val?.familyMembers.insert(0, MFamilyMember.newOne()..role = cRoot.mFamilyRoleList.value.mFamilyRoleList[0]..level=1);
                        });
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],),
                _memberPart(context,1),
              ]),
            ],
          ),
        );
      },
    );
  }

  Widget _partCard(List<Widget> data){
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child: Column(
          children: data,
        ),
      ),
    );
  }

  _memberPart(BuildContext context, int level){
    return Column(
      children: _mFamily.value.familyMembers.asMap().map((index, e) {
        return MapEntry(
          index,
          e.level != level ? Container() : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _familyRoleDropDown(index),
                  IconButton(onPressed: (){
                    _mFamily.update((val) {
                      val?.familyMembers.removeAt(index);
                    });
                  }, icon: const Icon(Icons.remove_circle, color: Colors.red,),)
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: Get.width*0.02),
                child: Row(children: [
                  TextButton(
                    style: ElevatedButton.styleFrom(primary: Colors.white,elevation: 0),
                    onPressed: (){
                      _fangLocation(index);
                    },
                    child: Text('Name: ${_getMember(index)}', style: const TextStyle(color: Colors.black),),
                  ),
                ],),
              ),
              PVPickDate(
                title: 'Start: '+_mFamily.value.familyMembers[index].startDay.toString(),
                onDateTimeChanged: (value){
                  _mFamily.update((val) {
                    val?.familyMembers[index].startDay = MyDateTime(value.year,value.month,value.day);
                  });
                },
              ).timePick1(context),
              PVPickDate(
                title: 'End: '+_mFamily.value.familyMembers[index].endDay.toString(),
                onDateTimeChanged: (value){
                  _mFamily.update((val) {
                    val?.familyMembers[index].endDay = MyDateTime(value.year,value.month,value.day);
                  });
                },
              ).timePick1(context),
              const Divider(color: Colors.black,),
            ],
          ),
        );
      }).values.toList(),
    );
  }

  String _getMember(int index){
    if(_mFamily.value.familyMembers[index].peopleUuid == ''){
      return '';
    }else{
      var a1 = cRoot.getByUuid(_mFamily.value.familyMembers[index].peopleUuid, cRoot.allPeople);
      if(a1!=''){
        a1 = a1 as MPeople;
        return a1.nameList[0].fullName;
      }else{
        return '';
      }

    }

  }

  _fangLocation(int mainIndex){
    Get.to(() => Scaffold(
      appBar: AppBar(),
      body: VChangAn(
        onTapFang: (mFang){
          Get.off(()=>VCommonFang(
            floatActionButton: false,
            mFang: mFang,
            newTypes: const ['People'],
            peopleListOnTap: (index, data){
              _mFamily.update((val) {
                val?.familyMembers[mainIndex].peopleUuid = data[index].uuid;
              });
              Get.back();
            },
          ));
        },
      ),
    ));
  }

  _photoListView(){
    return Container(
      padding: const EdgeInsets.all(2),
      height: _mFamily.value.images.isNotEmpty ? Get.height*0.2 : 5,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _mFamily.value.images.length,
        itemBuilder: (context, index){
          return Card(
            child: InkWell(
              onTap: (){},
              onLongPress: (){
                _mFamily.update((val) {
                  val?.images.removeAt(index);
                });
              },
              child: PVPhotoView(title: _mFamily.value.images[index],),
            ),
          );
        },
      ),
    );
  }

  _myText(String text){
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  _myTextField(
      TextEditingController textEditingController,
      String title,
      {
        int height = 1,
        String regExp = r"[\s\S]",
        ValueChanged<String>? onChange,
      }
      ){
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: Get.width*0.8,
            child: TextField(
              controller: textEditingController,
              maxLines: height,
              decoration: InputDecoration(
                border: InputBorder.none,
                label: Text(title),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(regExp)),
              ],
              onChanged: onChange,
            ),
          ),
        ],
      ),
    );
  }

  _familyRoleDropDown(int index){
    TextStyle textStyle = const TextStyle(fontSize: 12);
    return Container(
      margin: EdgeInsets.only(left: Get.width*0.035),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DropdownButton(
            menuMaxHeight: 200,
            value: _mFamily.value.familyMembers[index].role,
            onChanged: (value){
              _mFamily.update((val) {
                val?.familyMembers[index].role = value as MFamilyRole;
              });
            },
            items: cRoot.mFamilyRoleList.value.mFamilyRoleList.map((e) {
              return DropdownMenuItem(
                value: e,
                child: Text(e.toString(), style: textStyle,),
              );
            }).toList(),
            underline: Container(),
          ),
        ],
      ),
    );
  }
}