import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maybrowser/Logic/tabRootL.dart';
import 'package:maybrowser/Model/fileM.dart';
import 'package:maybrowser/stringSources.dart';
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
  var _position;

  @override
  void initState() {
    print("initState");
    //Get.find<TabRootL>().getAllFilesDataList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GetBuilder<TabRootL>(
      builder: (_){
        var sys = _.systemS;
        return sys == null
            ? Container(child: Center(child: RefreshProgressIndicator(),),)
            : Scaffold(
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
                            _fileTabV(_.systemS!.fileMList),
                            _fileTabV(_.systemS!.pictureMList),
                            _fileTabV(_.systemS!.videoMList),
                            _fileTabV(_.systemS!.musicMList),
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


  _fileTabV(List<FileM> data){

    Get.find<TabRootL>().sortFiles(data);

    return GetBuilder<TabRootL>(
      builder: (_){
        return Container(
          child: ListView(
            padding: EdgeInsets.only(top: 20,left: 20,right: 20),
            children: data.map((e){
              //GlobalKey _key = GlobalKey();
              final RenderBox overlay = Overlay.of(context)?.context.findRenderObject() as RenderBox;
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Container(
                  child: InkWell(
                    onTapDown: (details){
                      setState(() {
                        this._position = details.globalPosition;
                      });
                    },
                    onTap: (){
                      print('Open file: ${e.name}');
                      OpenFile.open(e.path);
                    },
                    onLongPress: (){
                      showMenu(
                        context: context,
                        position: RelativeRect.fromRect(_position & const Size(40, 40), Offset.zero & overlay.semanticBounds.size),
                        items: <PopupMenuEntry>[
                          PopupMenuItem(
                            child: Text("Open"),
                            onTap: (){
                              print('Open ${e.name}');
                              OpenFile.open(e.path);
                            },
                          ),
                          PopupMenuItem(
                            child: Text("Share"),
                            onTap: (){
                              print('Share ${e.name}');
                              Share.shareFiles([e.path]);
                            },
                          ),
                          PopupMenuItem(
                            child: Text("Rename"),
                            onTap: ()async{
                              print('Rename ${e.name}');
                              File file = File(e.path);
                              String newName = e.name;
                              Get.back();
                              Get.defaultDialog(
                                title: '${e.name}',
                                content: Center(
                                  child: TextFormField(
                                    initialValue: e.name,
                                    onChanged: (text){
                                      newName = text;
                                    },
                                    onFieldSubmitted: (text){
                                      newName = text;
                                    },
                                  ),
                                ),
                                onConfirm: ()async{
                                  int lastIndex = e.path.lastIndexOf('/');
                                  //int lastIndex2 = e.path.lastIndexOf('.');
                                  print("New name: "+newName);
                                  var newPath = e.path.replaceRange(lastIndex+1, e.path.length, newName);
                                  File f = File(newPath);
                                  if(f.existsSync()){
                                    Get.showSnackbar(GetSnackBar(title: 'WARNING',message: 'Please change name',));
                                  }else{
                                    file.renameSync(newPath);
                                    await Get.find<TabRootL>().getAllFilesDataList();
                                    Get.back();
                                  }
                                },
                              );
                              Get.defaultDialog();
                            },
                          ),
                          PopupMenuItem(
                            child: Text("Copy"),
                            onTap: ()async{
                              print('Copy ${e.name}');
                              File file = File(e.path);
                              Get.back();
                              SingleChoice? valueG = SingleChoice.File;
                              Get.defaultDialog(
                                title: 'Copy file',
                                content: StatefulBuilder(
                                  builder: (context, setState){
                                    return Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          RadioListTile<SingleChoice>(
                                              title: Text('Files'),
                                              value: SingleChoice.File,
                                              groupValue: valueG,
                                              onChanged: (SingleChoice? value){
                                                valueG = value;
                                                setState(() {});
                                              }
                                          ),
                                          RadioListTile<SingleChoice>(
                                              title: Text('Pictures'),
                                              value: SingleChoice.Picture,
                                              groupValue: valueG,
                                              onChanged: (SingleChoice? value){
                                                valueG = value;
                                                setState(() {});
                                              }
                                          ),
                                          RadioListTile<SingleChoice>(
                                              title: Text('Videos'),
                                              value: SingleChoice.Video,
                                              groupValue: valueG,
                                              onChanged: (SingleChoice? value){
                                                valueG = value;
                                                setState(() {});
                                              }
                                          ),
                                          RadioListTile<SingleChoice>(
                                              title: Text('Musics'),
                                              value: SingleChoice.Music,
                                              groupValue: valueG,
                                              onChanged: (SingleChoice? value){
                                                valueG = value;
                                                setState(() {});
                                              }
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                ),
                                onConfirm: ()async{
                                  if(valueG == SingleChoice.File){
                                    checkPath(_.systemS!.filePath, e.name, file);

                                  }else if(valueG == SingleChoice.Picture){
                                    checkPath(_.systemS!.picturePath, e.name, file);

                                  }else if(valueG == SingleChoice.Video){
                                    checkPath(_.systemS!.videoPath, e.name, file);

                                  }else if(valueG == SingleChoice.Music){
                                    checkPath(_.systemS!.musicPath, e.name, file);
                                  }
                                  await Get.find<TabRootL>().getAllFilesDataList();
                                  Get.back();
                                },
                              );
                              Get.defaultDialog();
                            },
                          ),
                          PopupMenuItem(
                            child: Text("Detail"),
                            onTap: (){
                              print('Detail ${e.name}');
                              FileStat s = e.fileStat;
                              Get.back();
                              Get.defaultDialog(
                                title: 'Detail',
                                content: Container(
                                  height: 200,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Expanded(child: Text('Name: '+e.name,style: TextStyle(fontSize: 12),),)
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text('Size: '+getSize(e.fileStat.size),style: TextStyle(fontSize: 12),),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text('Date: '+s.modified.toString(),style: TextStyle(fontSize: 12),),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Text('Path: '+e.path,style: TextStyle(fontSize: 12),),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Details"),
                                  actions: [
                                  ],
                                ),
                              );

                            },
                          ),
                          PopupMenuItem(
                            child: Text("Delete"),
                            onTap: ()async{
                              print('Delete ${e.name}');
                              File file = File(e.path);
                              file.deleteSync();
                              await Get.find<TabRootL>().getAllFilesDataList();
                            },
                          ),
                        ],
                      );
                    },
                    child: Container(
                      width: 230,
                      height: 70,
                      child: Container(
                        //color: Colors.red,
                        width: 160,
                        child: ListTile(
                          title: Text(e.name,style: TextStyle(fontSize: 12),maxLines: 1,),
                          subtitle: Text(getSize(e.fileStat.size),style: TextStyle(fontSize: 10),),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  checkPath(String p2, String name, File file){
    File nf = File(p2+'/'+name);
    var b = nf.existsSync();
    if(!b){
      var a = file.copySync(p2+'/'+name);
      print(a.path);
    }else{
      int i = name.lastIndexOf('.');
      var nameWithOutType = name.replaceRange(i, name.length, '');
      print("nameWithOutType: "+nameWithOutType);
      var fileType = name.replaceRange(0, i, '');
      print("file type: "+fileType);

      var nameF = nameWithOutType+"_copy"+fileType;
      checkPath(p2,nameF,file);
    }
  }

  String getSize(int size){
    int kb = size~/1024;
    int mb = kb~/1024;
    int gb = mb~/1024;

    if(gb>0){
      return '$gb GB';
    }else if(mb > 0){
      return '$mb MB';
    }else{
      return '$kb KB';
    }
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