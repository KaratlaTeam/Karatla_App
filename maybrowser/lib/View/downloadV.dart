import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maybrowser/Logic/tabRootL.dart';
import 'package:open_file/open_file.dart';
import 'package:share/share.dart';

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
    return GetBuilder<TabRootL>(
      builder: (_){
        var sys = _.systemS;
        return sys == null ?  Container() : Scaffold(
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
                            _fileTabV(sys.fileDir, _),
                            _fileTabV(sys.pictureDir, _),
                            _fileTabV(sys.videoDir, _),
                            _fileTabV(sys.musicDir, _),
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
      },
    );
  }

  Future<List> getData(Directory dir, TabRootL _)async{
    List data = [];
    dir.listSync().forEach((e) async{
      var name = _.getDirname(e.path);
      var state = await e.stat();
      var n = state.size/1000;

      String size = n.toString();
      data.add([name,size, e.path, state]);
    });
    return data;
  }

  _fileTabV(Directory dir, TabRootL _){

    return FutureBuilder<List>(
      future: getData(dir, _),
      builder: (context,asyncSnapShot){
        if(!asyncSnapShot.hasData){
          return CircularProgressIndicator();
        }
        List? data = asyncSnapShot.data;
        if(data == null){
          return Container();
        }else{
          return Container(
            child: ListView(
              padding: EdgeInsets.only(top: 20,left: 20,right: 20),
              children: data.reversed.toList().map((e){
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Container(
                    width: 230,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(13)),
                      color: Colors.white,
                    ),
                    child: Container(
                      margin: EdgeInsets.only(left: 10,right: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            //color: Colors.red,
                            width: 160,
                            child: ListTile(
                              title: Text(e[0],style: TextStyle(fontSize: 12),maxLines: 1,),
                              subtitle: Text(e[1]+' Kb',style: TextStyle(fontSize: 10),),
                            ),
                          ),
                          DropdownButton<String>(
                            icon: const Icon(Icons.more_horiz),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(
                                color: Colors.black
                            ),
                            underline: Container(
                              height: 0,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (String? newValue) {
                              if(newValue == 'Open'){
                                print('Open file');
                                OpenFile.open(e[2]);

                              }else if(newValue == 'Delete'){
                                print('Delete file');
                                File file = File(e[2]);
                                file.deleteSync();

                              }else if(newValue == 'Share'){
                                print('Share');
                                Share.shareFiles([e[2]]);

                              }else if(newValue == 'Detail'){
                                print('Detail');
                                FileStat s = e[3];
                                Get.defaultDialog(
                                  title: 'Detail',
                                  content: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text('Name: '+e[0],style: TextStyle(fontSize: 12),),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text('Size: '+e[1]+' Kb',style: TextStyle(fontSize: 12),),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text('Date: '+s.modified.toString(),style: TextStyle(fontSize: 12),),
                                        ],
                                      ),

                                    ],
                                  ),
                                );

                              }
                              setState(() {});
                            },
                            items: <String>['Open', 'Share', 'Detail','Delete',]
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }
      },
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