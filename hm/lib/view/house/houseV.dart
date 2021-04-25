import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/utils.dart';
import 'package:hm/logic/houseL.dart';
import 'package:hm/main.dart';
import 'package:get/get.dart';
import 'package:hm/model/houseM.dart';
import 'package:hm/model/roomM.dart';
import 'package:hm/view/room/roomV.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class HouseV extends StatefulWidget {
  @override
  _HouseVState createState() => _HouseVState();
}
class _HouseVState extends State<HouseV> {

  bool expanded = true;
  List<Map> houseHolderList = [];
  List<Map> houseHolderShowList = [];
  CarouselController _carouselController;
  bool offStateHouseList = false;

  @override
  void initState() {
    this._carouselController = CarouselController();
    super.initState();
  }

  @override
  void dispose() {
    this._carouselController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(

      body: GetBuilder<HouseL>(
        builder: (_) => Container(
          //padding: EdgeInsets.only(top: 10),
          child: FloatingSearchBar(
            progress: _.status.isLoading,
            hint: '住户搜索',
            scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
            transitionDuration: const Duration(milliseconds: 800),
            transitionCurve: Curves.easeInOut,
            physics: const BouncingScrollPhysics(),
            axisAlignment: context.orientation == Orientation.portrait ? 0.0 : -1.0,
            openAxisAlignment: 0.0,
            width: context.orientation == Orientation.portrait  ? 600 : 500,
            debounceDelay: const Duration(milliseconds: 500),
            onQueryChanged: (query) {
              if(query != ''){
                this.houseHolderShowList = [];
                for(Map b in this.houseHolderList){
                  if(b['name'].contains(query)){
                    this.houseHolderShowList.add(b);
                  }
                }
              }else{
                this.houseHolderShowList = this.houseHolderList;
              }
              setState(() {});
            },
            onFocusChanged: (boo)async{
              if(boo){
                this.houseHolderList = [];
                this.houseHolderList = await _.getHouseHolderList();
                this.houseHolderShowList = this.houseHolderList;
                setState(() {});
              }
              print(_.houseState.housesM.houseList.length);
            },
            onSubmitted: (text){

            },
            // Specify a custom transition to be used for
            // animating between opened and closed stated.
            transition: CircularFloatingSearchBarTransition(),
            actions: [
              FloatingSearchBarAction(
                showIfOpened: false,
                child: Container(),
              ),
              FloatingSearchBarAction.searchToClear(
                showIfClosed: false,
              ),
            ],
            body: _buildHouseList(_),
            builder: (context, transition) {
              return Container(
                height: context.height/3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Material(
                    color: Colors.white,
                    elevation: 4.0,
                    child: ListView.builder(
                      itemCount: this.houseHolderShowList.length,
                      itemBuilder: ((context, index){
                        return Column(
                          children: [
                            ListTile(
                              title: Text(this.houseHolderShowList[index]['name']),
                              trailing: Text(this.houseHolderShowList[index]['idNum']),
                            ),
                            ListTile(
                              title: Text(_.houseState.housesM.houseList[this.houseHolderShowList[index]['house']].houseName),
                              trailing: Text(_.houseState.housesM.houseList[this.houseHolderShowList[index]['house']].levelList[this.houseHolderShowList[index]['level']].name+' - '+_.houseState.housesM.houseList[this.houseHolderShowList[index]['house']].levelList[this.houseHolderShowList[index]['level']].roomList[this.houseHolderShowList[index]['room']].roomNumber.toString()),
                            ),
                            Divider(color: Colors.grey,),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  _buildHouseList(HouseL _){

    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 48+context.mediaQueryPadding.top+10),
            //color: Colors.red,
            child: CarouselSlider.builder(
              options: CarouselOptions(
                enableInfiniteScroll: false,
                viewportFraction: 1,
                height: 250,
                onPageChanged: (int index, CarouselPageChangedReason carouselPageChangedReason){
                  _.setHouseIndex(index);
                  _.setItemList(index);
                },
              ),
              carouselController: this._carouselController,
              itemCount: pageViewCheck(_),
              itemBuilder: (context, index, realIndex){
                return _.houseState.housesM.houseList.length == 0
                    ? Container()
                    : pageBuilder(_, index);
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  side: MaterialStateProperty.all(BorderSide(color: Colors.grey)),
                  //elevation: MaterialStateProperty.all(5),
                ),
                child: Icon(Icons.add, color: Colors.cyan,),
                onPressed: (){
                  Get.toNamed(RN.houseCreate);
                },
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  side: MaterialStateProperty.all(BorderSide(color: Colors.grey)),
                  //elevation: MaterialStateProperty.all(0),
                ),
                child: Icon(Icons.height, color: Colors.cyan,),
                onPressed: (){
                  this.offStateHouseList = !this.offStateHouseList;
                  setState(() {});
                },
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  side: MaterialStateProperty.all(BorderSide(color: Colors.grey)),
                  //elevation: MaterialStateProperty.all(0),
                ),
                child: Icon(Icons.add_circle, color: Colors.cyan,),
                onPressed: (){
                  Get.toNamed(RN.addExpense);
                },
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  side: MaterialStateProperty.all(BorderSide(color: Colors.grey)),
                  //elevation: MaterialStateProperty.all(0),
                ),
                child: Icon(Icons.edit, color: Colors.cyan,),
                onPressed: (){
                  Get.toNamed(RN.houseEdit);
                },
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  side: MaterialStateProperty.all(BorderSide(color: Colors.grey)),
                  //elevation: MaterialStateProperty.all(0),
                ),
                child: Icon(Icons.delete, color: Colors.cyan,),
                onPressed: (){
                  Get.defaultDialog(
                      middleText: "是否要删除 '${_.houseState.housesM.houseList[_.houseState.houseIndex].houseName}' 房所有数据? 删除后无法恢复，建议提前备份。",
                      onConfirm: (){
                        Get.back();
                        Get.find<HouseL>().deleteHouse(_.houseState.houseIndex);
                      },
                      onCancel: (){}
                  );
                },
              ),
            ],
          ),
          Expanded(
            child: _.status.isLoading
                ? Scaffold(body: Center(child: CircularProgressIndicator()),)
                : Container(
              margin: EdgeInsets.only(top: 10),
              child: this.offStateHouseList ? buildCostListShow(_) : RoomV(),
            ),
          ),
        ],
      ),
    );
  }

  buildCostListShow(HouseL _){

    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: _.houseState.housesM.houseList[_.houseState.houseIndex].houseExpensesList.length,
        itemBuilder: (BuildContext context, int index){
          return ListTile(
            onLongPress: (){
              Get.toNamed(RN.expenseEdit, arguments: index);
            },
            title: Text(_.houseState.housesM.houseList[_.houseState.houseIndex].houseExpensesList[index].expense.type),
            subtitle: Text(_.houseState.housesM.houseList[_.houseState.houseIndex].houseExpensesList[index].expenseDate.toString()),
            trailing: Text(_.houseState.housesM.houseList[_.houseState.houseIndex].houseExpensesList[index].expense.cost.toString()),
          );
        },
      ),
    );
  }

  int pageViewCheck(HouseL _){
    if(_.houseState.housesM.houseList.length == 0){
      return 0;
    }else{
      return _.houseState.housesM.houseList.length;
    }
  }

  pageBuilder(HouseL _, int index){
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      margin: EdgeInsets.symmetric(vertical: 10,),
      child: InkWell(
        child: Container(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                child: Image.asset('assets/images/house.jpg',fit: BoxFit.cover,height: 200,),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    //color: Colors.yellow,
                    width: 100,
                    child: Text(_.houseState.housesM.houseList[index].houseName, style: TextStyle(fontWeight: FontWeight.bold),maxLines: 1, overflow: TextOverflow.ellipsis,),
                  ),
                  Row(children: [
                    Icon(Icons.house,size: 20,),
                    Text("${_showRoomAmount(_.houseState.housesM.houseList[index])}"),
                  ],),
                  Row(children: [
                    Icon(Icons.people, size: 20,),
                    Text(_houseHoldAmount(_.houseState.housesM.houseList[index]).toString()),
                  ],),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _showRoomAmount(HouseM houseM){
    int amount = 0;
    for(var a in houseM.levelList){
      amount+=a.roomList.length;
    }
    return amount;
  }

  int _houseHoldAmount(HouseM houseM){
    int amount = 0;
    for(var b in houseM.levelList){
      for(var a in b.roomList){
        amount += a.householderList.length;
      }
    }
    return amount;
  }

  _houseIncomeAmount(HouseM houseM){
    double amount = 0;
    for(var b in houseM.levelList){
      for(var a in b.roomList){
        for(var b in a.feeTypeCostList){
          amount += b.cost;
        }
      }
    }

    return amount;
  }

  double _getShouldPayAmount(RoomM roomM){
    double amount = 0;
    for(var a in roomM.rentalFee[0].rentalFee){
      amount+=(a.amount*a.feeTypeCost.cost);
    }
    return amount;
  }
  double _getPayedAmount(RoomM roomM){
    double payed = 0;
    for(var a in roomM.rentalFee[0].rentalFee){
      payed+=a.payedFee;
    }
    return payed;
  }


}