import 'package:hm/model/houseM.dart';
import 'package:hm/model/roomM.dart';

class MyFunctions{

  //int getHouseHighestLevels(HouseM houseM){
  //  int highest = 1;
//
   // for(var room in houseM.levelList){
   //   room.roomLevel > highest ? highest = room.roomLevel : highest = highest;
   // }
   // return highest;
 // }

  //Map<int, int> getRoomsPerLevelMap(HouseM houseM){
  //  Map<int,int> a = Map<int, int>();
  //  for(RoomM room in houseM.roomList){
  //   a[room.roomLevel] == null ? a[room.roomLevel] = 1 : a[room.roomLevel]++;
  //  }
   // return a;
 // }

   getExpiredLeft(RoomM roomM){
    if(roomM.rentalFee.length>0){
      int leftDays = 0;
      var timeNow = DateTime.now();
      var sTime = roomM.rentalFee[0].shouldPayTime;
      var timeShould = DateTime(sTime.year,sTime.month,sTime.day,sTime.hour,sTime.minute,sTime.second);
      leftDays = -timeNow.difference(timeShould).inDays;
      if(leftDays >= -10 && leftDays <= 10){
        return leftDays;
      }else{
        return null;
      }
    }else{
      return null;
    }

  }
}

class Item {
  Item({
    this.houseLevel,
    this.isExpanded = false,
    this.levelIndex,
  });

  int levelIndex;
  HouseLevel houseLevel;
  bool isExpanded;
}