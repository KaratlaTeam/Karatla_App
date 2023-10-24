
import 'package:data_to_json/Model/m_prop_type.dart';
import 'package:uuid/uuid.dart';

class MPropList{
  MPropList({
    this.index = 0,
    required this.mPropList ,
});
  List<MProp> mPropList;
  int index;

  factory MPropList.newOne(){
    return MPropList(
      index: 0,
      mPropList: [],
    );
  }

  factory MPropList.fromJson(Map<String, dynamic> json){
    return MPropList(
      index: json['index'],
      mPropList: (json['mPropList'] as List).map((e) => MProp.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> mPropListMap = {};
    mPropListMap['index'] = index;
    mPropListMap['mPropList'] = mPropList.map((e) => e.toJson()).toList();
    return mPropListMap;
  }
}

class MProp{

  MProp({
    required this.name,
    required this.uuid,
    required this.ownerUuid,
    required this.images ,
    this.content = '',
    required this.mPropType,
});

  String uuid;

  String name;

  String content;

  MPropType mPropType;

  List<String> ownerUuid;

  List<String> images;

  factory MProp.newOne(){
    return MProp(
      name: '',
      uuid: const Uuid().v1(),
      ownerUuid: [],
      images: [],
      mPropType: MPropType.newOne()
    );
  }

  factory MProp.fromJson(Map<String, dynamic> json){
    return MProp(
      uuid: json['uuid'],
      name: json['name'],
      content: json['content'],
      mPropType: MPropType.fromJson(json['mPropType']),

      ownerUuid: List<String>.from(json['ownerUuid']),
      images: List<String>.from(json['images']),
    );
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> mPropMap = {};
    mPropMap['uuid'] = uuid;
    mPropMap['name'] = name;
    mPropMap['content'] = content;
    mPropMap['ownerUuid'] = ownerUuid;
    mPropMap['images'] = images;
    mPropMap['mPropType'] = mPropType.toJson();
    return mPropMap;
  }
}