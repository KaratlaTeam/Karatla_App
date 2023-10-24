import 'package:data_to_json/Controller/c_root.dart';
import 'package:data_to_json/Model/m_building.dart';
import 'package:data_to_json/Model/m_people.dart';
import 'package:data_to_json/Plugin/p_v.dart';
import 'package:data_to_json/View/v_chang_an/v_common_fang.dart';
import 'package:data_to_json/View/v_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class VCommonBuilding extends StatelessWidget{
  final Function(Rx<MBuilding>) initState;
  final Function(Rx<MBuilding>) submit;
  final String title;
  final String submitTitle;
  VCommonBuilding({
    Key? key,
    required this.initState,
    required this.submit,
    required this.title,
    required this.submitTitle,
  }) : super(key: key);

  final cRoot = Get.find<CRoot>();
  final _mBuilding = MBuilding.newOne().obs;

  final _nameController = TextEditingController().obs;
  final _contentController = TextEditingController().obs;

  final _oldImages = [].obs;

  @override
  Widget build(BuildContext context) {
    return GetX<CRoot>(
      initState: (state){
        initState(_mBuilding);

        if(_mBuilding.value.images.isNotEmpty){
          for (var element in _mBuilding.value.images) {
            _oldImages.add(element);
          }
        }

        _nameController.value = TextEditingController(text: _mBuilding.value.name);
        _contentController.value = TextEditingController(text: _mBuilding.value.content);
      },
      dispose: (state){
        _nameController.value.dispose();
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
                  cRoot.saveImage(_mBuilding.value.images, _oldImages, _mBuilding.value.uuid).then((value) {
                    _mBuilding.update((val) {
                      val?.name = _nameController.value.text;
                      val?.content = _contentController.value.text;
                      val?.mLocationUuids[0] = cRoot.mFang?.uuid??'';
                      val?.images = value;
                    });
                    submit(_mBuilding);
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
                              _mBuilding.update((val) {
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
                ),
                _myTextField(
                  _contentController.value,
                  'Content',
                  height: 5,
                ),
                PVPickDate(
                  title: 'Start: '+_mBuilding.value.createDay.toString(),
                  onDateTimeChanged: (value){
                    _mBuilding.update((val) {
                      val?.createDay = MyDateTime(value.year,value.month,value.day);
                    });
                  },
                ).timePick1(context),
                PVPickDate(
                  title: 'End: '+_mBuilding.value.endDay.toString(),
                  onDateTimeChanged: (value){
                    _mBuilding.update((val) {
                      val?.endDay = MyDateTime(value.year,value.month,value.day);
                    });
                  },
                ).timePick1(context),
              ]),
              _partCard([
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _myText('Owner'),
                    IconButton(
                      onPressed: (){
                        _mBuilding.update((val) {
                          val?.ownerUuid.insert(0, '');
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

  _ownerPart(BuildContext context){
    return Column(
      children: _mBuilding.value.ownerUuid.asMap().map((index, e) {
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
                        child: Text('Name: ${_getName(index)}', style: const TextStyle(color: Colors.black),),
                      ),
                    ],),
                  ),
                  IconButton(onPressed: (){
                    _mBuilding.update((val) {
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
              _mBuilding.update((val) {
                val?.ownerUuid[mainIndex] = data[index].uuid;
              });
              Get.back();
            },
          ));
        },
      ),
    ));
  }

  String _getName(int index){
    if(_mBuilding.value.ownerUuid[index] == ''){
      return '';
    }else{
      var a1 = cRoot.getByUuid(_mBuilding.value.ownerUuid[index], cRoot.allPeople) as MPeople;
      return a1.toString();
    }

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
      height: _mBuilding.value.images.isNotEmpty ? Get.height*0.2 : 5,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _mBuilding.value.images.length,
        itemBuilder: (context, index){
          return Card(
            //elevation: 5,
            child: InkWell(
              onTap: (){},
              onLongPress: (){
                _mBuilding.update((val) {
                  val?.images.removeAt(index);
                });
              },
              child: PVPhotoView(title: _mBuilding.value.images[index],),
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