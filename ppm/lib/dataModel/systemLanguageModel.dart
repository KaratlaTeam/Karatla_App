import 'package:PPM/typedef.dart';

class SystemLanguageModel {
  SystemLanguageCode systemLanguageCode;
  static const en = "en";
  static const cn = "cn";
  static const malay = "malay";

  //SettingPage
  String settingPageName;
  static const String _settingPageName = "settingPageName";
  String settingPagePhone;
  static const String _settingPagePhone = "settingPagePhone";
  String settingPageLanguage;
  static const String _settingPageLanguage = "settingPageLanguage";
  String settingPageAbout;
  static const String _settingPageAbout = "settingPageAbout";
  String settingPageLogOut;
  static const String _settingPageLogOut = "settingPageLogOut";

  //ProfileMainPage
  String profileMainPageQuiz;
  static const String _profileMainPageQuiz = "profileMainPageQuiz";
  String profileMainPagePass;
  static const String _profileMainPagePass = "profileMainPagePass";
  String profileMainPageFail;
  static const String _profileMainPageFail = "profileMainPageFail";
  String profileMainPageState;
  static const String _profileMainPageState = "profileMainPageState";
  String profileMainPageTime;
  static const String _profileMainPageTime = "profileMainPageTime";
  String profileMainPageMark;
  static const String _profileMainPageMark = "profileMainPageMark";

  //Kpp01TestHomePage
  String kpp01TestHomePageKPP01;
  static const String _kpp01TestHomePageKPP01 = "kpp01TestHomePageKPP01";
  String kpp01TestHomePageQuiz;
  static const String _kpp01TestHomePageQuiz = "kpp01TestHomePageQuiz";
  String kpp01TestHomePagePractice;
  static const String _kpp01TestHomePagePractice = "kpp01TestHomePagePractice";
  String kpp01TestHomePageHistory;
  static const String _kpp01TestHomePageHistory = "kpp01TestHomePageHistory";
  String kpp01TestHomePageFavorite;
  static const String _kpp01TestHomePageFavorite = "kpp01TestHomePageFavorite";

  //TestPage
  String testPageQuiz;
  static const String _testPageQuiz = "testPageQuiz";
  String testPageFinish;
  static const String _testPageFinish = "testPageFinish";
  String testPageYes;
  static const String _testPageYes = "testPageYes";
  String testPageNo;
  static const String _testPageNo = "testPageNo";
  String testPageDoYouFinish;
  static const String _testPageDoYouFinish = "testPageDoYouFinish";
  String testPageDoYouLeave;
  static const String _testPageDoYouLeave = "testPageDoYouLeave";

  //TestHistory
  String testHistoryNoHistory;
  static const String _testHistoryNoHistory = "testHistoryNoHistory";

  //FavoritePage
  String favoritePageNoFavorite;
  static const String _favoritePageNoFavorite = "favoritePageNoFavorite";
  String favoritePageFavorite;
  static const String _favoritePageFavorite = "favoritePageFavorite";

  //LearningPartPage
  String learningPartPagePart;
  static const String _learningPartPagePart = "learningPartPagePart";

  //AcademyDetailPage
  String academyDetailPageAbout;
  static const String _academyDetailPageAbout = "academyDetailPageAbout";
  String academyDetailPageCopied;
  static const String _academyDetailPageCopied = "academyDetailPageCopied";
  String academyDetailRegister;
  static const String _academyDetailRegister = "academyDetailRegister";

  static const Map language = {
    en: {
      //SettingPage
      _settingPageName: "Name",
      _settingPagePhone: "Phone",
      _settingPageLanguage: "Language",
      _settingPageAbout: "About",
      _settingPageLogOut: "Log Out",
      //ProfileMainPage
      _profileMainPageQuiz: "Quiz",
      _profileMainPagePass: "Pass",
      _profileMainPageFail: "Fail",
      _profileMainPageState: "State",
      _profileMainPageTime: "Time",
      _profileMainPageMark: "Mark",
      //Kpp01TestHomePage
      _kpp01TestHomePageKPP01: "KPP01",
      _kpp01TestHomePageQuiz: "Quiz",
      _kpp01TestHomePagePractice: "Practice",
      _kpp01TestHomePageHistory: "History",
      _kpp01TestHomePageFavorite: "Favorite",
      //TestPage
      _testPageQuiz: "Quiz",
      _testPageFinish: "Finish",
      _testPageYes: "Yes",
      _testPageNo: "No",
      _testPageDoYouFinish: "Do you want to finish this quiz ?",
      _testPageDoYouLeave: "Do you want to leave ?",
      //TestHistory
      _testHistoryNoHistory: "No quiz history!",
      //FavoritePage
      _favoritePageNoFavorite: "No favorite question!",
      _favoritePageFavorite: "Favorite",
      //LearningPartPage
      _learningPartPagePart: "Part",
      //AcademyDetailPage
      _academyDetailPageAbout: "About",
      _academyDetailPageCopied: "Location Copied",
      _academyDetailRegister: "Register",

    },
    cn: {
      //SettingPage
      _settingPageName: "名字",
      _settingPagePhone: "电话",
      _settingPageLanguage: "语言",
      _settingPageAbout: "关于",
      _settingPageLogOut: "注销",
      //ProfileMainPage
      _profileMainPageQuiz: "测试",
      _profileMainPagePass: "通过",
      _profileMainPageFail: "失败",
      _profileMainPageState: "状态",
      _profileMainPageTime: "时间",
      _profileMainPageMark: "备注",
      //Kpp01TestHomePage
      _kpp01TestHomePageKPP01: "KPP01(理论)",
      _kpp01TestHomePageQuiz: "模拟测试",
      _kpp01TestHomePagePractice: "考题练习",
      _kpp01TestHomePageHistory: "历史记录",
      _kpp01TestHomePageFavorite: "题库收藏",
      //TestPage
      _testPageQuiz: "测试",
      _testPageFinish: "结束",
      _testPageYes: "是",
      _testPageNo: "否",
      _testPageDoYouFinish: "你想要结束测试吗？",
      _testPageDoYouLeave: "你想要离开测试吗？",
      //TestHistory
      _testHistoryNoHistory: "没有历史记录！",
       //FavoritePage
      _favoritePageNoFavorite: "没有收藏记录！",
      _favoritePageFavorite: "题库收藏",
      //LearningPartPage
      _learningPartPagePart: "部分",
      //AcademyDetailPage
      _academyDetailPageAbout: "关于",
      _academyDetailPageCopied: "地址已复制",
      _academyDetailRegister: "注册",
    },
    malay: {
      //SettingPage
      _settingPageName: "Name",
      _settingPagePhone: "Phone",
      _settingPageLanguage: "Language",
      _settingPageAbout: "About",
      _settingPageLogOut: "Log Out",
      //ProfileMainPage
      _profileMainPageQuiz: "Quiz",
      _profileMainPagePass: "Pass",
      _profileMainPageFail: "Fail",
      _profileMainPageState: "State",
      _profileMainPageTime: "Time",
      _profileMainPageMark: "Mark",
      //Kpp01TestHomePage
      _kpp01TestHomePageKPP01: "KPP01",
      _kpp01TestHomePageQuiz: "Quiz",
      _kpp01TestHomePagePractice: "Practice",
      _kpp01TestHomePageHistory: "History",
      _kpp01TestHomePageFavorite: "Favorite",
      //TestPage
      _testPageQuiz: "Quiz",
      _testPageFinish: "Finish",
      _testPageYes: "Yes",
      _testPageNo: "No",
      _testPageDoYouFinish: "Do you want to finish this quiz ?",
      _testPageDoYouLeave: "Do you want to leave ?",
      //TestHistory
      _testHistoryNoHistory: "No quiz history!",
       //FavoritePage
      _favoritePageNoFavorite: "No favorite question!",
      _favoritePageFavorite: "Favorite",
      //LearningPartPage
      _learningPartPagePart: "Part",
      //AcademyDetailPage
      _academyDetailPageAbout: "About",
      _academyDetailPageCopied: "Location Copied",
      _academyDetailRegister: "Register",
    },
  };

  initialData() {
    changeLanguage(SystemLanguageCode.EN);
  }

  codeString() {
    if (this.systemLanguageCode == SystemLanguageCode.EN) {
      return en;
    } else if (this.systemLanguageCode == SystemLanguageCode.CN) {
      return cn;
    } else if (this.systemLanguageCode == SystemLanguageCode.MALAY) {
      return malay;
    }
  }

  changeLanguage(SystemLanguageCode systemLanguageCode) {
    Map lMap;
    this.systemLanguageCode = systemLanguageCode;

    if (systemLanguageCode == SystemLanguageCode.EN) {
      lMap = language[en];
    } else if (systemLanguageCode == SystemLanguageCode.CN) {
      lMap = language[cn];
    } else if (systemLanguageCode == SystemLanguageCode.MALAY) {
      lMap = language[malay];
    } else {
      lMap = language[en];
    }
    //SettingPage
    settingPageName = lMap[_settingPageName];
    settingPagePhone = lMap[_settingPagePhone];
    settingPageLanguage = lMap[_settingPageLanguage];
    settingPageAbout = lMap[_settingPageAbout];
    settingPageLogOut = lMap[_settingPageLogOut];
    //ProfileMainPage
    profileMainPageQuiz = lMap[_profileMainPageQuiz];
    profileMainPagePass = lMap[_profileMainPagePass];
    profileMainPageFail = lMap[_profileMainPageFail];
    profileMainPageState = lMap[_profileMainPageState];
    profileMainPageTime = lMap[_profileMainPageTime];
    profileMainPageMark = lMap[_profileMainPageMark];
    //Kpp01TestHomePage
    kpp01TestHomePageKPP01 = lMap[_kpp01TestHomePageKPP01];
    kpp01TestHomePageQuiz = lMap[_kpp01TestHomePageQuiz];
    kpp01TestHomePagePractice = lMap[_kpp01TestHomePagePractice];
    kpp01TestHomePageHistory = lMap[_kpp01TestHomePageHistory];
    kpp01TestHomePageFavorite = lMap[_kpp01TestHomePageFavorite];
    //TestPage
    testPageQuiz = lMap[_testPageQuiz];
    testPageFinish = lMap[_testPageFinish];
    testPageYes = lMap[_testPageYes];
    testPageNo = lMap[_testPageNo];
    testPageDoYouFinish = lMap[_testPageDoYouFinish];
    testPageDoYouLeave = lMap[_testPageDoYouLeave];
    //TestHistory
    testHistoryNoHistory = lMap[_testHistoryNoHistory];
    //FavoritePage
    favoritePageNoFavorite = lMap[_favoritePageNoFavorite];
    favoritePageFavorite = lMap[_favoritePageFavorite];
    //LearningPartPage
    learningPartPagePart = lMap[_learningPartPagePart];
    //AcademyDetailPage
    academyDetailPageAbout = lMap[_academyDetailPageAbout];
    academyDetailPageCopied = lMap[_academyDetailPageCopied];
    academyDetailRegister = lMap[_academyDetailRegister];
  }
}
