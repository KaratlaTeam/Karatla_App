import 'package:data_to_json/Model/m_profession_type.dart';

class MProfessionList{
  MProfessionList({
    this.index = 0,
    required this.mProfessionList ,
});
  List<MProfession> mProfessionList;
  int index;

  factory MProfessionList.newOne(){
    return MProfessionList(
      index: 0,
      mProfessionList: [],
    );
  }

  factory MProfessionList.fromJson(Map<String, dynamic> json){
    return MProfessionList(
      index: json['index'],
      mProfessionList: (json['mProfessionList'] as List).map((e) => MProfession.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> mProfessionListMap = {};
    mProfessionListMap['index'] = index;
    mProfessionListMap['mProfessionList'] = mProfessionList.map((e) => e.toJson()).toList();
    return mProfessionListMap;
  }
}

class MProfession{
  MProfession({
    required this.title,
    required this.content,
    required this.type,
});
  MProfessionType type ;
  String title ;
  String content ;

  factory MProfession.newOne(){
    return MProfession(type: MProfessionType(type: ''), content: '', title: '',);
  }

  factory MProfession.fromJson(Map<String, dynamic> json){
    return MProfession(
      title: json['title'],
      content: json['content'],
      type: MProfessionType.fromJson(json['type']),
    );
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> mProfessionMap = {};
    mProfessionMap['title'] = title;
    mProfessionMap['type'] = type.toJson();
    mProfessionMap['content'] = content;
    return mProfessionMap;
  }

  @override
  String toString() {
    return title;
  }

  @override
  bool operator == (Object other) => other is MProfession && other.title == title;

  @override
  int get hashCode => title.hashCode;
}