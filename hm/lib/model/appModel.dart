class AppModel{
  AppModel({
    this.appName,
    this.buildNumber,
    this.packageName,
    this.version,
});
  String appName ;
  String packageName ;
  String version ;
  String buildNumber ;

  initialize( String appName , String packageName , String version , String buildNumber  ){
    this.appName = appName;
    this.buildNumber = buildNumber;
    this.packageName = packageName;
    this.version = version;
  }
}