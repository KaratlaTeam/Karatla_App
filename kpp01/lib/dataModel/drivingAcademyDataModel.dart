class DrivingAcademyDataModel {

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

}