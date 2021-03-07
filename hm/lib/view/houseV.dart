import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tencent_ocr/IDCardOCR.dart';
import 'package:flutter_tencent_ocr/flutter_tencent_ocr.dart';
import 'package:get/utils.dart';
import 'package:hm/logic/houseL.dart';
import 'package:hm/main.dart';
import 'package:get/get.dart';

class HouseV extends StatefulWidget {
  @override
  _HouseVState createState() => _HouseVState();
}
class _HouseVState extends State<HouseV>{

  String _message = '';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("房屋管理"),
      ),
      body: GetBuilder<HouseL>(
        builder: (_) => ListView.builder(
          itemCount: _.houseState.housesM.houseList.length,
          itemBuilder: (context, index){
            return Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child:  ListTile(
                //leading: Icon(Icons.house,color: Colors.black,),
                title: Text(_.houseState.housesM.houseList[index].houseName),
                //subtitle: ListTile(
                //  title: Row(
                //    children: [
                //      Flexible(
                //        fit: FlexFit.tight,
                //        flex: 1,
                //        child: Row(children: [
                //          Icon(Icons.house,size: 20,),Text('2122222222222222222222222'),
                //        ],),
                //      ),
                //      Flexible(
                //        fit: FlexFit.tight,
                //        flex: 1,
                //        child: Row(children: [
                //          Icon(CupertinoIcons.wand_rays, size: 20,),Text('21'),
                //        ],),
                //      ),
                //      Flexible(
                //        fit: FlexFit.tight,
                //        flex: 1,
                //        child: Row(children: [
                //          Icon(Icons.house,size: 20,),Text('21'),
                //        ],),
                //      ),
                //      Flexible(
                //        fit: FlexFit.tight,
                //        flex: 1,
                //        child: Row(children: [
                //          Icon(Icons.house,size: 20,),Text('21'),
                //        ],),
                //      ),
                //    ],
                //  ),
                //),
                onTap: (){
                  _.setHouseIndex(index);
                  Get.toNamed(RN.room);
                },
              ),
            );

          },

        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Get.toNamed(RN.houseCreate);
        },
      ),
    );
  }

  Future idCardOCR() async {
    const String secretId = "AKIDsXt8brSb9RUFjzviBkFUTBra2E9xqb3E";
    const String secretKey = "81dy1wa4HI4crpZ2FBRRAcoHwOZaL5ao";
    final ByteData imageBytes = await rootBundle.load('assets/images/test.jpeg');

    FlutterTencentOcr.iDCardOCR(
      secretId,
      secretKey,
      IDCardOCRRequest.fromParams(
          config: IDCardOCRConfig.fromParams(reshootWarn: true),
          imageBase64: base64Encode(imageBytes.buffer.asUint8List())),
    ).then((onValue) {
      setState(() {
        _message = onValue.toString();
        print(_message);
      });
    }).catchError(
          (error) {
        setState(() {
          _message = error;
        });
      },
    );
  }

}

