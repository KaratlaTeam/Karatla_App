

import 'package:flutter/material.dart';
import 'package:PPM/bloc/systemLanguage/bloc.dart';
import 'package:PPM/dataModel/systemLanguageModel.dart';

abstract class SystemLanguageState{
  const SystemLanguageState();
}
class SystemLanguageStateProcessing extends SystemLanguageState {

}

class SystemLanguageStateFinished extends SystemLanguageState {
  const SystemLanguageStateFinished({
    @required this.systemLanguageModel,
  }):assert(systemLanguageModel != null);
  final SystemLanguageModel systemLanguageModel;

}

class SystemLanguageStateError extends SystemLanguageState{
  SystemLanguageStateError({@required this.e});
  final e;
  backError(){
    return print("SystemLanguageStateError: \n"+e.toString());
  }
}
