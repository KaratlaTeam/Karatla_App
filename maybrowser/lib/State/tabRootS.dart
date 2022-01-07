import 'package:maybrowser/Model/tabRootM.dart';

class TabRootS{
  TabRootS({
    required this.tabRootM,
    required this.rootIndex,
    required this.url,
    required this.history,
    required this.collect,
    required this.incognito,
    required this.temperature,
});
  TabRootM tabRootM;
  int rootIndex;
  List url;
  List history;
  List collect;
  bool incognito;
  String temperature;

}