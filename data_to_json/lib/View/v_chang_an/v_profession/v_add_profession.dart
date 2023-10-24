import 'package:data_to_json/Controller/c_root.dart';
import 'package:data_to_json/Model/m_profession.dart';
import 'package:data_to_json/Model/m_profession_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VAddProfession extends StatelessWidget{
  VAddProfession({Key? key}) : super(key: key);

  final isExpandedList = [].obs;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final dropDownValue = Get.find<CRoot>().mProfessionTypeList.value.mProfessionTypeList.first.obs;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Profession"),
      ),
      body: GetX<CRoot>(
        initState: (state){
          for(var a in state.controller!.mProfessionTypeList.value.mProfessionTypeList){
            isExpandedList.add(false);
          }
        },
        dispose: (state){
          _titleController.dispose();
          _contentController.dispose();
        },
        builder: (c){

          return Column(
            children: [
              _myTextField(c),
              _myTextField2(c),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [IconButton(
                  onPressed: (){
                    if(_titleController.text != ''){

                      c.addMProfession(MProfession(
                        type: dropDownValue.value,
                        content: _contentController.text,
                        title: _titleController.text,
                      ));
                      _titleController.clear();
                      _contentController.clear();
                    }
                  },
                  icon: const Icon(Icons.add),
                ),],
              ),
              const SizedBox(height: 20,),
              Expanded(
                child: SingleChildScrollView(
                  child: ExpansionPanelList(
                    elevation: 0,
                    dividerColor: Colors.transparent,
                    expansionCallback: (i, check){
                      isExpandedList[i] = !check;
                    },
                    children: c.mProfessionTypeList.value.mProfessionTypeList.asMap().map((index, e) {
                      List<MProfession> list = c.getMProfessionListByOneType(e);
                      var value = ExpansionPanel(
                        isExpanded: isExpandedList[index],
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                            title: Text(e.toString()+" ${list.length}", style: const TextStyle(fontWeight: FontWeight.bold),),
                          );
                        },
                        body: Column(
                          children: list.map((a) {
                            return ListTile(
                              title: Text(a.toString()),
                              onLongPress: (){
                                Get.defaultDialog(
                                  title: 'Warning',
                                  content: const Text('Delete ?'),
                                  onCancel: (){},
                                  onConfirm: (){
                                    c.removeMProfession(a);
                                    Get.back();
                                  },
                                );
                              },
                              onTap: (){},
                            );
                          }).toList(),
                        ),
                      );
                      return MapEntry(index, value);
                    }).values.toList(),
                  ),
                )
              ),
            ],
          );
        },
      ),
    );
  }

  _myTextField(CRoot cRoot){

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: Get.width*0.9,
          child: TextField(
            controller: _titleController,
            decoration: InputDecoration(
                icon: DropdownButton<MProfessionType>(
                  underline: Container(),
                  value: dropDownValue.value,
                  menuMaxHeight: Get.height*0.3,
                  items: cRoot.mProfessionTypeList.value.mProfessionTypeList.map<DropdownMenuItem<MProfessionType>>((e) {
                    return DropdownMenuItem<MProfessionType>(
                      value: e,
                      child: Text(e.type),
                    );
                  }).toList(),
                  onChanged: ( MProfessionType? value){
                    dropDownValue.value = value!;
                  },
                ),
                label: const Text("Title")
            ),
            onChanged: (text){
            },
          ),
        ),

      ],
    );
  }


  _myTextField2(CRoot cRoot){

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: Get.width*0.9,
          child: TextField(
            controller: _contentController,
            maxLines: 5,
            decoration: const InputDecoration(
                label: Text("Content"),
                //contentPadding: EdgeInsets.only(bottom: 50),
            ),
            onChanged: (text){

            },
          ),
        ),

      ],
    );
  }
}