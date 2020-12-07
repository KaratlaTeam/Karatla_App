import 'dart:convert';

import 'package:geolocator/geolocator.dart';
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

  mySort(double myLatitude, double myLongitude){
    List<Map> mapModelList = List<Map>();
    List<DrivingAcademyDataModel> myDrivingAcademyDataModelList = List<DrivingAcademyDataModel>();

    for(DrivingAcademyDataModel drivingAcademyDataModel in this.drivingAcademyDataModelList){
      double latitude = double.parse(drivingAcademyDataModel.location[1]);
      double longitude = double.parse(drivingAcademyDataModel.location[2]);
      double distance =  Geolocator.distanceBetween(myLatitude, myLongitude, latitude, longitude);
      mapModelList.add({"distance": distance, "data": drivingAcademyDataModel});
    }

    mapModelList.sort((a,b) => a["distance"].compareTo(b["distance"]));
    print(mapModelList);

    for(Map map in mapModelList){
      myDrivingAcademyDataModelList.add(map["data"]);
    }

    this.drivingAcademyDataModelList = myDrivingAcademyDataModelList;

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
