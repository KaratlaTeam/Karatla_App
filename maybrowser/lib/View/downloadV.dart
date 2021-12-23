import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DownloadV extends StatefulWidget{
  DownloadV({
    Key? key,
    this.showBottom: false,
  }):super(key: key);
  final bool showBottom;

  @override
  _DownloadVState createState() => _DownloadVState();
}
class _DownloadVState extends State<DownloadV>{

  int colorIndex = 0;
  Color tabColor = Color(0xfffde2a0);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xff6a7d6b),
      body: Container(
        child: Row(
          children: [
            Flexible(
              fit: FlexFit.tight,
              flex: 6,
              child: Column(
                children: [
                  widget.showBottom == true ? Container() : Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 15,top: Get.mediaQuery.padding.top+10),
                    child: IconButton(onPressed: (){Get.back();}, icon: Icon(Icons.arrow_back_ios, color: Colors.white,)),
                  ),
                  Expanded(
                    child: IndexedStack(
                      index: this.colorIndex,
                      children: [
                        _fileTabV(),
                        _pictureTabV(),
                        _videoTabV(),
                        _musicTabV(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              flex:2,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),topLeft: Radius.circular(20)),
                  color: Color(0xffb6c0a4),
                ),
                child: Column(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex:1,
                      child: GestureDetector(
                        onTap: (){
                          this.colorIndex = 0;
                          setState(() {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),topLeft: Radius.circular(20)),
                            color: this.colorIndex == 0 ? this.tabColor : Colors.transparent,
                          ),
                          child: Center(child: Icon(Icons.folder),),
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex:1,
                      child: GestureDetector(
                        onTap: (){
                          this.colorIndex = 1;
                          setState(() {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),topLeft: Radius.circular(20)),
                            color: this.colorIndex == 1 ? this.tabColor : Colors.transparent,
                          ),
                          child: Center(child: Icon(Icons.photo),),
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex:1,
                      child: GestureDetector(
                        onTap: (){
                          this.colorIndex = 2;
                          setState(() {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),topLeft: Radius.circular(20)),
                            color: this.colorIndex == 2 ? this.tabColor : Colors.transparent,
                          ),
                          child: Center(child: Icon(Icons.videocam),),
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex:1,
                      child: GestureDetector(
                        onTap: (){
                          this.colorIndex = 3;
                          setState(() {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),topLeft: Radius.circular(20)),
                            color: this.colorIndex == 3 ? this.tabColor : Colors.transparent,
                          ),
                          child: Center(child: Icon(Icons.music_note),),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _fileTabV(){
    return Container(
      //padding: EdgeInsets.only(left: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          index_1CardV("APP_A167351_WEIWANLUO.docx", "12/02/2021"),
          index_1CardV("Sims4Studio_v3.1.5.3.PPT", "12/02/2021"),
          index_1CardV("collab gen.zip", "12/02/2021"),
          index_1CardV("a167351 WEIWANLUO (1).docx", "12/02/2021"),
          index_1CardV("a167351 WEIWANLUO (2).docx", "12/01/2021"),
          IconButton(onPressed: (){}, icon: Icon(Icons.add,color: Colors.white,))
        ],
      ),
    );
  }
  _pictureTabV(){
    return Container(
      //padding: EdgeInsets.only(left: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          index_1CardV("Picture1.jpg", "12/02/2021"),
          index_1CardV("Picture3 (2).jpg", "12/02/2021"),
          index_1CardV("VR.PNG", "12/02/2021"),
          index_1CardV("WeChat Image_20210615105447.jpg", "12/02/2021"),
          index_1CardV("WIN.PNG", "12/01/2021"),
          IconButton(onPressed: (){}, icon: Icon(Icons.add,color: Colors.white,))
        ],
      ),
    );
  }
  _videoTabV(){
    return Container(
      //padding: EdgeInsets.only(left: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          index_1CardV("APP.mp4", "12/02/2021"),
          index_1CardV("web develop.mp4", "12/02/2021"),
          index_1CardV("collab gen.mp4", "12/02/2021"),
          index_1CardV("a167351 WEIWANLUO (1).mp4", "12/02/2021"),
          index_1CardV("a167351 WEIWANLUO (2).mp4", "12/01/2021"),
          IconButton(onPressed: (){}, icon: Icon(Icons.add,color: Colors.white,))
        ],
      ),
    );
  }
  _musicTabV(){
    return Container(
      //padding: EdgeInsets.only(left: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          index_1CardV("love you.mp3", "12/02/2021"),
          index_1CardV("years ago.mp3", "12/02/2021"),
          index_1CardV("happy birthday.mp3", "12/02/2021"),
          index_1CardV("la la la.mp3", "12/02/2021"),
          index_1CardV("big bong.mp3", "12/01/2021"),
          IconButton(onPressed: (){}, icon: Icon(Icons.add,color: Colors.white,))
        ],
      ),
    );
  }

  index_1CardV(String name, String date){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            width: 230,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.white,
            ),
            child: Container(
              margin: EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 150,
                    child: ListTile(
                      title: Text(name,style: TextStyle(fontSize: 10),maxLines: 1,),
                      subtitle: Text(date,style: TextStyle(fontSize: 10),),
                    ),
                  ),
                  IconButton(onPressed: (){}, icon: Icon(Icons.more_horiz)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}