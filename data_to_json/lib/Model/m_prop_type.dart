
class MPropTypeList{
  MPropTypeList({
    this.index = 0,
    required this.mPropTypeList,
  });
  List<MPropType> mPropTypeList;
  int index;

  factory MPropTypeList.newOne(){
    return MPropTypeList(
      index: 0,
      mPropTypeList: [],
    );
  }

  factory MPropTypeList.fromJson(Map<String, dynamic> json){
    return MPropTypeList(
      index: json['index'],
      mPropTypeList: (json['mPropTypeList'] as List).map((e) => MPropType.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> mPropTypeListMap = {};
    mPropTypeListMap['index'] = index;
    mPropTypeListMap['mPropTypeList'] = mPropTypeList.map((e) => e.toJson()).toList();
    return mPropTypeListMap;
  }
}

class MPropType {
  MPropType({
    required this.type,
  });
  String type;

  factory MPropType.newOne(){
    return MPropType(
      type: '',
    );
  }

  factory MPropType.fromJson(Map<String, dynamic> json){
    return MPropType(
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> mPropTypeMap = {};
    mPropTypeMap['type'] = type;

    return mPropTypeMap;
  }

  @override
  String toString() {
    return type;
  }

  @override
  bool operator == (Object other) => other is MPropType && other.type == type;

  @override
  int get hashCode => type.hashCode;

}