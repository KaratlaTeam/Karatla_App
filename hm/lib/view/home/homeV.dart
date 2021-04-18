import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:hm/view/customer/customerPage.dart';
import 'package:hm/view/house/houseV.dart';
import 'package:hm/view/setting/settingV.dart';
import 'package:hm/view/statistics/statisticsV.dart';


class HomeV extends StatefulWidget {
  @override
  _HomeVState createState() => _HomeVState();
}

class _HomeVState extends State<HomeV>{

  int index = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: IndexedStack(
        index: this.index,
        children: [
          HouseV(),
          StatisticsV(),
          CustomerPage(),
          SettingV(),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.blue,
        height: 50,
        items: [
          Icon(Icons.house),
          Icon(Icons.stacked_bar_chart),
          Icon(Icons.search),
          Icon(Icons.settings),
        ],
        onTap: (index){
          this.index = index;
          setState(() {});
        },
      ),
    );
  }
}