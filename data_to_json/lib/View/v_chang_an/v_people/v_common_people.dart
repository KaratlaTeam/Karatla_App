import 'package:data_to_json/Controller/c_root.dart';
import 'package:data_to_json/Model/m_fang.dart';
import 'package:data_to_json/Model/m_people.dart';
import 'package:data_to_json/Model/m_profession.dart';
import 'package:data_to_json/Model/m_profession_type.dart';
import 'package:data_to_json/Plugin/p_v.dart';
import 'package:data_to_json/View/v_chang_an/v_common_fang.dart';
import 'package:data_to_json/View/v_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class VCommonPeople extends StatelessWidget{
  final Function(Rx<MPeople>) initState;
  final Function(Rx<MPeople>) submit;
  final String title;
  final String submitTitle;
  VCommonPeople({
    Key? key,
    required this.initState,
    required this.submit,
    required this.title,
    required this.submitTitle,
  }) : super(key: key);

  final cRoot = Get.find<CRoot>();
  final _mPeople = MPeople.newOne().obs
    ..value.nameList.insert(0, MName.newOne());

  final _genderList = ['Male', 'Female'];

  final _lastNameController = TextEditingController().obs;
  final _firstNameController = TextEditingController().obs;
  final _contentController = TextEditingController().obs;

  final _oldImages = [].obs;

  @override
  Widget build(BuildContext context) {
    return GetX<CRoot>(
      initState: (state){
        initState(_mPeople);

        if(_mPeople.value.images.isNotEmpty){
          for (var element in _mPeople.value.images) {
            _oldImages.add(element);
          }
        }

        _lastNameController.value = TextEditingController(text: _mPeople.value.nameList[0].lastName);
        _firstNameController.value = TextEditingController(text: _mPeople.value.nameList[0].firstName);
        _contentController.value = TextEditingController(text: _mPeople.value.content);
      },
      dispose: (state){
        _lastNameController.value.dispose();
        _firstNameController.value.dispose();
        _contentController.value.dispose();
      },
      builder: (c){
        return Scaffold(
          appBar: AppBar(
            title: Text(title),
            actions: [
              TextButton(
                child: Text(submitTitle, style: const TextStyle(color: Colors.white),),
                onPressed: (){
                  cRoot.saveImage(_mPeople.value.images, _oldImages, _mPeople.value.uuid).then((value) {
                    _mPeople.update((val) {
                      val?.nameList[0].lastName = _lastNameController.value.text;
                      val?.nameList[0].firstName = _firstNameController.value.text;
                      val?.nameList[0].createDay = _mPeople.value.birthday;

                      val?.content = _contentController.value.text;
                      val?.mLocationUuids[0] = cRoot.mFang?.uuid;
                      val?.images = value;
                    });
                    submit(_mPeople);
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
                              _mPeople.update((val) {
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
                _genderDropDown(''),
                _myTextField(
                  _lastNameController.value,
                  'Last Name',
                ),
                _myTextField(
                  _firstNameController.value,
                  'First Name',
                ),
                _myTextField(
                  _contentController.value,
                  'Content',
                  height: 5,
                ),
                PVPickDate(
                  onDateTimeChanged: (value){
                    _mPeople.update((val) {
                      val?.birthday = MyDateTime(value.year,value.month,value.day);
                    });
                  },
                  title: 'Birthday: ${_mPeople.value.birthday}',
                ).timePick1(context),
                PVPickDate(
                  onDateTimeChanged: (value){
                    _mPeople.update((val) {
                      val?.deadDay = MyDateTime(value.year,value.month,value.day);
                    });
                  },
                  title: 'DeadDay: ${_mPeople.value.deadDay}',
                ).timePick1(context),
              ]),
              _partCard([
                Row(children: [
                  _myText('Working'),
                  IconButton(onPressed: (){
                    _mPeople.update((val) {
                      val?.mWorkingList.insert(0, MWorking.newOne());
                      var a = cRoot.getMProfessionListByOneType(cRoot.mProfessionTypeList.value.mProfessionTypeList.first);
                      if(a.isNotEmpty){
                        val?.mWorkingList[0].mProfession = MProfession.fromJson(a[0].toJson());
                      }else{
                        val?.mWorkingList[0].mProfession.type = MProfessionType.fromJson(cRoot.mProfessionTypeList.value.mProfessionTypeList[0].toJson());
                      }
                    });
                  }, icon: const Icon(Icons.add)),
                ],mainAxisAlignment: MainAxisAlignment.spaceBetween,),
                _workingPart(),
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

  _workingPart(){
    return Column(
      children: _mPeople.value.mWorkingList.asMap().map((index, e) {
        return MapEntry(
          index,
          Column(
            children: [
              _professionDropDown('$index', index),
              Slider(
                label: _mPeople.value.mWorkingList[index].level.toString()+' 级',
                value: _mPeople.value.mWorkingList[index].level.toDouble(),
                min: 0, max: 9,
                divisions: 9,
                onChanged: (newValue){
                  _mPeople.update((val) {
                    val?.mWorkingList[index].level = newValue.toInt();
                  });
                },
              ),
              Row(children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.white,elevation: 0),
                  onPressed: (){
                    _fangLocation(index);
                  },
                  child: Text('Location ${_getLocation(index)} ', style: const TextStyle(color: Colors.black),),
                ),
              ],),
              const Divider(color: Colors.black,),
            ],
          ),
        );
      }).values.toList(),
    );
  }

  String _getLocation(int index){
    if(_mPeople.value.mWorkingList[index].mLocationUuids[0] == ''){
      return '';
    }else{
      var a1 = cRoot.getByUuid(_mPeople.value.mWorkingList[index].mLocationUuids[0], cRoot.mFangList.value.mFangList) as MFang;
      var a2 = cRoot.getByUuid(_mPeople.value.mWorkingList[index].mLocationUuids[1], a1.buildings.mBuildingList);
      return a1.toString()+' - '+a2.toString();
    }

  }


  _fangLocation(int mainIndex){
    Get.to(() => Scaffold(
      appBar: AppBar(),
      body: VChangAn(
        onTapFang: (mFang){
          _mPeople.update((val) {
            val?.mWorkingList[mainIndex].mLocationUuids[0] = mFang.uuid;
          });
          Get.off(()=>VCommonFang(
            floatActionButton: false,
            mFang: mFang,
            newTypes: const ['Building'],
            buildingListOnTap: (index, data){
              _mPeople.update((val) {
                val?.mWorkingList[mainIndex].mLocationUuids[1] = data[index].uuid;
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
      height: _mPeople.value.images.isNotEmpty ? Get.height*0.2 : 5,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _mPeople.value.images.length,
        itemBuilder: (context, index){
          return Card(
            //elevation: 5,
            child: InkWell(
              onTap: (){},
              onLongPress: (){
                _mPeople.update((val) {
                  val?.images.removeAt(index);
                });
              },
              child: PVPhotoView(title: _mPeople.value.images[index],),
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


  _genderDropDown(String title,){

    return Container(
      margin: EdgeInsets.only(left: Get.width*0.035),
      child: Row(
        children: [
          Text(title),
          DropdownButton(
            value: _mPeople.value.gender,
            onChanged: (value){
              _mPeople.update((val) {
                val?.gender = value as String;
              });
            },
            items: _genderList.map((e) {
              return DropdownMenuItem(
                value: e,
                child: Text(e.toString(), style: const TextStyle(fontSize: 12),),
              );
            }).toList(),
            underline: Container(),
          ),
        ],
      ),
    );
  }

  _professionDropDown(String title, int index){
    TextStyle textStyle = const TextStyle(fontSize: 12);
    return Container(
      margin: EdgeInsets.only(left: Get.width*0.035),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DropdownButton(
            value: _mPeople.value.mWorkingList[index].mProfession.type,
            onChanged: (value){
              _mPeople.update((val) {
                var a = cRoot.getMProfessionListByOneType(value as MProfessionType);
                if(a.isNotEmpty){
                  val?.mWorkingList[index].mProfession = MProfession.fromJson(a[0].toJson());
                }else{
                  val?.mWorkingList[index].mProfession.type = MProfessionType.fromJson(value.toJson());
                }
              });
            },
            items: cRoot.mProfessionTypeList.value.mProfessionTypeList.map((e) {
              return DropdownMenuItem(
                value: e,
                child: Text(e.toString(), style: textStyle,),
              );
            }).toList(),
            underline: Container(),
          ),
          DropdownButton(
            value: _mPeople.value.mWorkingList[index].mProfession,
            onChanged: (value){
              _mPeople.update((val) {
                val?.mWorkingList[index].mProfession = MProfession.fromJson((value as MProfession).toJson());
              });
            },
            items: cRoot.getMProfessionListByOneType(_mPeople.value.mWorkingList[index].mProfession.type).map((e) {
              return DropdownMenuItem(
                value: e,
                child: Text(e.title, style: textStyle,),
              );
            }).toList(),
            underline: Container(),
          ),
          IconButton(onPressed: (){
            _mPeople.update((val) {
              val?.mWorkingList.removeAt(index);
            });
          }, icon: const Icon(Icons.remove_circle,color: Colors.red,)),
        ],
      ),
    );
  }
}