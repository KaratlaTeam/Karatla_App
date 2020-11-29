import 'dart:math';
class MathFunction{

  List<int> getRandom(int length,int randomRange){
    return _random(length, randomRange);
  }

  List<int> _random(int length,int randomRange){
    Random random = Random();
    List<int> randomList = List<int>();
    int randomNumber;
    for(int i = 0 ; i< length; i++){
      randomNumber = random.nextInt(randomRange);
      for(int i = 0 ; i < randomList.length ; i++){
        if(randomList[i] == randomNumber){
          randomNumber = null;
          i = randomList.length;
        }
      }
      if(randomNumber == null){
        i--;
      }else{
        randomList.add(randomNumber);
      }
    }
    return randomList;
  }
}