import 'package:geolocator/geolocator.dart';

class MyDeviceLocation{

  Position position;

  initialData()async{
    await getPosition();
  }

  getPosition()async{
    try{
      this.position = await Geolocator.getCurrentPosition();
      print("latitude: ${this.position.latitude} longitude: ${this.position.longitude}");
    }catch(e){
      this.position = null;
      print("get location fail");
    }
  
  }

  openAppSettings()async{
    try{
      await Geolocator.openAppSettings();
    }catch(e){
      print("openApp Settings fail");
    }
    
  }

  getPermission()async{
    try{
      LocationPermission permission = await Geolocator.requestPermission();
    }catch(e){
      print("getPermission fail");
    }
    
  }

}