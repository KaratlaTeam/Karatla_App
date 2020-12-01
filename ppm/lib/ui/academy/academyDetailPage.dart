import 'dart:ui';

import 'package:PPM/httpSource.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:PPM/bloc/appDataBloc/appDataBloc.dart';
import 'package:PPM/dataModel/appDataModel.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:PPM/dataModel/drivingAcademyDataModel.dart';
import 'package:maps_launcher/maps_launcher.dart';

class AcademyDetailPage extends StatefulWidget {
  const AcademyDetailPage({
    Key key,
    //this.title: "* Metro Driving Academy Sdn Bhd (W 1009)",
    //this.describtion:
    //    "Established in 1998, Metro Driving Academy was licensed and awarded as the BEST DRIVING ACADEMY & 5 STAR Rated Driving Academy by the Road Transport Department of Malaysia.",
    //this.time: "08 : 00 - 17 : 30",
    //this.location: "Ioi City Mall",
    this.drivingAcademyDataModel,
  }) : super(key: key);

  //final String title;
  //final String describtion;
  //final String time;
  //final String location;
  final DrivingAcademyDataModel drivingAcademyDataModel;

  @override
  _AcademyDetailPageState createState() => _AcademyDetailPageState();
}

class _AcademyDetailPageState extends State<AcademyDetailPage> {
  @override
  void initState() {
    //FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.white,
      statusBarBrightness: Brightness.dark,

      /// Only honored in iOS.
      statusBarIconBrightness: Brightness.light,

      ///Only honored in Android version M and greater.
      systemNavigationBarIconBrightness: Brightness.dark,

      ///Only honored in Android versions O and greater.
    ));
    super.initState();
  }

  @override
  void dispose() {
    //FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.white,
      statusBarBrightness: Brightness.light,

      /// Only honored in iOS.
      statusBarIconBrightness: Brightness.dark,

      ///Only honored in Android version M and greater.
      systemNavigationBarIconBrightness: Brightness.dark,

      ///Only honored in Android versions O and greater.
    ));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppDataModel appDataModel =
        BlocProvider.of<AppDataBloc>(context).appDataModel;
    //  
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            brightness: Brightness.dark,
            backgroundColor: Colors.black,
            iconTheme: IconThemeData(color: Colors.white),
            //textTheme: TextTheme(
            //    headline6: TextStyle(
            //        color: Colors.red,
            //        fontSize:
            //            appDataModel.dataAppSizePlugin.scaleFortSize * 16)),
            pinned: true,
            expandedHeight: appDataModel.dataAppSizePlugin.scaleW * 200,
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: HttpSource.webUrl+widget.drivingAcademyDataModel.photos[0],
                fit: BoxFit.cover,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              centerTitle: false,
              title: Text(
                widget.drivingAcademyDataModel.name,
                style: TextStyle(
                    color: Colors.white,
                    fontSize:
                        appDataModel.dataAppSizePlugin.scaleFortSize * 15),
                maxLines: 1,
              ),
              titlePadding: EdgeInsets.only(
                  left: appDataModel.dataAppSizePlugin.scaleW * 50,
                  bottom: appDataModel.dataAppSizePlugin.scaleW * 15),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: appDataModel.dataAppSizePlugin.scaleW * 10),
                height: appDataModel.dataAppSizePlugin.scaleW * 200,
                child: Swiper(
                  itemBuilder: (context, int index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: CachedNetworkImage(
                        imageUrl: HttpSource.webUrl+HttpSource.getAcademyImages+widget.drivingAcademyDataModel.photos[index],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    );
                  },
                  itemCount: widget.drivingAcademyDataModel.photos.length,
                  viewportFraction: 0.8,
                  scale: 0.9,
                ),
              ),
              Container(
                height: appDataModel.dataAppSizePlugin.scaleW * 200,
                margin: EdgeInsets.only(
                    left: appDataModel.dataAppSizePlugin.scaleW * 10,
                    right: appDataModel.dataAppSizePlugin.scaleW * 10,
                    top: appDataModel.dataAppSizePlugin.scaleW * 20),
                child: Card(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(
                            appDataModel.dataAppSizePlugin.scaleW * 10),
                        child: ListTile(
                          title: Text("About Us"),
                          subtitle: Column(
                            children: <Widget>[
                              Divider(),
                              Text(widget.drivingAcademyDataModel.describtion),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Transform(
                          transform: Matrix4.rotationZ(-0.4),
                          child: Icon(
                            Icons.drafts,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: appDataModel.dataAppSizePlugin.scaleH * 30),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        left: appDataModel.dataAppSizePlugin.scaleW * 20,
                      ),
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: Icon(Icons.alarm),
                        //color: appDataModel.myThemeData.myThemeColor,
                        iconSize: 20,
                        disabledColor: Colors.black,
                        onPressed: null,
                      ),
                    ),
                    Container(
                      width: appDataModel.dataAppSizePlugin.scaleW * 320,
                      //height: ,
                      // margin: EdgeInsets.only(left: appDataModel.dataAppSizePlugin.scaleW*20, right: appDataModel.dataAppSizePlugin.scaleW*20, top: appDataModel.dataAppSizePlugin.scaleH*20),
                      child: Text(
                        widget.drivingAcademyDataModel.time[0],
                        style: TextStyle(
                          fontSize:
                              appDataModel.dataAppSizePlugin.scaleFortSize * 14,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  bottom: appDataModel.dataAppSizePlugin.scaleH * 20,
                ),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        left: appDataModel.dataAppSizePlugin.scaleW * 20,
                      ),
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: Icon(Icons.location_on_outlined),
                        //color: appDataModel.myThemeData.myThemeColor,
                        iconSize: 20,
                        disabledColor: Colors.black,
                        onPressed: null,
                      ),
                    ),
                    Builder(
                      builder: (BuildContext context) {
                        return Container(
                            width: appDataModel.dataAppSizePlugin.scaleW * 320,
                            //height: ,
                            // margin: EdgeInsets.only(left: appDataModel.dataAppSizePlugin.scaleW*20, right: appDataModel.dataAppSizePlugin.scaleW*20, top: appDataModel.dataAppSizePlugin.scaleH*20),
                            child: InkWell(
                              child: Text(
                                widget.drivingAcademyDataModel.location[0],
                                style: TextStyle(
                                    fontSize: appDataModel
                                            .dataAppSizePlugin.scaleFortSize *
                                        14),
                              ),
                              onLongPress: () {
                                Clipboard.setData(ClipboardData(
                                    text: widget
                                        .drivingAcademyDataModel.location[0]));
                                Scaffold.of(context).showSnackBar(
                                    SnackBar(content: Text("Location Copied")));
                              },
                            ));
                      },
                    ),
                  ],
                ),
              ),
              Builder(builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () async {
                    await MapsLauncher.launchQuery(
                        widget.drivingAcademyDataModel.location[0]);
                  },
                  onLongPress: () {
                    Clipboard.setData(ClipboardData(
                        text: widget.drivingAcademyDataModel.location[0]));
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text("Location Copied")));
                  },
                  child: Container(
                    height: appDataModel.dataAppSizePlugin.scaleH * 250,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7.0),
                      child: CachedNetworkImage(
                        imageUrl: HttpSource.webUrl+HttpSource.getAcademyImages+widget.drivingAcademyDataModel.location[1],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                );
              }),
            ]),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {},
        label: Text("Register"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
    );
  }
}
