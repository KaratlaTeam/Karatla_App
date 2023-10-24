class MFamilyRoleList{
  MFamilyRoleList({
    this.index = 0,
    required this.mFamilyRoleList,
  });
  List<MFamilyRole> mFamilyRoleList;
  int index;

  factory MFamilyRoleList.newOne(){
    return MFamilyRoleList(
      index: 0,
      mFamilyRoleList: [],
    );
  }

  factory MFamilyRoleList.fromJson(Map<String, dynamic> json){
    return MFamilyRoleList(
      index: json['index'],
      mFamilyRoleList: (json['mFamilyRoleList'] as List).map((e) => MFamilyRole.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> mFamilyRoleListMap = {};
    mFamilyRoleListMap['index'] = index;
    mFamilyRoleListMap['mFamilyRoleList'] = mFamilyRoleList.map((e) => e.toJson()).toList();
    return mFamilyRoleListMap;
  }
}

class MFamilyRole {
  MFamilyRole({
    required this.role,
  });
  String role;

  factory MFamilyRole.newOne(){
    return MFamilyRole(
      role: '',
    );
  }

  factory MFamilyRole.fromJson(Map<String, dynamic> json){
    return MFamilyRole(
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> mFamilyRoleMap = {};
    mFamilyRoleMap['role'] = role;

    return mFamilyRoleMap;
  }

  @override
  String toString() {
    return role;
  }

  @override
  bool operator == (Object other) => other is MFamilyRole && other.role == role;

  @override
  int get hashCode => role.hashCode;

}