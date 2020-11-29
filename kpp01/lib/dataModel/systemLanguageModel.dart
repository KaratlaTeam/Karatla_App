
import 'package:kpp01/typedef.dart';

class SystemLanguageModel{
  SystemLanguageCode systemLanguageCode;
  
  String get title {
    if(systemLanguageCode == SystemLanguageCode.EN){
      return _title_en;
    }else if(systemLanguageCode == SystemLanguageCode.CN){
      return _title_cn;
    }
    return _title_en;
  }

  String get kpp01Title {
    if(systemLanguageCode == SystemLanguageCode.EN){
      return _kpp01Title_en;
    }else if(systemLanguageCode == SystemLanguageCode.CN){
      return _kpp01Title_cn;
    }
    return _kpp01Title_en;
  }

  initialData(){
    systemLanguageCode = SystemLanguageCode.EN;
  }

  codeString(){
    if(this.systemLanguageCode == SystemLanguageCode.EN){
      return "en";
    }else if(this.systemLanguageCode == SystemLanguageCode.CN){
      return "cn";
    }else if(this.systemLanguageCode == SystemLanguageCode.MALAY){
      return "malay";
    }
  }


    static const String _title_en = "title";
    static const String _title_cn = "标题";

    static const String _kpp01Title_en = "KPP01";
    static const String _kpp01Title_cn = "理论";
}
