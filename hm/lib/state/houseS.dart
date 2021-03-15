
import 'package:hm/enumData.dart';
import 'package:hm/model/backUp.dart';
import 'package:hm/model/houseM.dart';
import 'package:hm/plugin/myFunctions.dart';
import 'package:hm/view/roomV.dart';

class HouseS{
  HousesM housesM ;
  int houseIndex;
  ActionState actionState;
  String tempPath, appDocPath, appStoPath;
  BackUp backUp;
  List<Item> itemList ;

  HouseS({
   this.housesM,
    this.houseIndex,
    this.actionState,
    this.appDocPath,
    this.appStoPath,
    this.tempPath,
    this.backUp,
    this.itemList,
});
}