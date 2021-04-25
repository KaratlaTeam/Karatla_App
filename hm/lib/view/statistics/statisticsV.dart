import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hm/logic/houseL.dart';
import 'package:hm/view/statistics/statisticsCostV.dart';
import 'package:hm/view/statistics/statisticsIncomeV.dart';

class StatisticsV extends StatefulWidget{
  @override
  _StatisticsVState createState() => _StatisticsVState();
}

class _StatisticsVState extends State<StatisticsV> {

  HouseL houseL = Get.find<HouseL>();

  @override
  Widget build(BuildContext context) {
    return houseL.status.isLoading
        ? Scaffold(body: Center(child: CircularProgressIndicator()),)
        : Scaffold(
      body: Container(
        child: ListView(
          padding: EdgeInsets.only(
              top: context.mediaQuery.padding.top*1.5, left: 10, right: 10),
          children: <Widget>[
            StatisticsIncomeV(),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
            ),
            StatisticsCostV(),
          ],
        ),
      ),
    );
  }
}

