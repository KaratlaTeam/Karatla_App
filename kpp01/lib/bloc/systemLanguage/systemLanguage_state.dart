

import 'package:flutter/material.dart';
import 'package:kpp01/bloc/systemLanguage/bloc.dart';
import 'package:kpp01/dataModel/systemLanguageModel.dart';

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
