import 'package:maybrowser/Model/tabRootM.dart';

class TabRootS{
  TabRootS({
    required this.tabRootM,
    required this.rootIndex,
    required this.url,
    required this.history,
    required this.collect,
});
  TabRootM tabRootM;
  int rootIndex;
  List url;
  List history;
  List collect;

}