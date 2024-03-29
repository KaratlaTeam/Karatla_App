import 'package:PPM/dataModel/drivingAcademyDataModel.dart';
import 'package:PPM/httpSource.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:PPM/bloc/drivingAcademyDataBloc/drivingAcademyDataBloc.dart';
import 'package:PPM/bloc/drivingAcademyDataBloc/drivingAcademyDataEvent.dart';
import 'package:PPM/bloc/drivingAcademyDataBloc/drivingAcademyDataState.dart';
import 'package:PPM/bloc/appDataBloc/appDataBloc.dart';
import 'package:PPM/bloc/systemLanguage/systemLanguage_bloc.dart';
import 'package:PPM/dataModel/appDataModel.dart';
import 'package:PPM/dataModel/systemLanguageModel.dart';
import 'package:PPM/statePage.dart';
import 'package:PPM/ui/academy/academyDetailPage.dart';
import 'package:PPM/uiPlugin/myCircleButton.dart';
import 'package:geolocator/geolocator.dart';

class AcademyMainPage extends StatefulWidget {
  @override
  _AcademyMainPageState createState() => _AcademyMainPageState();
}

class _AcademyMainPageState extends State<AcademyMainPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppDataModel appDataModel =
        BlocProvider.of<AppDataBloc>(context).appDataModel;
    SystemLanguageModel systemLanguageModel =
        BlocProvider.of<SystemLanguageBloc>(context).systemLanguageModel;
    return BlocBuilder<DrivingAcademyDataBloc, DrivingAcademyDataState>(
      builder: (context, drivingAcademyDataState) {
        if (drivingAcademyDataState is DrivingAcademyDataStateError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  appDataModel.myDeviceLocation.position==null? Text(drivingAcademyDataState.e) : null,
                  appDataModel.myDeviceLocation.position==null? RaisedButton(
                    onPressed: ()async{
                      await Geolocator.openAppSettings();
                    },
                    child: Text("Setting"),
                  ) : null,
                  RaisedButton(
                    onPressed: () {
                      BlocProvider.of<DrivingAcademyDataBloc>(context).add(
                          DrivingAcademyDataEventCheckInternetThenGet(
                              systemLanguage:
                                  systemLanguageModel.codeString()));
                    },
                    child: Text("Refresh"),
                  ),
                ],
              ),
            ),
          );
        } else if (drivingAcademyDataState is DrivingAcademyDataStateGetting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (drivingAcademyDataState is DrivingAcademyDataStateGot) {
          return Scaffold(
            body: Stack(
              //alignment: Alignment.center,
              children: <Widget>[
                Container(
                  //color: Colors.red,
                  padding: EdgeInsets.only(
                    top: appDataModel.dataAppSizePlugin
                        .top, //+appDataModel.dataAppSizePlugin.scaleH*60,
                    bottom: appDataModel.dataAppSizePlugin.scaleH * 45,
                  ),
                  child: RefreshIndicator(
                    onRefresh: () async {
                      BlocProvider.of<DrivingAcademyDataBloc>(context).add(
                          DrivingAcademyDataEventCheckInternetThenGet(
                              systemLanguage:
                                  systemLanguageModel.codeString()));
                    },
                    child: ListView.builder(
                      padding: EdgeInsets.only(
                          top: appDataModel.dataAppSizePlugin.scaleH * 20,
                          left: appDataModel.dataAppSizePlugin.scaleW * 10,
                          right: appDataModel.dataAppSizePlugin.scaleW * 10,
                          bottom: appDataModel.dataAppSizePlugin.scaleH * 30),
                      itemCount: drivingAcademyDataState
                          .drivingAcademyDataModelList
                          .drivingAcademyDataModelList
                          .length,
                      itemBuilder: (context, index) {
                        return MyOpenContainer(
                          closedShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          closedElevation: 1,
                          height: appDataModel.dataAppSizePlugin.scaleW * 120,
                          width: 0,
                          margin: EdgeInsets.only(
                            bottom: appDataModel.dataAppSizePlugin.scaleH * 20,
                          ),
                          openColor: Colors.white,
                          closedColor: Colors.white,
                          closedBuilder:
                              (BuildContext context, VoidCallback onTap) {
                            return AcademyMainPageCard(
                              drivingAcademyDataModelList:
                                  drivingAcademyDataState
                                      .drivingAcademyDataModelList,
                              index: index,
                              photoHeight:
                                  appDataModel.dataAppSizePlugin.scaleW * 120,
                              photoWidth:
                                  appDataModel.dataAppSizePlugin.scaleW * 150,
                              //height: dataAppSizePlugin.scaleW*140,
                              //marginBottom: dataAppSizePlugin.scaleW*15,
                              name: drivingAcademyDataState
                                  .drivingAcademyDataModelList
                                  .drivingAcademyDataModelList[index]
                                  .name,
                              location: drivingAcademyDataState
                                  .drivingAcademyDataModelList
                                  .drivingAcademyDataModelList[index]
                                  .location[0],
                            );
                          },
                          openContainerBuilder:
                              (BuildContext context, VoidCallback _) {
                            return AcademyDetailPage(
                              drivingAcademyDataModel: drivingAcademyDataState
                                  .drivingAcademyDataModelList
                                  .drivingAcademyDataModelList[index],
                            );
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
        } else {
          return StatePageError();
        }
      },
    );
  }

  //Future _onRefresh(BuildContext context) async {
  //  BlocProvider.of<DrivingAcademyDataBloc>(context).add(DrivingAcademyDataEventGetDataFromInternet());
  //}
}

class AcademyMainPageCard extends StatelessWidget {
  const AcademyMainPageCard(
      {Key key,
      @required this.photoWidth,

      ///150
      @required this.photoHeight,

      ///120
      this.index,
      this.drivingAcademyDataModelList,
      //@required this.height,///140
      //@required this.marginBottom,///15

      this.name,
      this.location})
      : super(key: key);

  //final double height;
  final DrivingAcademyDataModelList drivingAcademyDataModelList;
  final double photoWidth;
  final double photoHeight;
  final int index;
  final String name;
  final String location;
  //final double marginBottom;

  @override
  Widget build(BuildContext context) {
    //
    AppDataModel appDataModel =
        BlocProvider.of<AppDataBloc>(context).appDataModel;
    return Container(
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
            child: CachedNetworkImage(
              imageUrl: HttpSource.getAcademyImages +
                  drivingAcademyDataModelList
                      .drivingAcademyDataModelList[index].photos[0],
              width: photoWidth,
              height: photoHeight,
              fit: BoxFit.cover,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          Expanded(
            child: Container(
              //color: Colors.red,
              margin: EdgeInsets.symmetric(
                  vertical: appDataModel.dataAppSizePlugin.scaleW * 10),
              child: ListTile(
                title: Text(
                  name,
                  style: TextStyle(
                      fontSize:
                          appDataModel.dataAppSizePlugin.scaleFortSize * 13),
                  maxLines: 2,
                ),
                subtitle: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      //width: appDataModel.dataAppSizePlugin.scaleW*50,
                      margin: EdgeInsets.only(
                          bottom: appDataModel.dataAppSizePlugin.scaleH * 15,
                          top: appDataModel.dataAppSizePlugin.scaleH * 40),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.location_on,
                            size: 17,
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left:
                                    appDataModel.dataAppSizePlugin.scaleW * 5),
                            width: appDataModel.dataAppSizePlugin.scaleW * 190,
                            child: Text(
                              location,
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: appDataModel
                                        .dataAppSizePlugin.scaleFortSize *
                                    13,
                              ),
                            ),
                          ),
                        ],
                      ),
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
  }
}
