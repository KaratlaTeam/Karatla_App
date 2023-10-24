import 'package:data_to_json/Controller/c_root.dart';
import 'package:data_to_json/Model/m_building.dart';
import 'package:data_to_json/Model/m_event.dart';
import 'package:data_to_json/Model/m_people.dart';
import 'package:data_to_json/Plugin/p_v.dart';
import 'package:data_to_json/View/v_chang_an/v_common_fang.dart';
import 'package:data_to_json/View/v_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class VCommonEvent extends StatelessWidget{
  final Function(Rx<MEvent>) initState;
  final Function(Rx<MEvent>) submit;
  final String title;
  final String submitTitle;
  VCommonEvent({
    Key? key,
    required this.initState,
    required this.submit,
    required this.title,
    required this.submitTitle,
  }) : super(key: key);

  final cRoot = Get.find<CRoot>();
  final _mEvent = MEvent.newOne().obs;

  final _titleController = TextEditingController().obs;
  final _contentController = TextEditingController().obs;

  final _oldImages = [].obs;

  @override
  Widget build(BuildContext context) {
    return GetX<CRoot>(
      initState: (state){
        initState(_mEvent);

        if(_mEvent.value.images.isNotEmpty){
          for (var element in _mEvent.value.images) {
            _oldImages.add(element);
          }
        }

        _titleController.value = TextEditingController(text: _mEvent.value.title);
        _contentController.value = TextEditingController(text: _mEvent.value.content);
      },
      dispose: (state){
        _titleController.value.dispose();
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
                  cRoot.saveImage(_mEvent.value.images, _oldImages, _mEvent.value.uuid).then((value) {
                    _mEvent.update((val) {
                      val?.title = _titleController.value.text;
                      val?.content = _contentController.value.text;
                      val?.mLocationUuids[0] = cRoot.mFang?.uuid??'';
                      val?.images = value;
                    });
                    submit(_mEvent);
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
                              _mEvent.update((val) {
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
                  _titleController.value,
                  'Title',
                ),
                Slider(
                  min: 0, max: 9, divisions: 9,
                  value: _mEvent.value.level.toDouble(),
                  label: _mEvent.value.level.toString()+' 级',
                  onChanged: (newValue){
                    _mEvent.update((val) {
                      val?.level = newValue.toInt();
                    });
                  },
                ),
                _myTextField(
                  _contentController.value,
                  'Content',
                  height: 5,
                ),
                PVPickDate(
                  title: 'Start: '+_mEvent.value.startDay.toString(),
                  onDateTimeChanged: (value){
                    _mEvent.update((val) {
                      val?.startDay = MyDateTime(value.year,value.month,value.day);
                    });
                  },
                ).timePick1(context),
                PVPickDate(
                  title: 'End: '+_mEvent.value.endDay.toString(),
                  onDateTimeChanged: (value){
                    _mEvent.update((val) {
                      val?.endDay = MyDateTime(value.year,value.month,value.day);
                    });
                  },
                ).timePick1(context),
              ]),
              _partCard([
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _myText('相关人物'),
                    IconButton(
                      onPressed: (){
                        _mEvent.update((val) {
                          val?.relationPeopleUuids.insert(0, '');
                        });
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],),
                _relationPart(
                  context,
                  _mEvent.value.relationPeopleUuids,
                  onPress: (index){
                    _fangLocation('People',peopleListOnTap: (index2, data){
                      _mEvent.update((val) {
                        val?.relationPeopleUuids[index] = data[index2].uuid;
                      });
                      Get.back();
                    });
                  },
                  removeOnTap: (index){
                    _mEvent.update((val) {
                      val?.relationPeopleUuids.removeAt(index);
                    });
                  },
                  getName: (index){
                    return _getPeopleName(index);
                  },
                ),
              ]),
              _partCard([
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _myText('相关建筑'),
                    IconButton(
                      onPressed: (){
                        _mEvent.update((val) {
                          val?.relationBuildingUuids.insert(0, '');
                        });
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],),
                _relationPart(
                  context,
                  _mEvent.value.relationBuildingUuids,
                  onPress: (index){
                    _fangLocation('Building',buildingListOnTap: (index2, data){
                      _mEvent.update((val) {
                        val?.relationBuildingUuids[index] = data[index2].uuid;
                      });
                      Get.back();
                    });
                  },
                  removeOnTap: (index){
                    _mEvent.update((val) {
                      val?.relationBuildingUuids.removeAt(index);
                    });
                  },
                  getName: (index){
                    return _getBuildingName(index);
                  },
                ),
              ]),
            ],
          ),
        );
      },
    );
  }

  String _getPeopleName(int index){
    if(_mEvent.value.relationPeopleUuids[index] == ''){
      return '';
    }else{
      var a1 = cRoot.getByUuid(_mEvent.value.relationPeopleUuids[index], cRoot.allPeople) as MPeople;
      return a1.toString();
    }
  }
  String _getBuildingName(int index){
    if(_mEvent.value.relationBuildingUuids[index] == ''){
      return '';
    }else{
      var a1 = cRoot.getByUuid(_mEvent.value.relationBuildingUuids[index], cRoot.allBuilding) as MBuilding;
      return a1.toString();
    }
  }

  _fangLocation(String type,{Function(int, List<MBuilding>)? buildingListOnTap, Function(int, List<MPeople>)? peopleListOnTap,}){
    Get.to(() => Scaffold(
      appBar: AppBar(),
      body: VChangAn(
        onTapFang: (mFang){
          Get.off(()=>VCommonFang(
            floatActionButton: false,
            mFang: mFang,
            newTypes: [type],
            peopleListOnTap: peopleListOnTap,
            buildingListOnTap: buildingListOnTap,
          ));
        },
      ),
    ));
  }

  _relationPart(BuildContext context, List data,{Function(int)? removeOnTap, Function(int)? onPress, String Function(int)? getName }){
    return Column(
      children: data.asMap().map((index, e) {
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
                          onPress!(index);
                        },
                        child: Text('- ${getName!(index)}', style: const TextStyle(color: Colors.black),),
                      ),
                    ],),
                  ),
                  IconButton(onPressed: (){removeOnTap!(index);}, icon: const Icon(Icons.remove_circle, color: Colors.red,),)
                ],
              ),
              const Divider(color: Colors.black,),
            ],
          ),
        );
      }).values.toList(),
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

  _photoListView(){
    return Container(
      padding: const EdgeInsets.all(2),
      height: _mEvent.value.images.isNotEmpty ? Get.height*0.2 : 5,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _mEvent.value.images.length,
        itemBuilder: (context, index){
          return Card(
            //elevation: 5,
            child: InkWell(
              onTap: (){},
              onLongPress: (){
                _mEvent.update((val) {
                  val?.images.removeAt(index);
                });
              },
              child: PVPhotoView(title: _mEvent.value.images[index],),
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
}