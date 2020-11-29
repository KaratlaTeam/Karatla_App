import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:PPM/bloc/bottomNavigationBloc/bloc.dart';
import 'package:PPM/dataModel/bottomNavigationDataModel.dart';
import 'package:PPM/myPlugin/MyThemeData.dart';

class BottomNavigationBloc extends Bloc<BottomNavigationEvent,BottomNavigationState>{

  BottomNavigationBloc({@required this.myThemeData}):super(BottomNavigationStatePageChanging());

  final MyThemeData myThemeData;

  @override
  Stream<BottomNavigationState> mapEventToState(BottomNavigationEvent event) async*{
    if(event is BottomNavigationEventChangePage){
      yield* _mapEventToChangePage(event);
    }
  }


  Stream<BottomNavigationState> _mapEventToChangePage(BottomNavigationEventChangePage changePage)async*{
    BottomNavigationDataModel bottomNavigationDataModel;
    yield BottomNavigationStatePageChanging();
    try{
      bottomNavigationDataModel = await _getBottomNavigationDataModel(changePage.index);
      yield BottomNavigationStatePageChanged(bottomNavigationDataModel);
    }catch(e){
      yield BottomNavigationStateError(e: e)..backError();
    }
  }

  Future<BottomNavigationDataModel> _getBottomNavigationDataModel(int index)async{

    BottomNavigationDataModel bottomNavigationDataModel = BottomNavigationDataModel();
    Color mySelect = myThemeData.myThemeColor;
    Color myNotSelect = myThemeData.unSelectColor;
    double mySelectSize = 30;
    double myNotSelectSize = 20;

    if(index == 0){
      await bottomNavigationDataModel.setData(
        mySelect,
        myNotSelect,
        myNotSelect,
        mySelectSize,
        myNotSelectSize,
        myNotSelectSize,
        index,
      );
    }else if(index == 1){
      await bottomNavigationDataModel.setData(
        myNotSelect,
        mySelect,
        myNotSelect,
        myNotSelectSize,
        mySelectSize,
        myNotSelectSize,
        index,
      );
    }else if(index == 2){
      await bottomNavigationDataModel.setData(
        myNotSelect,
        myNotSelect,
        mySelect,
        myNotSelectSize,
        myNotSelectSize,
        mySelectSize,
        index,
      );
    }
    return bottomNavigationDataModel;
  }


}