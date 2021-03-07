import 'package:hm/model/houseM.dart';
import 'package:hm/model/roomM.dart';

class MyFunctions{

  int getHouseHighestLevels(HouseM houseM){
    int highest = 1;

    for(RoomM room in houseM.roomList){
      room.roomLevel > highest ? highest = room.roomLevel : highest = highest;
    }
    return highest;
  }

  Map<int, int> getRoomsPerLevelMap(HouseM houseM){
    Map<int,int> a = Map<int, int>();
    for(RoomM room in houseM.roomList){
     a[room.roomLevel] == null ? a[room.roomLevel] = 1 : a[room.roomLevel]++;
    }
    return a;
  }
}