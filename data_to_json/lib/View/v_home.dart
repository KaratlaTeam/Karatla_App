import 'package:data_to_json/Controller/c_root.dart';
import 'package:data_to_json/Model/m_fang.dart';
import 'package:data_to_json/Plugin/p_string.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VHome extends StatelessWidget{
  VHome({Key? key}) : super(key: key);

  final cRoot = Get.find<CRoot>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chang An'),
        actions: [
          TextButton(
            onPressed: (){
              if(cRoot.mPropTypeList.value.mPropTypeList.isEmpty){
                Get.defaultDialog(title: 'Warning', content: const Text('请添加道具类别'));
              }else{
                Get.toNamed(PS.propList);
              }
            },
            child: const Text('道具',style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: (){
                    Get.toNamed(PS.addPropType);
                  },
                  child: const Text("Prop"),
                ),
                TextButton(
                  onPressed: (){
                    Get.toNamed(PS.addFamilyRole);
                  },
                  child: const Text("Role"),
                ),
                TextButton(
                  onPressed: (){
                    if(cRoot.mProfessionTypeList.value.mProfessionTypeList.isNotEmpty){
                      Get.toNamed(PS.addProfession);
                    }else{
                      Get.snackbar('Warning', 'Profession type can not empty!');
                    }

                  },
                  child: const Text("Profession"),
                ),
                TextButton(
                  onPressed: (){
                    Get.toNamed(PS.addProfessionType);
                  },
                  child: const Text("Profession Type"),
                ),
              ],
            ),
            VChangAn(
              onTapFang: (mFang){
                cRoot.updateNowFangIndex(mFang)
                    ? Get.toNamed(PS.detailFang)
                    : null;
              },
            ),
          ],
        ),
      ),
    );
  }

}

class VChangAn extends StatelessWidget{
  VChangAn({
    Key? key,
    required this.onTapFang,
  }) : super(key: key);

  final cRoot = Get.find<CRoot>();

  final MaterialColor _fangColor = Colors.grey;

  final void Function(MFang e) onTapFang;


 @override
 Widget build(BuildContext context) {
    // TODO: implement build
    return InteractiveViewer(
      maxScale: 30,
      child: Container(
        alignment: Alignment.center,
        color: Colors.white,
        height: Get.height - 2 * Get.height*0.2,
        width: Get.width - 2 * Get.width*0.02,
        margin: EdgeInsets.only(top: Get.height*0.08),
        child: Column(
          children: [
            Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _mapUpL(PS.areaUpL1Fang, PS.areaUpL2Fang),
                  _mapUpM(PS.areaUpM1Fang[0]),
                  _mapUpR(PS.areaUpR1Fang, PS.areaUpR2Fang),
                ],
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              flex: 2,
              child: Container(
                //color: Colors.white,
                margin: EdgeInsets.only(top: Get.height*0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        _mapDownL1(PS.areaDownL1Fang, ),
                        _mapDownL2(PS.areaDownL2Fang, ),
                      ],
                    ),
                    Column(
                      children: [
                        _mapDownM1(PS.areaDownM1Fang),
                      ],
                    ),
                    Column(
                      children: [
                        _mapDownR1(PS.areaDownR1Fang),
                        _mapDownR2(PS.areaDownR2Fang),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


 _myFlexible(int flex, Widget child,{required EdgeInsetsGeometry margin}){
   return Flexible(
     fit: FlexFit.tight,
     flex: flex,
     child: Container(
       margin: margin,
       //color: Colors.amberAccent.shade100,
       height: Get.height*0.24,
       width: Get.width*0.3,
       child: child,
     ),
   );
 }

 _myGridView(List<String> data,{int count = 3, double top = 0, double ratio = 1}){
   return Container(
     margin: EdgeInsets.only(top: top),
     child: GridView(
       physics: const NeverScrollableScrollPhysics(),
       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
         crossAxisCount: count,
         childAspectRatio: ratio,
       ),
       children: data.map((e) {
         return _myCard(e);
       }).toList(),
     ),
   );
 }

 Widget _myCard(String e, {TextStyle style = const TextStyle(fontSize: 1, color: Colors.white)}){
   return Card(
     elevation: 5,
     color: _fangColor,
     child: InkWell(
       onTap: (){
         onTapFang(cRoot.getByName(e, cRoot.mFangList.value.mFangList) as MFang);
       },
       child: Center(
         child: Text(e, style: style,),
       ),
     ),
   );
 }

 _mapUpL(List<String> data1, List<String> data2,){

   return _myFlexible(
     1,
     Column(
       children: [
         Flexible(
           flex: 1,
           fit: FlexFit.tight,
           child: _myGridView(data1,ratio: 1.2),
         ),
         Flexible(
           flex: 1,
           fit: FlexFit.tight,
           child: _myGridView(data2,ratio: 1.2),
         ),
       ],
     ),
     margin: EdgeInsets.all(Get.width*0.01),
   );
 }

 _mapUpM(String data){
   return _myFlexible(
     1,
     _myCard(
         data,
         style: const TextStyle(color: Colors.white)
     ),
     margin: EdgeInsets.all(Get.width*0.01),
   );
 }

 _mapUpR(List<String> data1, List<String> data2){
   return _myFlexible(
     1,
     Column(
       children: [
         Flexible(
           flex: 1,
           fit: FlexFit.tight,
           child: _myGridView(data1, ratio: 1.2),
         ),
         Flexible(
           flex: 1,
           fit: FlexFit.tight,
           child: _myGridView(data2, ratio: 1.2),
         ),
       ],
     ),
     margin: EdgeInsets.all(Get.width*0.01),
   );
 }

 _mapDownL1(List<String> data){
   return _myFlexible(
     1,
     Row(
       children: [
         Flexible(
           fit: FlexFit.tight,
           flex: 1,
           child: Column(
             children: [
               _myFlexible(
                 1,
                 _myCard(data[0]),
                 margin: EdgeInsets.all(Get.width*0.01),
               ),
               _myFlexible(
                 1,
                 _myCard(data[2]),
                 margin: EdgeInsets.all(Get.width*0.01),
               ),
             ],
           ),
         ),
         Flexible(
           fit: FlexFit.tight,
           flex: 1,
           child: Column(
             children: [
               _myFlexible(
                 1,
                 _myCard(PS.areaDownL1L2MFang[0]),
                 margin: EdgeInsets.all(Get.width*0.01),
               ),
             ],
           ),
         ),
         Flexible(
           fit: FlexFit.tight,
           flex: 1,
           child: Column(
             children: [
               _myFlexible(
                 1,
                 _myCard(data[1]),
                 margin: EdgeInsets.all(Get.width*0.01),
               ),
               _myFlexible(
                 1,
                 _myCard(data[3]),
                 margin: EdgeInsets.all(Get.width*0.01),
               ),
             ],
           ),
         ),
       ],
     ),
     margin: EdgeInsets.all(Get.width*0.01),
   );
 }

 _mapDownL2(List<String> data,){
   return _myFlexible(
     3,
     _myGridView(data, ratio: 1.5),
     margin: EdgeInsets.all(Get.width*0.01),
   );
 }
 _mapDownM1(List<String> data,){
   return _myFlexible(
     1,
     _myGridView(data, count: 4),
     margin: EdgeInsets.all(Get.width*0.01),
   );
 }
 _mapDownR1(List<String> data,){
   return _myFlexible(
     1,
     Row(
       children: [
         Flexible(
           fit: FlexFit.tight,
           flex: 1,
           child: Column(
             children: [
               _myFlexible(
                 1,
                 _myCard(data[0]),
                 margin: EdgeInsets.all(Get.width*0.01),
               ),
               _myFlexible(
                 1,
                 _myCard(data[2]),
                 margin: EdgeInsets.all(Get.width*0.01),
               ),
             ],
           ),
         ),
         Flexible(
           fit: FlexFit.tight,
           flex: 1,
           child: Column(
             children: [
               _myFlexible(
                 1,
                 _myCard(PS.areaDownL1L2MFang[1]),
                 margin: EdgeInsets.all(Get.width*0.01),
               ),
             ],
           ),
         ),
         Flexible(
           fit: FlexFit.tight,
           flex: 1,
           child: Column(
             children: [
               _myFlexible(
                 1,
                 _myCard(data[1]),
                 margin: EdgeInsets.all(Get.width*0.01),
               ),
               _myFlexible(
                 1,
                 _myCard(data[3]),
                 margin: EdgeInsets.all(Get.width*0.01),
               ),
             ],
           ),
         ),
       ],
     ),
     margin: EdgeInsets.all(Get.width*0.01),
   );
 }
 _mapDownR2(List<String> data,){
   return _myFlexible(
     3,
     _myGridView(data, ratio: 1.5),
     margin: EdgeInsets.all(Get.width*0.01),
   );
 }
}