
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
              child: Card(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4.0))),
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                //elevation: 0,
                child: InkWell(
                  child: Container(
                    //height: 300,
                    padding: EdgeInsets.all(5),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(_.houseState.housesM.houseList[index].houseName),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(children: [
                              Icon(Icons.house),
                              Text("${_.houseState.housesM.houseList[index].roomList.length}"),
                            ],),
                            Row(children: [
                              Icon(Icons.people),
                              Text("10"),
                            ],),
                            Row(children: [
                              Icon(CupertinoIcons.money_yen),
                              Text("50000"),
                            ],),

                          ],
                        ),
                      ],
                    ),
                  ),
                  onTap: (){
                    _.setHouseIndex(index);
                    Get.toNamed(RN.room);
                  },
                ),
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

}

