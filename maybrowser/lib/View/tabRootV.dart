import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maybrowser/Logic/tabRootL.dart';
import 'package:maybrowser/Model/tabRootM.dart';
import 'package:maybrowser/View/homeV.dart';
import 'package:maybrowser/View/tabV.dart';
import 'package:maybrowser/main.dart';

class TabRootV extends StatefulWidget{
  TabRootV({ Key? key}) : super(key: key);
  //final GlobalKey<_TabRootVState> key;

  @override
  _TabRootVState createState() => _TabRootVState();
}
class _TabRootVState extends State<TabRootV> with SingleTickerProviderStateMixin{
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  )..repeat();

  double move = 0;
  double moveTop = 0;
  int moveLeft = 0;
  bool trans = true;
  Color cardColor = Color(0xffb6c0a4);

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ///TabV(key: GlobalKey(), tabM: TabM(url: Uri.parse("https://www.google.com"),tabIndex: 0,));
      GetBuilder<TabRootL>(
        builder: (_){
          TabRootM tabRootM = _.tabS!.tabRootM;
          List<TabV> tabVList = _.tabS!.tabRootM.tabVList;
          return Scaffold(
            backgroundColor: Color(0xffb6c0a4),
            appBar: _showAppBar(tabRootM, tabVList, _),
            body: Container(
              child: IndexedStack(
                index: _.tabS!.rootIndex,
                children: [
                  _tabListV(tabRootM, tabVList),
                  _rootV(tabRootM, _),
                  HomeV(key: widget.key,),
                ],
              ),
            ),
          );
        },
    );
  }

  _backPosition(){
    //moveLeft = 0;
    //print(moveTop);
    //moveTop = 0;
  }


  _showAppBar(TabRootM tabRootM, List<TabV> tabVList, TabRootL _){
    return _.tabS?.rootIndex == 2
        ? null
        : (_.tabS?.rootIndex == 1
        ? AppBar(
      leading: IconButton(icon: Icon(Icons.home),onPressed: (){
        _.showHome();
        _backPosition();
      },),
      actions: [
        IconButton(icon: Icon(Icons.add),onPressed: (){
          _.addTabView("null");
          _backPosition();
        },),
      ],
    )
        : AppBar(
      title: Text(_.getWebTitle()),
      leading: IconButton(
        icon: Icon(Icons.home),
        onPressed: (){
          Get.find<TabRootL>().webScreenShot();
          Get.find<TabRootL>().showHome();
        },
      ),
      actions: [
        IconButton(
          onPressed: (){
            //Get.toNamed(RN.download);
            Get.find<TabRootL>().webScreenShot();
            Get.find<TabRootL>().showTabs();
          },
          icon: Icon(Icons.content_copy),
        ),
      ],
    ));
  }

  _tabListV(TabRootM tabRootM, List<TabV> tabVList){
    return tabVList.length == 0
        ? Container()
        :IndexedStack(
      index: tabRootM.showIndex,
      children: tabVList.map((e) {
        var isCurrentTab = e.tabM.tabIndex == tabRootM.showIndex;
        if(isCurrentTab){
          Future.delayed(Duration(milliseconds: 100),(){
            ///TODO Need to check pause, resume
            e.key.currentState?.resume();
          });
        }else{
          e.key.currentState?.pause();
        }
        return e;
      }).toList(),
    );
  }

  _rootV(TabRootM tabRootM, TabRootL _){
    return Scaffold(
      backgroundColor: Colors.grey,
      ///appBar:
      ///AppBar(
      ///  leading: IconButton(icon: Icon(Icons.home),onPressed: (){
      ///    _.showHome();
      ///  },),
      ///  actions: [
      ///    IconButton(icon: Icon(Icons.add),onPressed: (){
      ///      _.addTabView("null");
      ///    },),
      ///  ],
      ///),
      body: Stack(
        children: _rootVBody(tabRootM, _),
      ),
    );
  }

  List<Widget> _rootVBody(TabRootM tabRootM, TabRootL tabRootL){
    List<Widget> body = [];

    if(tabRootM.tabVList.length != 0){
      for(int i = 0; i < tabRootM.tabVList.length; i++){
        double top = 160 * i.toDouble();
        body.add(_rootVBodyCard(top, tabRootM.showIndex == i ? cardColor : Colors.white, i, tabRootL),);
      }
    }

    var tap = GestureDetector(
      onVerticalDragUpdate: (detail){
        move = detail.delta.direction*detail.delta.distance;
        moveTop += move;
        setState(() {});
      },

      onHorizontalDragUpdate: (detail){
        moveLeft = (Get.width/2 - detail.localPosition.dx.round()).round();
        if(moveLeft.abs() > Get.width/3){
          cardColor = Colors.grey;
        }else{
          cardColor = Color(0xffb6c0a4);
        }
        setState(() {});
      },
      onHorizontalDragEnd: (detail){
        int index = tabRootL.getShowIndex();
        if(cardColor == Colors.grey){
          tabRootL.removeTabView();
          tabRootL.changeShowIndex(index-1);
        }
        moveLeft = 0;
        cardColor = Color(0xffb6c0a4);
        setState(() {});
      },
    );
    body.add(tap);
    return body;
  }

  _rootVBodyCard(double top, Color color, int showIndex, TabRootL tabRootL){
    var value = tabRootL.tabS!.tabRootM.tabVMod[showIndex].screenshot;
    var title = tabRootL.tabS!.tabRootM.tabVMod[showIndex].title;
    return AnimatedPositioned(
      curve: Curves.easeOutCubic,
      duration: const Duration(milliseconds: 1500),
      top: top+moveTop,
      width: 300,
      left: tabRootL.tabS?.tabRootM.showIndex == showIndex ? (Get.width/2-300/2)-moveLeft : (Get.width/2-300/2),
      height: 550,
      child: Transform(
        transform: Matrix4.identity()..setEntry(3, 2, 0.001)..rotateX(0.7),
        alignment: Alignment.center,
        child: InkWell(
          onTap: () {
           /// setState(() {
           ///   _controller.animateTo(0);
           /// });
            tabRootL.changeShowIndex(showIndex);
            tabRootL.showWeb();
            _backPosition();
          },
          child: Card(
            color: color,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 20,
            child: Container(
              height: 600,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 30,vertical: 5),
                    child: Text("${title??""}",style: TextStyle(fontSize: 10),maxLines: 1,),
                  ),

                  value != null
                      ? Container(margin: EdgeInsets.all(5), child: Image.memory(value, height: 500,filterQuality: FilterQuality.none,),)
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}