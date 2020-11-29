class SchedeluModel{
  SchedeluModel({
    this.index,
    this.date,
    this.time,
    this.content,
    this.isActive,
  });

  int index ;
  List<String> date ;
  List<String>  time ;
  List<String>  content ;
  List<bool>  isActive ;

  initialData() {
    index = 0;
    date = ["", "", "", "", ""];
    time = ["", "", "", "", ""];
    content = ["", "", "", "", ""];
    isActive = [true, true, true, true, true, ];
  }

  factory SchedeluModel.fromJson(Map<String, dynamic> json){
    
    return SchedeluModel(
      index: json["index"] != null ? json["index"] : null,
      date: json["date"] != null ? List<String>.from(json["date"]) : null,
      time: json["time"] != null ? List<String>.from(json["time"]) : null,
      content: json["content"] != null ? List<String>.from(json["content"]) : null,
      isActive: json["isActive"] != null ? List<bool>.from(json["isActive"]) : null,

    );
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> schedeluModel = Map<String, dynamic>();
    schedeluModel["index"] = index;
    if(this.date != null){
      schedeluModel["date"] = this.date;
    }

    if(this.time != null){
      schedeluModel["time"] = this.time;
    }

    if(this.content != null){
      schedeluModel["content"] = this.content;
    }

    if(this.isActive != null){
      schedeluModel["isActive"] = this.isActive;
    }

    return schedeluModel;

  }
  
}