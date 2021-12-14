import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:maybrowser/Model/tabRootM.dart';
import 'package:maybrowser/State/tabRootS.dart';
import 'package:maybrowser/View/tabV.dart';
import 'package:maybrowser/main.dart';

class TabRootL extends GetxController with StateMixin<TabRootS>{
  TabRootS? tabS;

  @override
  void onInit() {
    printInfo(info: 'onInit');
    this.tabS = TabRootS(tabRootM: TabRootM(tabVList: [], showIndex: 0, tabVMod: []), webShow: 1, url: "https://www.google.com");
    super.onInit();
  }

  @override
  void onReady() {
    printInfo(info: 'onReady');
    Get.offNamed(RN.home);
    super.onReady();
  }

  @override
  void onClose() {
    printInfo(info: 'onClose');

    super.onClose();
  }

  addTabView(String url){
    url == "null" ? url = "https://www.google.com" : url = url;
    this.tabS!.tabRootM.showIndex = this.tabS!.tabRootM.tabVList.length;
    this.tabS!.tabRootM.tabVList.add(TabV(
        key: GlobalKey(),
        tabM: TabM(url: Uri.parse(url),tabIndex: tabS!.tabRootM.tabVMod.length)
    ));
    this.tabS!.tabRootM.tabVMod.add(TabM());

    showWeb();
    update();
  }

  showWeb(){
    this.tabS!.webShow = 0 ;
    update();
  }

  showTabs(){
    this.tabS!.webShow = 1 ;
    update();
  }

  changeShowIndex(int index){
    this.tabS!.tabRootM.showIndex = index;
    update();
  }


  ///
  updateWebMode(TabM tabM){
    tabS!.tabRootM.tabVMod[getShowIndex()] = tabM;
  }

  webScreenShot()async{
    getTabM().screenshot  = await getTabM().webViewController!.takeScreenshot().timeout(Duration(milliseconds: 1500), onTimeout: () => null,);
    update();
  }

  TabM getTabM(){
    update();
    return tabS!.tabRootM.tabVMod[getShowIndex()];
  }

  TabV getTabV(){
    update();
    return tabS!.tabRootM.tabVList[getShowIndex()];
  }

  int getShowIndex(){
    update();
    return tabS!.tabRootM.showIndex;
  }

}