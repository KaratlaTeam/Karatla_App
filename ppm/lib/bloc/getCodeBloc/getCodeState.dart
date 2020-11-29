abstract class GetCodeState{
  const GetCodeState();
}

class GetCodeStateFinish extends GetCodeState{

}

class GetCodeStateProcess extends GetCodeState{

}

class GetCodeStateFail extends GetCodeState{
  const GetCodeStateFail({this.text });
  final String text;
}

class GetCodeStateError extends GetCodeState{
  const GetCodeStateError({this.e});
  final e;
  backError(){
    return print("GetCodeStateError: \n"+e.toString());
  }
}