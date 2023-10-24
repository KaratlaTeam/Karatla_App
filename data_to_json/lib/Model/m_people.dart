import 'package:data_to_json/Model/m_building.dart';
import 'package:data_to_json/Model/m_profession.dart';
import 'package:data_to_json/Model/m_prop.dart';
import 'package:data_to_json/Plugin/p_v.dart';
import 'package:uuid/uuid.dart';


class MPeopleList{
  MPeopleList({
    this.index = 0,
    required this.mPeopleList,
});
  List<MPeople> mPeopleList ;
  int index;

  factory MPeopleList.newOne(){
    return MPeopleList(
      index: 0,
      mPeopleList: [],
    );
  }

  factory MPeopleList.fromJson(Map<String, dynamic> json){
    return MPeopleList(
      index: json['index'],
      mPeopleList: (json['mPeopleList'] as List).map((e) => MPeople.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> mPeopleListMap = {};
    mPeopleListMap['index'] = index;
    mPeopleListMap['mPeopleList'] = mPeopleList.map((e) => e.toJson()).toList();
    return mPeopleListMap;
  }
}

class MPeople{

  MPeople({
    required this.uuid,
    required this.nameList,
    required this.gender,
    required this.birthday,
    required this.mLocationUuids,
    required this.mWorkingList,
    required this.images,
    this.content = '',
    required this.deadDay,
});

  String uuid;

  List<MName> nameList;

  String gender;

  String content;

  MyDateTime birthday;

  MyDateTime deadDay;

  List mLocationUuids;

  List<MWorking> mWorkingList;

  List<String> images;


  factory MPeople.newOne(){
    return MPeople(
      uuid: const Uuid().v1(),
      nameList: [],
      gender: 'Male',
      birthday: MyDateTime(618),
      deadDay: MyDateTime(912),
      mLocationUuids: ['',''],
      mWorkingList: [],
      images: [],
    );
  }

  factory MPeople.fromJson(Map<String, dynamic> json){
    return MPeople(
      uuid: json['uuid'],
      nameList: (json['nameList'] as List).map((e) => MName.fromJson(e)).toList(),
      gender: json['gender'],
      birthday: MyDateTime.fromJson(json['birthday']),
      mLocationUuids: List<String>.from(json['mLocationUuids']),
      mWorkingList: (json['mWorkingList'] as List).map((e) => MWorking.fromJson(e)).toList(),
      images: List<String>.from(json['images']),
      content: json['content'],
      deadDay: MyDateTime.fromJson(json['deadDay']),

    );
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> mPeopleMap = {};
    mPeopleMap['uuid'] = uuid;
    mPeopleMap['nameList'] = nameList.map((e) => e.toJson()).toList();
    mPeopleMap['gender'] = gender;
    mPeopleMap['birthday'] = birthday.toJson();
    mPeopleMap['mLocationUuids'] = mLocationUuids;
    mPeopleMap['mWorkingList'] = mWorkingList.map((e) => e.toJson()).toList();
    mPeopleMap['images'] = images;
    mPeopleMap['content'] = content;
    mPeopleMap['deadDay'] = deadDay.toJson();
    return mPeopleMap;
  }

  @override
  String toString() {
    return nameList[0].fullName;
  }

  @override
  bool operator == (Object other) => other is MPeople && other.uuid == uuid;

  @override
  int get hashCode => uuid.hashCode;
}

class MName {
  MName({
    required this.lastName,
    required this.firstName,
    required this.createDay,
  });
  String firstName;
  String lastName;
  MyDateTime createDay;

  String get fullName => lastName + ' ' + firstName;

  factory MName.newOne(){
    return MName(
      lastName: '',
      firstName: '',
      createDay: MyDateTime(618),
    );
  }

  factory MName.fromJson(Map<String, dynamic> json){
    return MName(
      firstName: json['firstName'],
      lastName: json['lastName'],
      createDay: MyDateTime.fromJson(json['createDay']),
    );
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> mNameMap = {};
    mNameMap['firstName'] = firstName;
    mNameMap['lastName'] = lastName;
    mNameMap['createDay'] = createDay.toJson();
    return mNameMap;
  }
}

class MWorking{
  MWorking({
    required this.mLocationUuids,
    required this.mProfession,
    required this.level,
});
  MProfession mProfession;

  List<String> mLocationUuids;
  int level;

  String get location => mLocationUuids[0]+' - '+mLocationUuids[1];

  factory MWorking.newOne(){
    return MWorking(
      mLocationUuids: ['',''],
      mProfession: MProfession.newOne(),
      level: 0,
    );
  }

  factory MWorking.fromJson(Map<String, dynamic> json){
    return MWorking(
      mProfession: MProfession.fromJson(json['mProfession']),
      level: json['level'],
      mLocationUuids: List<String>.from(json['mLocationUuids']),
    );
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> mWorkingMap = {};
    mWorkingMap['level'] = level;
    mWorkingMap['mLocationUuids'] = mLocationUuids;
    mWorkingMap['mProfession'] = mProfession.toJson();
    return mWorkingMap;
  }
}