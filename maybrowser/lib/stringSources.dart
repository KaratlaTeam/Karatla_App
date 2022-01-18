enum SingleChoice{File,Picture,Video,Music}

class SS{

  static const String googleName = 'Google';
  static const String googleUrl = 'https://www.google.com';
  static const String googleSearch = '/search?q=';
  get googleN => googleName;
  get googleU => googleUrl;
  get googleS => googleUrl+googleSearch;

  static const String baiduName = 'Baidu';
  static const String baiduUrl = 'https://www.baidu.com';
  static const String baiduSearch = '/s?wd=';
  get baiN => baiduName;
  get baiU => baiduUrl;
  get baiS => baiduUrl+baiduSearch;

  static const String bingName = 'Bing';
  static const String bingUrl = 'https://www.bing.com';
  static const String bingSearch = '/search?q=';
  get bingN => bingName;
  get bingU => bingUrl;
  get bingS => bingUrl+bingSearch;

  static const String yaHooName = 'YaHoo';
  static const String yaHooUrl = 'https://www.yahoo.com';
  static const String yaHooSearch = '/search?p=';
  get yaN => yaHooName;
  get yaU => yaHooUrl;
  get yaS => yaHooUrl+yaHooSearch;

  static const String wikipediaName = 'Wikipedia';
  static const String wikipediaUrl = 'https://en.wikipedia.org';
  static const String wikipediaSearch = '/wiki/';
  get wikiN => wikipediaName;
  get wikiU => wikipediaUrl;
  get wikiS => wikipediaUrl+wikipediaSearch;
}