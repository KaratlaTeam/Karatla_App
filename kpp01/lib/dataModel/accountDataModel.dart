
import 'dart:convert';

import 'package:kpp01/dataModel/favoriteListModel.dart';
import 'package:kpp01/dataModel/httpModel.dart';
import 'package:kpp01/dataModel/testDataModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountDataModel {
  AccountDataModel({
    this.myUuid ,
    this.myName ,
    this.myPhoto,
    this.myPhone ,
    this.myEmail ,
    this.myState ,
    this.myLoginType ,
    this.myDeviceIdNow ,

    this.myFavoriteListPartList,
    this.myTestAnswerAllModelList,
  });

  String myUuid,myPhone,myEmail,myName,myPhoto,myDeviceIdNow;
  String myLoginType;
  String myState;

  MyFavoriteListPartList myFavoriteListPartList;
  TestAnswerAllModelList myTestAnswerAllModelList;

  initialData(){
    myUuid = "-";
    myName = "-";
    myPhoto = "assets/images/profile/profileP.jpg";
    myPhone = "-";
    myEmail = "-";
    myState = "OFF";
    myLoginType = "PHONE";
    myDeviceIdNow = "888888";

    myFavoriteListPartList = MyFavoriteListPartList(
      myFavoriteListPart1: MyFavoriteListPart1(myFavoriteListPart1: List<int>()),
      myFavoriteListPart2: MyFavoriteListPart2(myFavoriteListPart2: List<int>()),
      myFavoriteListPart3: MyFavoriteListPart3(myFavoriteListPart3: List<int>()),
    );

    myTestAnswerAllModelList = TestAnswerAllModelList(testAnswerAllModel: List<TestAnswerAllModel>());
  }

  factory AccountDataModel.fromJson(Map<String, dynamic> json){
    return AccountDataModel(
      myUuid: json['my_uuid'],
      myState: json['my_state'],
      myName: json['my_name'],
      myPhone: json['my_phone'],
      myEmail: json['my_email'],
      myPhoto: json['my_photo'],
      myDeviceIdNow: json['my_device_id_now'],
      myLoginType: json['my_login_type'],

      /// can not get data for now
      ///myFavoriteListPartList: MyFavoriteListPartList.from(json["my_favorite_list_part_list"]),
      ///myTestAnswerAllModelList :TestAnswerAllModelList.from(json["my_test_answer_all_model_list"]),

    );
  }

  Future<AccountDataModel> setSharedPreferences(HttpModel httpModel, AccountDataModel accountDataModel)async{

    accountDataModel = AccountDataModel.fromJson(httpModel.data);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("my_uuid", accountDataModel.myUuid);
    await sharedPreferences.setString("my_state", accountDataModel.myState);
    await sharedPreferences.setString("my_name", accountDataModel.myName);
    await sharedPreferences.setString("my_phone", accountDataModel.myPhone);
    await sharedPreferences.setString("my_email", accountDataModel.myEmail);
    await sharedPreferences.setString("my_photo", accountDataModel.myPhoto);
    await sharedPreferences.setString("my_device_id_now", accountDataModel.myDeviceIdNow);
    await sharedPreferences.setString("my_login_type",accountDataModel.myLoginType);


    accountDataModel = await getSharePTest(accountDataModel);
    accountDataModel = await getSharePFavorite(accountDataModel);
    /// can not get data for now
    ///var jsonBody = accountDataModel.myTestAnswerAllModelList.toJson();
    ///await sharedPreferences.setString("my_test_answer_all_model_list", json.encode(jsonBody));

    ///var jsonBody2 = accountDataModel.myFavoriteListPartList.toJson();
    ///await sharedPreferences.setString("my_favorite_list_part_list", json.encode(jsonBody2));

    return accountDataModel;
  }

  Future <AccountDataModel> getSharedPreferences(AccountDataModel accountDataModel)async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    accountDataModel.myUuid = sharedPreferences.getString("my_uuid");
    accountDataModel.myState = sharedPreferences.getString("my_state");
    accountDataModel.myName = sharedPreferences.getString("my_name");
    accountDataModel.myPhone = sharedPreferences.getString("my_phone");
    accountDataModel.myEmail = sharedPreferences.getString("my_email");
    accountDataModel.myEmail = sharedPreferences.getString("my_photo");
    accountDataModel.myDeviceIdNow = sharedPreferences.getString("my_device_id_now");
    accountDataModel.myLoginType = sharedPreferences.getString("my_login_type") ;


    accountDataModel = await getSharePTest(accountDataModel);
    accountDataModel = await getSharePFavorite(accountDataModel);
    return accountDataModel;
  }

  Future<AccountDataModel> getSharePFavorite(AccountDataModel accountDataModel)async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jsonBody = sharedPreferences.getString("my_favorite_list_part_list${accountDataModel.myUuid}");
    if(jsonBody == null){
      accountDataModel.myFavoriteListPartList = MyFavoriteListPartList(
        myFavoriteListPart1: MyFavoriteListPart1(myFavoriteListPart1: List<int>()),
        myFavoriteListPart2: MyFavoriteListPart2(myFavoriteListPart2: List<int>()),
        myFavoriteListPart3: MyFavoriteListPart3(myFavoriteListPart3: List<int>()),
      );
    }else{
      var decodeJsonBody = await json.decode(jsonBody);
      MyFavoriteListPartList myFavoriteListPartList = MyFavoriteListPartList.from(decodeJsonBody);
      accountDataModel.myFavoriteListPartList = myFavoriteListPartList;
    }

    return accountDataModel;
  }

  Future<AccountDataModel> getSharePTest(AccountDataModel accountDataModel)async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jsonBody = sharedPreferences.getString("my_test_answer_all_model_list${accountDataModel.myUuid}");
    if(jsonBody == null){
      accountDataModel.myTestAnswerAllModelList = TestAnswerAllModelList(testAnswerAllModel: List<TestAnswerAllModel>());
    }else{
      var decodeJsonBody = await json.decode(jsonBody);
      TestAnswerAllModelList testAnswerAllModelList = TestAnswerAllModelList.from(decodeJsonBody);
      accountDataModel.myTestAnswerAllModelList = testAnswerAllModelList;
    }

    return accountDataModel;
  }

  Future setSharePFavorite()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("my_favorite_list_part_list$myUuid", json.encode(myFavoriteListPartList.toJson()));
  }

  Future setSharePTest()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("my_test_answer_all_model_list$myUuid", json.encode(myTestAnswerAllModelList.toJson()));
  }

  Future setSharePLogOut()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    myState = "OFF";
    sharedPreferences.setString("my_state", myState);
  }

}

