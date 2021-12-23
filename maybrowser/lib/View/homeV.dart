import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maybrowser/Logic/tabRootL.dart';
import 'package:maybrowser/Model/tabRootM.dart';
import 'package:maybrowser/View/tabV.dart';
import 'package:maybrowser/main.dart';

class HomeV extends StatefulWidget{
  HomeV({Key? key}) : super(key: key);
  @override
  _HomeVState createState() => _HomeVState();
}
class _HomeVState extends State<HomeV>{

  String engine = "Google";
  String engineLink = "https://www.google.com/search?q=";
  //List<TabM>? tabMList = Get.find<TabRootL>().tabS!.tabRootM.tabMList;
  String onChangeText = '';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xffb6c0a4),
      body: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 220,width: 130,
                alignment: Alignment.bottomRight,
                color: Color(0xff7f886e),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: Get.mediaQuery.size.height-220,width: Get.mediaQuery.size.width,
                alignment: Alignment.bottomRight,
                color: Color(0xff6a7d6b),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: Get.mediaQuery.padding.top),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                      child: Text(engine,style: GoogleFonts.caveat(textStyle: TextStyle(fontSize: 60,color: Color(
                          0xff5b604f))),),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                      child: IconButton(icon: Icon(Icons.download_rounded,size: 50,color: Colors.white,),onPressed: (){Get.toNamed(RN.download);},),
                    ),
                  ],
                ),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Container(
                    height: 200,width: 350,
                    //padding: EdgeInsets.symmetric(horizontal: 10,),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: InkWell(
                                onTap: (){},
                                child: Image.asset("assets/images/incognito.png",height: 48,),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 20),
                              child: IconButton(
                                  onPressed: (){
                                    Get.find<TabRootL>().showTabs();
                                  },
                                  icon: Icon(Icons.content_copy,size: 30,color: Colors.black,),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20,top: 10),
                          child: TextField(
                            decoration: InputDecoration(
                              //prefixText: "https://",
                              border: InputBorder.none,
                              icon: IconButton(
                                icon: Icon(Icons.search_outlined,size: 50,),
                                onPressed: (){
                                  String url = this.engineLink+this.onChangeText;
                                  print(url);
                                  Get.find<TabRootL>().addTabView(url);
                                  Get.find<TabRootL>().showWeb();
                                },
                              ),
                            ),
                            onChanged: (String text){
                              setState(() {
                                this.onChangeText = text;
                              });
                            },
                            onSubmitted: (String text){
                              String url = this.engineLink+text;
                              print(url);

                              Get.find<TabRootL>().addTabView(url);
                              Get.toNamed(RN.tabRoot);
                            },
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xfffcda86),
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))
                          ),
                          height: 74,
                          margin: EdgeInsets.only(top: 20,),
                          //alignment: Alignment.bottomCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            Flexible(
                              fit: FlexFit.tight,
                              flex: 1,
                              child: Container(
                                margin: EdgeInsets.only(left: 20,),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Text("30°C",style: GoogleFonts.firaSansCondensed(textStyle: TextStyle(fontSize: 30,color: Color(0xff5b604f))),),
                                    ),
                                    Container(
                                      child: Text("Malaysia",style: GoogleFonts.firaSansCondensed(textStyle: TextStyle(fontSize: 20,color: Color(0xff5b604f))),),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                              Flexible(
                                fit: FlexFit.tight,
                                flex: 1,
                                child: Container(),
                              ),
                              Flexible(
                                fit: FlexFit.tight,
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(right: 20),
                                          child: Text("July",style: GoogleFonts.firaSansCondensed(textStyle: TextStyle(fontSize: 20,color: Color(0xff5b604f))),),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(right: 20),
                                          child: Text("05",style: GoogleFonts.firaSansCondensed(textStyle: TextStyle(fontSize: 20,color: Color(0xff5b604f))),),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(right: 20),
                                      child: Text("Sat",style: GoogleFonts.firaSansCondensed(textStyle: TextStyle(fontSize: 20,color: Color(0xff5b604f))),),
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Search Engine",style: GoogleFonts.firaSansCondensed(textStyle: TextStyle(fontSize: 30,color: Colors.white)),),
                            IconButton(
                                onPressed: (){
                                  Get.toNamed(RN.setting);
                                },
                                icon: Icon(Icons.settings,color: Colors.white,),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 250,
                        margin: EdgeInsets.only(top: 40,bottom: 70),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            GestureDetector(
                              onTap: (){
                                this.engine = "Google";
                                this.engineLink = "https://www.google.com/search?q=";
                                setState(() {});
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                margin: EdgeInsets.only(left: 10,right: 10),
                                child: Container(
                                  width: 120,
                                  child:Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text("Google",style: GoogleFonts.firaSansCondensed(textStyle: TextStyle(fontSize: 20,color: Colors.black)),),
                                      Image.asset("assets/images/google.png",width: 50,),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                this.engine = "Baidu";
                                this.engineLink = "https://www.baidu.com/s?wd=";
                                setState(() {});
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                margin: EdgeInsets.only(left: 10,right: 10),
                                child: Container(
                                  width: 120,
                                  child:Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text("Baidu",style: GoogleFonts.firaSansCondensed(textStyle: TextStyle(fontSize: 20,color: Colors.black)),),
                                      Image.asset("assets/images/baidu.jpg",width: 50,),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                this.engine = "Bing";
                                this.engineLink = "https://www.bing.com/search?q=";
                                setState(() {});
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                margin: EdgeInsets.only(left: 10,right: 10),
                                child: Container(
                                  width: 120,
                                  child:Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text("Bing",style: GoogleFonts.firaSansCondensed(textStyle: TextStyle(fontSize: 20,color: Colors.black)),),
                                      Image.asset("assets/images/bing.png",width: 70,),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                this.engine = "YaHoo";
                                this.engineLink = "https://search.yahoo.com/search?p=";
                                setState(() {});
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                margin: EdgeInsets.only(left: 10,right: 10),
                                child: Container(
                                  width: 120,
                                  child:Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text("YaHoo",style: GoogleFonts.firaSansCondensed(textStyle: TextStyle(fontSize: 20,color: Colors.black)),),
                                      Image.asset("assets/images/yaHu.jpg",width: 40,),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),

        ],
      ),
    );
  }
}