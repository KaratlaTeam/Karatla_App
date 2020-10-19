import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpp01/bloc/appDataBloc/appDataBloc.dart';
import 'package:kpp01/bloc/appDataBloc/appDataState.dart';
import 'package:kpp01/bloc/bottomNavigationBloc/bloc.dart';
import 'package:kpp01/bloc/checkLoginBloc/bloc.dart';
import 'package:kpp01/bloc/checkLoginBloc/checkLoginBloc.dart';
import 'package:kpp01/bloc/checkLoginBloc/checkLoginEvent.dart';
import 'package:kpp01/dataModel/appDataModel.dart';
import 'package:kpp01/dataModel/bottomNavigationDataModel.dart';
import 'package:kpp01/statePage.dart';
import 'package:kpp01/ui/academy/academyMainPage.dart';
import 'package:kpp01/ui/kpp01/kpp01TestHomePage.dart';
import 'package:kpp01/ui/profile/profileMainPage.dart';

class AppMain extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<AppDataBloc,AppDataState>(
      builder: (context,appDataState){
        AppDataModel appDataModel;
        appDataState is AppDataStateGotData ? appDataModel = appDataState.appDataModel : appDataModel = null;
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (BuildContext context) => BottomNavigationBloc(myThemeData: appDataModel.myThemeData)..add(BottomNavigationEventChangePage(0)),
            ),
          ],
          child: BlocBuilder<BottomNavigationBloc,BottomNavigationState>(
            builder: (context,bottomNavigationState){
              if(bottomNavigationState is BottomNavigationStatePageChanging){
                return StatePageWaiting();
              }else if(bottomNavigationState is BottomNavigationStatePageChanged ){
                BottomNavigationDataModel bottomNavigationDataModel = bottomNavigationState.bottomNavigationDataModel;
                return AppMainBody(bottomNavigationDataModel: bottomNavigationDataModel,appDataModel: appDataModel,);
              }else {
                return StatePageError();
              }
            },
          ),
        );
      },
    );
  }
}

class AppMainBody extends StatelessWidget{
  const AppMainBody({
    Key key,
    this.bottomNavigationDataModel,
    this.appDataModel,
  }):super(key:key);
  final BottomNavigationDataModel bottomNavigationDataModel;
  final AppDataModel appDataModel;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<CheckLoginBloc,CheckLoginState>(
      builder: (context,checkLoginState){
        return Scaffold(
          body: _bottomNavigationPageChange(bottomNavigationDataModel.index),
          bottomSheet: BottomAppBar(
            //color: Colors.red,
            elevation: 0,
            child: Container(
              height: appDataModel.dataAppSizePlugin.scaleH*75,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Flexible(
                    child: Builder(
                      builder: (context){
                        return IconButton(
                          icon: Icon(Icons.home),
                          color: bottomNavigationDataModel.color1,
                          iconSize: appDataModel.dataAppSizePlugin.scaleW*bottomNavigationDataModel.size1,
                          onPressed: (){
                            //BlocProvider.of<CheckLoginBloc>(context).add(CheckLoginEventCheck(context));
                            BlocProvider.of<BottomNavigationBloc>(context).add(BottomNavigationEventChangePage(0));
                          },
                        );
                      },
                    ),
                  ),
                  Flexible(
                    child: Builder(
                      builder: (context){
                        return IconButton(
                          icon: Icon(Icons.school),
                          color: bottomNavigationDataModel.color2,
                          iconSize: appDataModel.dataAppSizePlugin.scaleW*bottomNavigationDataModel.size2,
                          onPressed: (){
                            //BlocProvider.of<CheckLoginBloc>(context).add(CheckLoginEventCheck(context));
                            BlocProvider.of<BottomNavigationBloc>(context).add(BottomNavigationEventChangePage(1));
                          },
                        );
                      },
                    ),
                  ),
                  Flexible(
                    child: Builder(
                      builder: (context){
                        return IconButton(
                          icon: Icon(Icons.person),
                          color: bottomNavigationDataModel.color3,
                          iconSize: appDataModel.dataAppSizePlugin.scaleW*bottomNavigationDataModel.size3,
                          onPressed: (){
                            //BlocProvider.of<CheckLoginBloc>(context).add(CheckLoginEventCheck(context));
                            BlocProvider.of<BottomNavigationBloc>(context).add(BottomNavigationEventChangePage(2));
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  StatelessWidget _bottomNavigationPageChange(int index){
    if(index == 0){
      return AcademyMainPage();
    }else if(index == 1){
      return Kpp01TestHomePage();
    }else if(index == 2){
      return ProfileMainPage();
    }else{
      return StatePageError();
    }
  }
}