
import 'package:data_to_json/Plugin/p_v.dart';
import 'package:uuid/uuid.dart';

class MEventList{
  MEventList({
    this.index = 0,
    required this.mEventList,
  });

  List<MEvent> mEventList;

  int index;

  factory MEventList.newOne(){
    return MEventList(
      index: 0,
      mEventList: [],
    );
  }

  factory MEventList.fromJson(Map<String, dynamic> json){
    return MEventList(
      index: json['index'],
      mEventList: (json['mEventList'] as List).map((e) => MEvent.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> mEventListMap = {};
    mEventListMap['index'] = index;
    mEventListMap['mEventList'] = mEventList.map((e) => e.toJson()).toList();
    return mEventListMap;
  }

}

class MEvent{
  MEvent({
    required this.mLocationUuids,
    required this.uuid,
    required this.title,
    this.content = '',
    required this.startDay,
    required this.endDay,
    this.level = 0,
    required this.relationPeopleUuids ,
    required this.relationBuildingUuids ,
    //required this.relationPropUuids,
    required this.images,
});

  String uuid;

  String title;

  String content;

  int level;

  MyDateTime startDay;

  MyDateTime endDay;

  List<String> mLocationUuids;

  List<String> relationPeopleUuids;

  List<String> relationBuildingUuids;

  //List<String> relationPropUuids;

  List<String> images;


  factory MEvent.newOne(){
    return MEvent(
      mLocationUuids: ['',''],
      uuid: const Uuid().v1(),
      title: '',
      relationBuildingUuids: [],
      relationPeopleUuids: [],
      //relationPropUuids: [],
      images: [],
      startDay: MyDateTime(618),
      endDay: MyDateTime(907),
    );
  }

  factory MEvent.fromJson(Map<String, dynamic> json){
    return MEvent(
      uuid: json['uuid'],
      title: json['title'],
      content: json['content'],
      level: json['level'],
      startDay: MyDateTime.fromJson(json['startDay']),
      endDay: MyDateTime.fromJson(json['endDay']),

      mLocationUuids: List<String>.from(json['mLocationUuids']),
      relationPeopleUuids: List<String>.from(json['relationPeopleUuids']),
      relationBuildingUuids: List<String>.from(json['relationBuildingUuids']),
      //relationPropUuids: List<String>.from(json['relationPropUuids']),
      images: List<String>.from(json['images']),
    );
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> mEventMap = {};
    mEventMap['uuid'] = uuid;
    mEventMap['title'] = title;
    mEventMap['level'] = level;
    mEventMap['content'] = content;
    mEventMap['startDay'] = startDay.toJson();
    mEventMap['endDay'] = endDay.toJson();

    mEventMap['mLocationUuids'] = mLocationUuids;
    mEventMap['relationPeopleUuids'] = relationPeopleUuids;
    mEventMap['relationBuildingUuids'] = relationBuildingUuids;
    //mEventMap['relationPropUuids'] = relationPropUuids;
    mEventMap['images'] = images;
    return mEventMap;
  }

  @override
  String toString() {
    return title;
  }

  @override
  bool operator == (Object other) => other is MEvent && other.uuid == uuid;

  @override
  int get hashCode => uuid.hashCode;

}