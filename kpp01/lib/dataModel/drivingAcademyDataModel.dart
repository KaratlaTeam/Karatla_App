import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class DrivingAcademyDataModelList {
  DrivingAcademyDataModelList({
    this.drivingAcademyDataModelList,
  });

  List<DrivingAcademyDataModel> drivingAcademyDataModelList;

  initialData() {
    this.drivingAcademyDataModelList = List<DrivingAcademyDataModel>();
  }

  factory DrivingAcademyDataModelList.fromJson(Map<String, dynamic> json) {
    return DrivingAcademyDataModelList(
      drivingAcademyDataModelList: json["drivingAcademyDataModelList"] != null
          ? (json["drivingAcademyDataModelList"] as List)
              .map((e) => DrivingAcademyDataModel.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> drivingAcademyDataModelListJson =
        Map<String, dynamic>();
    drivingAcademyDataModelListJson["drivingAcademyDataModelList"] =
        this.drivingAcademyDataModelList.map((e) => e.toJson()).toList();
    return drivingAcademyDataModelListJson;
  }

  Future<DrivingAcademyDataModelList> getSharePAcademyDataList(
    String systemLanguage,
      DrivingAcademyDataModelList drivingAcademyDataModelList) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jsonBody = sharedPreferences.getString("drivingAcademyDataModelList_$systemLanguage");
    if (jsonBody != null) {
      var decodeJsonBody = await json.decode(jsonBody);
      drivingAcademyDataModelList =
          DrivingAcademyDataModelList.fromJson(decodeJsonBody);
    }else {
      drivingAcademyDataModelList = null;
    }

    return drivingAcademyDataModelList;
  }

  Future setSharePAcademyDataList(
    String systemLanguage,
      DrivingAcademyDataModelList drivingAcademyDataModelList) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("drivingAcademyDataModelList_$systemLanguage",
        json.encode(drivingAcademyDataModelList.toJson()));
  }
}

class DrivingAcademyDataModel {
  DrivingAcademyDataModel({
    this.name,
    this.describtion,
    this.contactNumber,
    this.email,
    this.mapPicture,
    this.time,
    this.location,
    this.photos,
  });

  String name;
  String describtion;
  String contactNumber;
  String email;
  String mapPicture;
  List<String> time;
  List<String> location;
  List<String> photos;

  initialData() {
    this.name = "";
    this.describtion = "";
    this.contactNumber = "";
    this.email = "";
    this.mapPicture = "";
    this.time = List<String>();
    this.location = List<String>();
    this.photos = List<String>();
  }

  factory DrivingAcademyDataModel.fromJson(Map<String, dynamic> json) {
    return DrivingAcademyDataModel(
      name: json["name"] != null ? json["name"] : null,
      describtion: json["describtion"] != null ? json["describtion"] : null,
      contactNumber:
          json["contactNumber"] != null ? json["contactNumber"] : null,
      email: json["email"] != null ? json["email"] : null,
      mapPicture: json["mapPicture"] != null ? json["mapPicture"] : null,
      time: json["time"] != null ? List<String>.from(json["time"]) : null,
      location:
          json["location"] != null ? List<String>.from(json["location"]) : null,
      photos: json["photos"] != null ? List<String>.from(json["photos"]) : null,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> drivingAcademyDataModelMap = Map<String, dynamic>();
    if (this.name != null) {
      drivingAcademyDataModelMap["name"] = this.name;
    }
    if (this.describtion != null) {
      drivingAcademyDataModelMap["describtion"] = this.describtion;
    }
    if (this.contactNumber != null) {
      drivingAcademyDataModelMap["contactNumber"] = this.contactNumber;
    }
    if (this.email != null) {
      drivingAcademyDataModelMap["email"] = this.email;
    }
    if (this.mapPicture != null) {
      drivingAcademyDataModelMap["mapPicture"] = this.mapPicture;
    }
    if (this.time != null) {
      drivingAcademyDataModelMap["time"] = this.time;
    }
    if (this.location != null) {
      drivingAcademyDataModelMap["location"] = this.location;
    }
    if (this.photos != null) {
      drivingAcademyDataModelMap["photos"] = this.photos;
    }

    return drivingAcademyDataModelMap;
  }
}
