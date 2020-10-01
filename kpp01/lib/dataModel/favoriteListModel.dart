class MyFavoriteListPartList{
  MyFavoriteListPartList({this.myFavoriteListPart1,this.myFavoriteListPart2,this.myFavoriteListPart3});
  final MyFavoriteListPart1 myFavoriteListPart1;
  final MyFavoriteListPart2 myFavoriteListPart2;
  final MyFavoriteListPart3 myFavoriteListPart3;


  factory MyFavoriteListPartList.from(Map<String, dynamic> json){
    return MyFavoriteListPartList(
      myFavoriteListPart1: json["my_favorite_list_part1"] == null ? MyFavoriteListPart1(myFavoriteListPart1: List<int>()) : MyFavoriteListPart1.from(json["my_favorite_list_part1"]),
      myFavoriteListPart2: json["my_favorite_list_part2"] == null ? MyFavoriteListPart2(myFavoriteListPart2: List<int>()) : MyFavoriteListPart2.from(json["my_favorite_list_part2"]),
      myFavoriteListPart3: json["my_favorite_list_part3"] == null ? MyFavoriteListPart3(myFavoriteListPart3: List<int>()) : MyFavoriteListPart3.from(json["my_favorite_list_part3"]),
    );
  }

  Map<String, dynamic> toJson(){

    Map<String, dynamic> myFavoriteListPartList = Map<String, dynamic>();
    myFavoriteListPartList["my_favorite_list_part1"] = this.myFavoriteListPart1 == null ? MyFavoriteListPart1(myFavoriteListPart1: List<int>()) : this.myFavoriteListPart1.toJson();
    myFavoriteListPartList["my_favorite_list_part2"] = this.myFavoriteListPart2 == null ? MyFavoriteListPart2(myFavoriteListPart2: List<int>()) : this.myFavoriteListPart2.toJson();
    myFavoriteListPartList["my_favorite_list_part3"] = this.myFavoriteListPart3 == null ? MyFavoriteListPart3(myFavoriteListPart3: List<int>()) : this.myFavoriteListPart3.toJson();
    return myFavoriteListPartList;
  }
}

class MyFavoriteListPart1{
  MyFavoriteListPart1({this.myFavoriteListPart1});
  final List<int> myFavoriteListPart1;

  factory MyFavoriteListPart1.from(Map<String, dynamic> json){
    return MyFavoriteListPart1(
      myFavoriteListPart1: json["my_favorite_list_part1"] == null ? List<int>() : List<int>.from(json["my_favorite_list_part1"]),
    );
  }

  Map<String, dynamic> toJson(){

    Map<String, dynamic> part1 = Map<String, dynamic>();
    part1["my_favorite_list_part1"] = this.myFavoriteListPart1 == null ? List<int>() :this.myFavoriteListPart1;
    return part1;
  }
}

class MyFavoriteListPart2{
  MyFavoriteListPart2({this.myFavoriteListPart2});
  final List<int> myFavoriteListPart2;

  factory MyFavoriteListPart2.from(Map<String, dynamic> json){
    return MyFavoriteListPart2(
      myFavoriteListPart2: json["my_favorite_list_part2"] == null ? List<int>() : List<int>.from(json["my_favorite_list_part2"]),
    );
  }

  Map<String, dynamic> toJson(){

    Map<String, dynamic> part2 = Map<String, dynamic>();
    part2["my_favorite_list_part2"] = this.myFavoriteListPart2 == null ? List<int>() :this.myFavoriteListPart2;
    return part2;
  }

}

class MyFavoriteListPart3{
  MyFavoriteListPart3({this.myFavoriteListPart3});
  final List<int> myFavoriteListPart3;

  factory MyFavoriteListPart3.from(Map<String, dynamic> json){
    return MyFavoriteListPart3(
      myFavoriteListPart3: json["my_favorite_list_part3"] == null ? List<int>() : List<int>.from(json["my_favorite_list_part3"]),
    );
  }

  Map<String, dynamic> toJson(){

    Map<String, dynamic> part3 = Map<String, dynamic>();
    part3["my_favorite_list_part3"] = this.myFavoriteListPart3 == null ? List<int>() : this.myFavoriteListPart3;
    return part3;
  }

}