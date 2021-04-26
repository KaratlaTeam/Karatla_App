
import 'package:carousel_slider/carousel_controller.dart';
import 'package:hm/enumData.dart';
import 'package:hm/model/appModel.dart';
import 'package:hm/model/backUp.dart';
import 'package:hm/model/houseM.dart';
import 'package:hm/plugin/myFunctions.dart';
import 'package:hm/view/room/roomV.dart';

class HouseS{
  HousesM housesM ;
  int houseIndex;
  String tempPath, appDocPath, appStoPath;
  BackUp backUp;
  List<Item> itemList ;
  List<Map> houseHolderList ;
  List<Map> houseHolderShowList ;
  CarouselController carouselController;
  AppModel appModel;

  HouseS({
   this.housesM,
    this.houseIndex,
    this.appDocPath,
    this.appStoPath,
    this.tempPath,
    this.backUp,
    this.itemList,
    this.houseHolderList: const [],
    this.houseHolderShowList: const [],
    this.carouselController,
    this.appModel,
    //this.fixFeeTypeMap,
});
}