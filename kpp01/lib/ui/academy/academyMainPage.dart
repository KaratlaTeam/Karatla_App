import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpp01/bloc/appDataBloc/appDataBloc.dart';
import 'package:kpp01/bloc/appDataBloc/appDataState.dart';
import 'package:kpp01/dataModel/appDataModel.dart';
import 'package:kpp01/ui/academy/academyDetailPage.dart';
import 'package:kpp01/uiPlugin/myCircleButton.dart';

class AcademyMainPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<AppDataBloc,AppDataState>(
      builder: (context,appDataState){
        AppDataModel appDataModel = _getAppDataModel(appDataState);
        return Scaffold(
          body: Stack(
            //alignment: Alignment.center,
            children: <Widget>[
              Container(
                //color: Colors.red,
                padding: EdgeInsets.only(
                  top: appDataModel.dataAppSizePlugin.top,//+appDataModel.dataAppSizePlugin.scaleH*60,
                bottom: appDataModel.dataAppSizePlugin.scaleH*45,
                ),
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: appDataModel.dataAppSizePlugin.scaleH*20,left: appDataModel.dataAppSizePlugin.scaleW*10,right: appDataModel.dataAppSizePlugin.scaleW*10,bottom: appDataModel.dataAppSizePlugin.scaleH*30),
                    itemCount: 20,
                    itemBuilder: (context,index){
                      return MyOpenContainer(
                        closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        closedElevation: 1,
                        height: appDataModel.dataAppSizePlugin.scaleW*120,
                        width: 0,
                        margin: EdgeInsets.only(bottom: appDataModel.dataAppSizePlugin.scaleH*20,),
                        openColor: Colors.white,
                        closedColor: Colors.white,
                        closedBuilder: (BuildContext context,VoidCallback onTap){
                          return AcademyMainPageCard(
                            index: index,
                            photoHeight: appDataModel.dataAppSizePlugin.scaleW*120,
                            photoWidth: appDataModel.dataAppSizePlugin.scaleW*150,
                            //height: dataAppSizePlugin.scaleW*140,
                            //marginBottom: dataAppSizePlugin.scaleW*15,
                          );
                        },
                        openContainerBuilder: (BuildContext context,VoidCallback _){
                          return AcademyDetailPage();
                        },
                      );
                    },
                  ),
                ),
              ),
              //Stack(
              //  children: <Widget>[
        //
              //    Container(
              //      padding: EdgeInsets.only(top: appDataModel.dataAppSizePlugin.top),
              //      color: Colors.white,
              //      height: appDataModel.dataAppSizePlugin.scaleH*60+appDataModel.dataAppSizePlugin.top,
              //      alignment: Alignment.bottomCenter,
              //      child: Center(
              //        child: Row(
              //          mainAxisAlignment: MainAxisAlignment.spaceAround,
              //          children: <Widget>[
//
              //            GestureDetector(
              //              onTap: (){
//
              //              },
              //              child: Container(
              //                child: Row(children: <Widget>[
              //                  Text(" Distance",maxLines: 1),
              //                  Icon(Icons.swap_vert,size: 18,),
              //                ],),
              //              ),
              //            ),
              //            //GestureDetector(
              //            //  onTap: (){
              //            //  },
              //            //  child: Container(
              //            //    child: Row(children: <Widget>[
              //            //      Text(" Comment",maxLines: 1,),
              //            //      Icon(Icons.swap_vert,size: 18,),
              //            //    ],),
              //            //  ),
              //            //),
              //          ],
              //        ),
              //      ),
              //    ),
              //    Container(
              //      alignment: Alignment.center,
              //      width: appDataModel.dataAppSizePlugin.scaleW*50,
              //      color: Colors.white,
              //      height: appDataModel.dataAppSizePlugin.top+appDataModel.dataAppSizePlugin.scaleH*50,
              //      padding: EdgeInsets.only(top: appDataModel.dataAppSizePlugin.scaleH*20,left: appDataModel.dataAppSizePlugin.scaleW*10),
              //      child: GestureDetector(
              //        onTap: (){
              //        },
              //        child: Container(
              //          child: Row(children: <Widget>[
              //            Icon(Icons.location_on,size: appDataModel.dataAppSizePlugin.scaleW*18,),
              //            // Text(" Kajange",maxLines: 1,style: TextStyle(fontSize: dataAppSizePlugin.scaleFortSize*13),),
              //          ],),
              //        ),
              //      ),
              //    ),
              //  ],
              //),
            ],
          ),
        );
      },
    );
  }

  AppDataModel _getAppDataModel(AppDataState appDataState){
    if(appDataState is AppDataStateGotData){
      return appDataState.appDataModel;
    }else{
      return null;
    }
  }

  Future _onRefresh()async{
    await Future.delayed(Duration(seconds: 3), (){
      print("refresh");
    });
  }
}

class AcademyMainPageCard extends StatelessWidget{

  const AcademyMainPageCard({
    Key key,
    @required this.photoWidth,///150
    @required this.photoHeight,///120
    this.index,
    //@required this.height,///140
    //@required this.marginBottom,///15
}):super(key:key);

  //final double height;
  final double photoWidth;
  final double photoHeight;
  final int index;
  //final double marginBottom;


  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return BlocBuilder<AppDataBloc,AppDataState>(
      builder: (context,appDataState){
        AppDataModel appDataModel = _getAppDataModel(appDataState);
        return Container(
          child: Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10)),
                child: Image.asset("assets/images/academy/academyExample.png",fit: BoxFit.cover,height: photoHeight,width: photoWidth,),
              ),
              Expanded(
                 child: Container(
                   //color: Colors.red,
                   margin: EdgeInsets.symmetric(vertical: appDataModel.dataAppSizePlugin.scaleW*10),
                   child: ListTile(
                     title: Text("$index Metro Driving Academy Sdn Bhd (W 1009)",style: TextStyle(fontSize: appDataModel.dataAppSizePlugin.scaleFortSize*13),maxLines: 2,),
                     subtitle: Column(
                       //mainAxisAlignment: MainAxisAlignment.center,
                       //crossAxisAlignment: CrossAxisAlignment.center,
                       children: <Widget>[
                         Container(
                           margin: EdgeInsets.only(bottom: appDataModel.dataAppSizePlugin.scaleH*15,top: appDataModel.dataAppSizePlugin.scaleH*40),
                           child: Row(children: <Widget>[
                             Icon(Icons.location_on,size: 17,),
                             Text(" 53000 Kuala Lumpur",style: TextStyle(fontSize: appDataModel.dataAppSizePlugin.scaleFortSize*13),),
                           ],),
                         ),
                         //Container(
                         //  margin: EdgeInsets.only(bottom: dataAppSizePlugin.scaleH*10),
                         //  child: Row(children: <Widget>[
                         //    Icon(Icons.star,size: 17,),
                         //    Icon(Icons.star,size: 17,),
                         //    Icon(Icons.star,size: 17,),
                         //    Icon(Icons.star,size: 17,),
                         //    Icon(Icons.star_border,size: dataAppSizePlugin.scaleW*17,),
                         //    Text(" 4.3/5 (30)",style: TextStyle(fontSize: dataAppSizePlugin.scaleFortSize*14),),
                         //  ],),
                         //),
                       ],
                     ),
                   ),
                 ),
               ),
            ],
          ),
        );
      },
    );
  }
  AppDataModel _getAppDataModel(AppDataState appDataState){
    if(appDataState is AppDataStateGotData){
      return appDataState.appDataModel;
    }else{
      return null;
    }
  }
}