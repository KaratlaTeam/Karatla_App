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

  static const String countryReportName = 'CountryReport';
  static const String countryReportUrl = 'https://www.countryreports.org';
  static const String countryReportSearch = '/search.htm?q=';
  get countryN => countryReportName;
  get countryU => countryReportUrl;
  get countryS => countryReportUrl+countryReportSearch;

  static const String eolName = 'Eol';
  static const String eolUrl = 'https://eol.org';
  static const String eolSearch = '/search?utf8=✓&q=';
  get eolN => eolName;
  get eolU => eolUrl;
  get eolS => eolUrl+eolSearch;

  static const String dictionaryName = 'Dictionary';
  static const String dictionaryUrl = 'https://dictionary.cambridge.org/dictionary/english';
  static const String dictionarySearch = '/';
  get dictionaryN => dictionaryName;
  get dictionaryU => dictionaryUrl;
  get dictionaryS => dictionaryUrl+dictionarySearch;
}