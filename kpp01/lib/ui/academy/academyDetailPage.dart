import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpp01/bloc/appDataBloc/appDataBloc.dart';
import 'package:kpp01/bloc/appDataBloc/appDataState.dart';
import 'package:kpp01/dataModel/appDataModel.dart';
import 'package:kpp01/myPlugin/dataAppSizePlugin.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class AcademyDetailPage extends StatelessWidget{

  const AcademyDetailPage({
    Key key,
  }):super(key:key);



  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return BlocBuilder<AppDataBloc,AppDataState>(
      builder: (context,appDataState){
        AppDataModel appDataModel = _getAppDataModel(appDataState);
        return Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Colors.black,
                iconTheme: IconThemeData(color: Colors.white),
                textTheme: TextTheme(headline6: TextStyle(color: Colors.white,fontSize: appDataModel.dataAppSizePlugin.scaleFortSize*16)),
                pinned: true,
                expandedHeight: appDataModel.dataAppSizePlugin.scaleW*200,
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.asset("assets/images/academy/academyExample.png",fit: BoxFit.cover),
                  centerTitle: false,
                  title: Text("* Metro Driving Academy Sdn Bhd (W 1009)",style: TextStyle(color: Colors.white,fontSize: appDataModel.dataAppSizePlugin.scaleFortSize*15),maxLines: 1,),
                  titlePadding: EdgeInsets.only(left: appDataModel.dataAppSizePlugin.scaleW*50,bottom: appDataModel.dataAppSizePlugin.scaleW*15),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                    margin: EdgeInsets.symmetric(vertical: appDataModel.dataAppSizePlugin.scaleW*10),
                    height: appDataModel.dataAppSizePlugin.scaleW*200,
                    child: Swiper(
                      itemBuilder: (context, int index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image.asset("assets/images/academy/academyExample.png", fit: BoxFit.cover,),
                        );
                      },
                      itemCount: 10,
                      viewportFraction: 0.8,
                      scale: 0.9,
                    ),
                  ),
                  Container(
                    height: appDataModel.dataAppSizePlugin.scaleW*200,
                    margin: EdgeInsets.all(appDataModel.dataAppSizePlugin.scaleW*10),
                    child: Card(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(appDataModel.dataAppSizePlugin.scaleW*10),
                            child: ListTile(
                              title: Text("About Us"),
                              subtitle: Column(
                                children: <Widget>[
                                  Divider(),
                                  Text("Established in 1998, Metro Driving Academy was licensed and awarded as the BEST DRIVING ACADEMY & 5 STAR Rated Driving Academy by the Road Transport Department of Malaysia."),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Transform(
                              transform: Matrix4.rotationZ(-0.4),
                              child: Icon(Icons.drafts,color: Colors.red,),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: appDataModel.dataAppSizePlugin.scaleH*250,
                    child:  ClipRRect(
                      borderRadius: BorderRadius.circular(7.0),
                      child: Image.asset("assets/images/academy/academyMapExample.jpeg",fit: BoxFit.cover,),
                    ),
                  ),
                ]),
              ),],
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