class MyTimeM {

  MyTimeM({
    this.year,
    this.month,
    this.minute,
    this.day,
    this.hour,
    this.second,
});

  int year,month,day,hour,minute,second;

  initialize(int year, int month, int day, int hour, int minute, int second){
    this.year = year;
    this.month = month;
    this.day = day;
    this.hour = hour;
    this.minute = minute;
    this.second = second;
  }

  factory MyTimeM.fromJson(Map<String, dynamic> json){
    return MyTimeM(
      year: json['year'],
      month: json['month'],
      day: json['day'],
      hour: json['hour'],
      minute: json['minute'],
      second: json['second'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> myTime = Map<String, dynamic>();
    myTime["year"] = this.year;
    myTime["month"] = this.month;
    myTime["minute"] = this.minute;
    myTime["day"] = this.day;
    myTime["hour"] = this.hour;
    myTime["second"] = this.second;

    return myTime;
  }

}