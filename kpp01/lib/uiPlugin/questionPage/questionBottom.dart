
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpp01/bloc/appDataBloc/appDataBloc.dart';
import 'package:kpp01/bloc/appDataBloc/appDataState.dart';
import 'package:kpp01/dataModel/appDataModel.dart';
import 'package:kpp01/myPlugin/dataAppSizePlugin.dart';
import 'package:kpp01/typedef.dart';

class QuestionBottom extends StatelessWidget{

  const QuestionBottom({
    Key key,
    @required this.dataLength,
    @required this.getLetterColors,
    @required this.pageIndex,
    @required this.iconButton,
    @required this.bottomSheetOnTap,
  }):super(key:key);

  final int dataLength;
  final ListColorsWithIndexCallback getLetterColors;
  final int pageIndex;
  final IconButton iconButton;
  final IndexCallback bottomSheetOnTap;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<AppDataBloc,AppDataState>(
      builder: (context,appDataState){
        AppDataModel appDataModel = _getAppDataModel(appDataState);
        return BottomAppBar(
          elevation: 0,
          child: Container(
            height: appDataModel.dataAppSizePlugin.scaleH*40,
            child: Row(children: <Widget>[
              Expanded(
                flex: 1,
                child: iconButton,
              ),
              Expanded(
                flex: 4,
                child: Container(
                  margin: EdgeInsets.only(right: appDataModel.dataAppSizePlugin.scaleW*20),
                  child: QuestionBottomSheetRight(
                    dataLength: dataLength,
                    getLetterColors: getLetterColors,
                    pageIndex: pageIndex,
                    bottomSheetOnTap: bottomSheetOnTap,
                  ),
                ),
              ),
            ],),
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

class QuestionBottomSheetRight extends StatelessWidget{

  const QuestionBottomSheetRight({
    Key key,
    @required this.dataLength,
    @required this.pageIndex,
    @required this.getLetterColors,
    @required this.bottomSheetOnTap,
}):super(key:key);

  final int dataLength;
  final int pageIndex;
  final ListColorsWithIndexCallback getLetterColors;
  final IndexCallback bottomSheetOnTap;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: (){
        showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          isScrollControlled: true,
          builder: ((BuildContext context){
            return QuestionBottomSheet(
              dataLength: dataLength,
              getLetterColors: getLetterColors,
              onTap: bottomSheetOnTap,
            );
          }),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Icon(Icons.apps),
          Text('${pageIndex+1}/$dataLength'),
        ],
      ),
    );
  }
}

class QuestionBottomSheet extends StatelessWidget{

  const QuestionBottomSheet({
    Key key,
    this.dataLength,
    this.getLetterColors,
    this.onTap,
}):super(key:key);
  final int dataLength;
  final ListColorsWithIndexCallback getLetterColors;
  final IndexCallback onTap;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<AppDataBloc,AppDataState>(
      builder: (context,appDataState){
        AppDataModel appDataModel = _getAppDataModel(appDataState);
        return Container(
          height: appDataModel.dataAppSizePlugin.scaleH*500,
          child: Column(
            children: <Widget>[
              Container(
                height: appDataModel.dataAppSizePlugin.scaleH*30,
                alignment: Alignment.center,
                child: Icon(Icons.drag_handle,size: appDataModel.dataAppSizePlugin.scaleW*30,color: Colors.grey,),
              ),
              Flexible(
                //margin: EdgeInsets.only(top: dataAppSizePlugin.scaleH*30),
                //padding: EdgeInsets.symmetric(horizontal:dataAppSizePlugin.scaleW*10),
                child: GridView.builder(
                  padding: EdgeInsets.all(appDataModel.dataAppSizePlugin.scaleW*10),
                  itemCount: dataLength,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    mainAxisSpacing: appDataModel.dataAppSizePlugin.scaleW*20,
                    crossAxisSpacing: appDataModel.dataAppSizePlugin.scaleW*20,
                    childAspectRatio: 1.0,
                  ),
                  itemBuilder: ((BuildContext context,int index){
                    return GestureDetector(
                      onTap: (){
                        if(onTap != null){
                          onTap(index);
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(color: getLetterColors(index)[1],borderRadius: BorderRadius.circular(45)),
                        child: Center(
                          child: Text('${index+1}',style: TextStyle(color: getLetterColors(index)[0]),),
                        ),
                      ),
                    );
                  }),
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