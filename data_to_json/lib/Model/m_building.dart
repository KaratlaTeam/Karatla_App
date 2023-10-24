
import 'package:data_to_json/Plugin/p_v.dart';
import 'package:uuid/uuid.dart';

class MBuildingList{
  MBuildingList({
    this.index = 0,
    required this.mBuildingList ,
});

  List<MBuilding> mBuildingList;
  int index;

  factory MBuildingList.newOne(){
    return MBuildingList(
      index: 0,
      mBuildingList: [],
    );
  }

  factory MBuildingList.fromJson(Map<String, dynamic> json){
    return MBuildingList(
      index: json['index'],
      mBuildingList: (json['mBuildingList'] as List).map((e) => MBuilding.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> mBuildingListMap = {};
    mBuildingListMap['index'] = index;
    mBuildingListMap['mBuildingList'] = mBuildingList.map((e) => e.toJson()).toList();
    return mBuildingListMap;
  }
}

class MBuilding{

  MBuilding({
    required this.mLocationUuids,
    required this.uuid,
    required this.name,
    this.content = '',
    required this.createDay,
    required this.endDay,
    required this.ownerUuid ,
    required this.images,
});

  String uuid;

  String name;

  String content;

  MyDateTime createDay;

  MyDateTime endDay;

  List<String> mLocationUuids;

  List<String> ownerUuid;

  List<String> images;

  factory MBuilding.newOne(){
    return MBuilding(
      mLocationUuids: ['',''],
      uuid: const Uuid().v1(),
      name: '',
      ownerUuid: [],
      images: [],
      createDay: MyDateTime(618),
      endDay: MyDateTime(907),
    );
  }

  factory MBuilding.fromJson(Map<String, dynamic> json){
    return MBuilding(
      uuid: json['uuid'],
      name: json['name'],
      content: json['content'],
      createDay: MyDateTime.fromJson(json['createDay']),
      endDay: MyDateTime.fromJson(json['endDay']),

      mLocationUuids: List<String>.from(json['mLocationUuids']),
      ownerUuid: List<String>.from(json['ownerUuid']),
      images: List<String>.from(json['images']),
    );
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> mBuildingMap = {};
    mBuildingMap['uuid'] = uuid;
    mBuildingMap['name'] = name;
    mBuildingMap['content'] = content;
    mBuildingMap['createDay'] = createDay.toJson();
    mBuildingMap['endDay'] = endDay.toJson();
    mBuildingMap['mLocationUuids'] = mLocationUuids;
    mBuildingMap['ownerUuid'] = ownerUuid;
    mBuildingMap['images'] = images;
    return mBuildingMap;
  }

  @override
  String toString() {
    return name;
  }

  @override
  bool operator == (Object other) => other is MBuilding && other.uuid == uuid;

  @override
  int get hashCode => uuid.hashCode;
}