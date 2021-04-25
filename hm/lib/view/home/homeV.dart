
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
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
          SettingV(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
          child: GNav(
            tabBackgroundGradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.lightBlue[100], Colors.cyan],
            ),
            gap: 8,
            tabBorderRadius: 15,
            color: Colors.grey[600],
            activeColor: Colors.white,
            iconSize: 16,
            textStyle: TextStyle(fontSize: 12, color: Colors.white),
            tabBackgroundColor: Colors.grey[800],
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16.5),
            duration: Duration(milliseconds: 800),
            tabs: [
              GButton(icon: Icons.house, text: '主页',),
              GButton(icon: Icons.stacked_bar_chart, text: '统计'),
              GButton(icon: Icons.settings, text: '设置'),
            ],
            onTabChange: (index){
              this.index = index;
              setState(() {});
            },
          ),
        ),
      ),
    );
  }
}