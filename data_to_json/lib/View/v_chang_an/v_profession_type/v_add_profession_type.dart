import 'package:data_to_json/Controller/c_root.dart';
import 'package:data_to_json/Model/m_profession_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VAddProfessionType extends StatelessWidget{
  VAddProfessionType({Key? key}) : super(key: key);

  final TextEditingController _textEditingController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Profession Type"),
      ),
      body: GetX<CRoot>(
        dispose: (state){
          _textEditingController.dispose();
        },
        builder: (c){
          return Column(
            children: [
              _myTextField(c),
              const SizedBox(height: 20,),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: c.mProfessionTypeList.value.mProfessionTypeList.map((e) {
                    return ListTile(
                      title: Text(e.type),
                      onLongPress: (){
                        Get.defaultDialog(
                          title: 'Warning',
                          content: const Text('Delete ?'),
                          onCancel: (){},
                          onConfirm: (){
                            c.removeMProfessionType(e);
                            Get.back();
                          },
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  _myTextField(CRoot cRoot){
    var type = '';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: Get.width*0.7,
          child: TextField(
            controller: _textEditingController,
            onChanged: (text){
              type = text;
            },
          ),
        ),
        IconButton(
          onPressed: (){
            if(type != ''){
              cRoot.addMProfessionType(MProfessionType(type: type));
              _textEditingController.clear();
            }

          },
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}