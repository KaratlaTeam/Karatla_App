import 'dart:io';

import 'package:data_to_json/Controller/c_root.dart';
import 'package:data_to_json/Model/m_family.dart';
import 'package:data_to_json/Model/m_family_role.dart';
import 'package:data_to_json/Model/m_people.dart';
import 'package:data_to_json/Model/m_prop.dart';
import 'package:data_to_json/Model/m_prop_type.dart';
import 'package:data_to_json/Plugin/p_string.dart';
import 'package:data_to_json/Plugin/p_v.dart';
import 'package:data_to_json/View/v_chang_an/v_common_fang.dart';
import 'package:data_to_json/View/v_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class VCommonProp extends StatelessWidget{
  final Function(Rx<MProp>) initState;
  final Function(Rx<MProp>) submit;
  final String title;
  final String submitTitle;
  VCommonProp({
    Key? key,
    required this.initState,
    required this.submit,
    required this.title,
    required this.submitTitle,
  }) : super(key: key);

  final cRoot = Get.find<CRoot>();
  final _mProp = MProp.newOne().obs;

  final _nameController = TextEditingController().obs;
  final _contentController = TextEditingController().obs;

  final _oldImages = [].obs;

  @override
  Widget build(BuildContext context) {
    return GetX<CRoot>(
      initState: (state){
        initState(_mProp);

        if(_mProp.value.images.isNotEmpty){
          for (var element in _mProp.value.images) {
            _oldImages.add(element);
          }
        }

        _contentController.value = TextEditingController(text: _mProp.value.content);
        _nameController.value = TextEditingController(text: _mProp.value.name);
      },
      dispose: (state){
        _contentController.value.dispose();
        _nameController.value.dispose();
      },
      builder: (c){
        return Scaffold(
          appBar: AppBar(
            title: Text(title),
            actions: [
              TextButton(
                child: Text(submitTitle, style: const TextStyle(color: Colors.white),),
                onPressed: (){
                  cRoot.saveImage(_mProp.value.images, _oldImages, _mProp.value.uuid).then((value) {
                    _mProp.update((val){
                      val?.content = _contentController.value.text;
                      val?.name = _nameController.value.text;
                      val?.images = value;
                    });
                    submit(_mProp);
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
                          onPressed: ()async{
                            cRoot.pickImage((path){
                              _mProp.update((val) {
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
                  _nameController.value,
                  'Name',
                  height: 1,
                ),
                _propTypeDropDown(),
                _myTextField(
                  _contentController.value,
                  'Content',
                  height: 5,
                ),
              ]),
              _partCard([
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _myText('Owner'),
                    IconButton(
                      onPressed: (){
                        _mProp.update((val) {
                          val?.ownerUuid.insert(0,'');
                        });
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],),
                _ownerPart(context),
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

  _ownerPart(BuildContext context){
    return Column(
      children: _mProp.value.ownerUuid.asMap().map((index, e) {
        return MapEntry(
          index,
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                  IconButton(onPressed: (){
                    _mProp.update((val) {
                      val?.ownerUuid.removeAt(index);
                    });
                  }, icon: const Icon(Icons.remove_circle, color: Colors.red,),)
                ],
              ),
              const Divider(color: Colors.black,),
            ],
          ),
        );
      }).values.toList(),
    );
  }

  String _getMember(int index){
    if(_mProp.value.ownerUuid[index] == ''){
      return '';
    }else{
      var a1 = cRoot.getByUuid(_mProp.value.ownerUuid[index], cRoot.allPeople) as MPeople;
      return a1.nameList[0].fullName;
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
              _mProp.update((val) {
                val?.ownerUuid[mainIndex] = data[index].uuid;
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
      height: _mProp.value.images.isNotEmpty ? Get.height*0.2 : 5,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _mProp.value.images.length,
        itemBuilder: (context, index){
          return Card(
            //elevation: 5,
            child: InkWell(
              onTap: (){},
              onLongPress: (){
                _mProp.update((val) {
                  val?.images.removeAt(index);
                });
              },
              child: PVPhotoView(title: _mProp.value.images[index],),
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

  _propTypeDropDown(){
    TextStyle textStyle = const TextStyle(fontSize: 12);
    return Container(
      margin: EdgeInsets.only(left: Get.width*0.035),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DropdownButton(
            menuMaxHeight: 200,
            value: _mProp.value.mPropType,
            onChanged: (value){
              _mProp.update((val) {
                val?.mPropType = value as MPropType;
              });
            },
            items: cRoot.mPropTypeList.value.mPropTypeList.map((e) {
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