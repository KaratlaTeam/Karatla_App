
import 'package:hm/enumData.dart';
import 'package:hm/model/backUp.dart';
import 'package:hm/model/houseM.dart';

class HouseS{
  HousesM housesM ;
  int houseIndex;
  ActionState actionState;
  String tempPath, appDocPath, appStoPath;
  BackUp backUp;

  HouseS({
   this.housesM,
    this.houseIndex,
    this.actionState,
    this.appDocPath,
    this.appStoPath,
    this.tempPath,
    this.backUp,
});
}