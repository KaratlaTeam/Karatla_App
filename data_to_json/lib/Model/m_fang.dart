import 'package:data_to_json/Model/m_building.dart';
import 'package:data_to_json/Model/m_event.dart';
import 'package:data_to_json/Model/m_family.dart';
import 'package:data_to_json/Model/m_people.dart';
import 'package:uuid/uuid.dart';

class MFangList{
  MFangList({
    this.index = 0,
    required this.mFangList,
});

  List<MFang> mFangList;
  int index;

  factory MFangList.nowOne(){
    return MFangList(
      index: 0,
      mFangList: [],
    );
  }

  factory MFangList.fromJson(Map<String, dynamic> json){
    return MFangList(
      index: json['index'],
      mFangList: (json['mFangList'] as List).map((e) => MFang.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> mFangListMap = {};
    mFangListMap['index'] = index;
    mFangListMap['mFangList'] = mFangList.map((e) => e.toJson()).toList();
    return mFangListMap;
  }
}

class MFang{
  MFang({
    required this.uuid,
    required this.fangName,
    required this.fangArea,
    required this.mPeopleList,
    required this.families,
    required this.events,
    required this.buildings,
    required this.images,
    required this.content,
});
  String uuid;

  String fangName;

  String fangArea;

  String content;

  MPeopleList mPeopleList;

  MFamilyList families;

  MEventList events;

  MBuildingList buildings;

  List<String> images;

  factory MFang.newOne(){
    return MFang(
      uuid: const Uuid().v1(),
      fangName: 'fangName',
      fangArea: 'fangArea',
      mPeopleList: MPeopleList.newOne(),
      families: MFamilyList.newOne(),
      events: MEventList.newOne(),
      buildings: MBuildingList.newOne(),
      images: [],
      content: '',
    );
  }

  factory MFang.fromJson(Map<String, dynamic> json){
    return MFang(
      uuid: json['uuid'],
      fangName: json['fangName'],
      fangArea: json['fangArea'],
      content: json['content'],

      mPeopleList: MPeopleList.fromJson(json['mPeopleList']),
      families: MFamilyList.fromJson(json['families']),
      events: MEventList.fromJson(json['events']),
      buildings: MBuildingList.fromJson(json['buildings']),
      images: List<String>.from(json['images']),
    );
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> mBuildingMap = {};
    mBuildingMap['uuid'] = uuid;
    mBuildingMap['fangName'] = fangName;
    mBuildingMap['fangArea'] = fangArea;
    mBuildingMap['mPeopleList'] = mPeopleList.toJson();
    mBuildingMap['families'] = families.toJson();
    mBuildingMap['events'] = events.toJson();
    mBuildingMap['buildings'] = buildings.toJson();
    mBuildingMap['images'] = images;
    mBuildingMap['content'] = content;
    return mBuildingMap;
  }

  @override
  String toString() {
    return fangName;
  }

  @override
  bool operator == (Object other) => other is MFang && other.fangName == fangName;

  @override
  int get hashCode => fangName.hashCode;
}