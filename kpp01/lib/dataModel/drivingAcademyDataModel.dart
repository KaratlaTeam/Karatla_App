import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

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
  

  initialData(){
    this.name = "";
    this.describtion = "";
    this.contactNumber = "";
    this.email = "";
    this.mapPicture = "";
    this.time = List<String>();
    this.location = List<String>();
    this.photos = List<String>();
  }

 factory DrivingAcademyDataModel.fromJson(Map<String, dynamic> json){
    return DrivingAcademyDataModel(
      name: json["name"] != null ? json["name"] : null,
      describtion: json["describtion"] != null ? json["describtion"] : null,
      contactNumber: json["contactNumber"] != null ? json["contactNumber"] : null,
      email: json["email"] != null ? json["email"] : null,
      mapPicture: json["mapPicture"] != null ? json["mapPicture"] : null,
      time:  json["time"] != null ? List<String>.from(json["time"])  : null,
      location:  json["location"] != null ? List<String>.from(json["location"]) : null,
      photos:  json["photos"] != null ? List<String>.from(json["photos"]) : null,
    );
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> drivingAcademyDataModelMap = Map<String, dynamic>();
    if(this.name != null){
      drivingAcademyDataModelMap["name"] = this.name;
    }
    if(this.describtion != null){
      drivingAcademyDataModelMap["describtion"] = this.describtion;
    }
    if(this.contactNumber != null){
      drivingAcademyDataModelMap["contactNumber"] = this.contactNumber;
    }
    if(this.email != null){
      drivingAcademyDataModelMap["email"] = this.email;
    }
    if(this.mapPicture != null){
      drivingAcademyDataModelMap["mapPicture"] = this.mapPicture;
    }
    if(this.time != null){
      drivingAcademyDataModelMap["time"] = this.time;
    }
    if(this.location != null){
      drivingAcademyDataModelMap["location"] = this.location;
    }
    if(this.photos != null){
      drivingAcademyDataModelMap["photos"] = this.photos;
    }
    
    return drivingAcademyDataModelMap;
  }

      Future<DrivingAcademyDataModel> getSharePAcademyData()async{
        DrivingAcademyDataModel drivingAcademyDataModel = DrivingAcademyDataModel()..initialData();
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        var jsonBody = sharedPreferences.getString("drivingAcademyDataModel");
        if(jsonBody != null){
          var decodeJsonBody = await json.decode(jsonBody);
           drivingAcademyDataModel = DrivingAcademyDataModel.fromJson(decodeJsonBody);
        }

    return drivingAcademyDataModel;
  }

    Future setSharePAcademyData()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("drivingAcademyDataModel", json.encode(toJson()));
  }

}