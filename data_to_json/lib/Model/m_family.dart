import 'package:data_to_json/Plugin/p_v.dart';
import 'package:uuid/uuid.dart';

import 'm_family_role.dart';

class MFamilyList{
  MFamilyList({
    this.index = 0,
    required this.mFamilyList,
  });
  List<MFamily> mFamilyList;
  int index;

  factory MFamilyList.newOne(){
    return MFamilyList(
      index: 0,
      mFamilyList: [],
    );
  }

  factory MFamilyList.fromJson(Map<String, dynamic> json){
    return MFamilyList(
      index: json['index'],
      mFamilyList: (json['mFamilyList'] as List).map((e) => MFamily.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> mFamilyListMap = {};
    mFamilyListMap['index'] = index;
    mFamilyListMap['mFamilyList'] = mFamilyList.map((e) => e.toJson()).toList();
    return mFamilyListMap;
  }
}

class MFamily{

  MFamily({
    required this.uuid,
    required this.familyMembers,
    required this.startFamilyDay,
    required this.endFamilyDay,
    this.content = '',
    required this.images,
    required this.mLocationUuids,
    required this.familyName,
  });


  String uuid;

  String familyName;

  MyDateTime startFamilyDay;

  MyDateTime endFamilyDay;

  String content;

  List<String> mLocationUuids;

  List<MFamilyMember> familyMembers;

  List<String> images;


  factory MFamily.newOne(){
    return MFamily(
      uuid: const Uuid().v1(),
      familyMembers: [],
      startFamilyDay: MyDateTime(618),
      endFamilyDay: MyDateTime(912),
      images: [],
      mLocationUuids: ['',''],
      familyName: '',
    );
  }

  factory MFamily.fromJson(Map<String, dynamic> json){
    return MFamily(
      uuid: json['uuid'],
      startFamilyDay: MyDateTime.fromJson(json['startFamilyDay']),
      endFamilyDay: MyDateTime.fromJson(json['endFamilyDay']),
      content: json['content'],
      familyName: json['familyName'],

      familyMembers: (json['familyMembers'] as List).map((e) => MFamilyMember.fromJson(e)).toList(),
      images: List<String>.from(json['images']),
      mLocationUuids: List<String>.from(json['mLocationUuids']),
    );
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> mFamilyMap = {};
    mFamilyMap['uuid'] = uuid;
    mFamilyMap['startFamilyDay'] = startFamilyDay.toJson();
    mFamilyMap['endFamilyDay'] = endFamilyDay.toJson();
    mFamilyMap['content'] = content;
    mFamilyMap['familyName'] = familyName;

    mFamilyMap['familyMembers'] = familyMembers.map((e) => e.toJson()).toList();
    mFamilyMap['images'] = images;
    mFamilyMap['mLocationUuids'] = mLocationUuids;
    return mFamilyMap;
  }

}

class MFamilyMember {
  MFamilyMember({
    required this.level,
    required this.role,
    required this.startDay,
    required this.peopleUuid,
    required this.endDay,
  });

  int level;

  MFamilyRole role;

  String peopleUuid;

  MyDateTime startDay;

  MyDateTime endDay;

  factory MFamilyMember.newOne(){
    return MFamilyMember(
      level: 0,
      role: MFamilyRole.newOne(),
      startDay: MyDateTime(618),
      endDay: MyDateTime(907),
      peopleUuid: '',
    );
  }

  factory MFamilyMember.fromJson(Map<String, dynamic> json){
    return MFamilyMember(
      level: json['level'],
      peopleUuid: json['peopleUuid'],
      startDay: MyDateTime.fromJson(json['startDay']),
      endDay: MyDateTime.fromJson(json['endDay']),

      role: MFamilyRole.fromJson(json['role']),
    );
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> familyMembersMap = {};
    familyMembersMap['level'] = level;
    familyMembersMap['peopleUuid'] = peopleUuid;
    familyMembersMap['startDay'] = startDay.toJson();
    familyMembersMap['endDay'] = endDay.toJson();

    familyMembersMap['role'] = role.toJson();
    return familyMembersMap;
  }

}

