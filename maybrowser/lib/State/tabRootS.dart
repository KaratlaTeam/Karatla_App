import 'package:maybrowser/Model/tabRootM.dart';
import 'package:maybrowser/Model/userM.dart';

class TabRootS{
  TabRootS({
    required this.tabRootM,
    required this.rootIndex,
    required this.url,
});
  TabRootM tabRootM;
  int rootIndex;
  String url;

}