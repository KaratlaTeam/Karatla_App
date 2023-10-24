class MProfessionTypeList{
  MProfessionTypeList({
   this.index = 0,
   required this.mProfessionTypeList,
});
  List<MProfessionType> mProfessionTypeList;
  int index;

  factory MProfessionTypeList.newOne(){
    return MProfessionTypeList(
      index: 0,
      mProfessionTypeList: [],
    );
  }

  factory MProfessionTypeList.fromJson(Map<String, dynamic> json){
    return MProfessionTypeList(
      index: json['index'],
      mProfessionTypeList: (json['mProfessionTypeList'] as List).map((e) => MProfessionType.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> mProfessionTypeListMap = {};
    mProfessionTypeListMap['index'] = index;
    mProfessionTypeListMap['mProfessionTypeList'] = mProfessionTypeList.map((e) => e.toJson()).toList();
    return mProfessionTypeListMap;
  }
}

class MProfessionType{
  MProfessionType({
    required this.type,
});
  String type;

  factory MProfessionType.fromJson(Map<String, dynamic> json){
    return MProfessionType(
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> mProfessionTypeMap = {};
    mProfessionTypeMap['type'] = type;

    return mProfessionTypeMap;
  }

  @override
  String toString() {
    return type;
  }

  @override
  bool operator == (Object other) => other is MProfessionType && other.type == type;

  @override
  int get hashCode => type.hashCode;
}