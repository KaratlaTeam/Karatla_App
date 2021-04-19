import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hm/logic/houseL.dart';
import 'package:hm/model/houseM.dart';

class StatisticsV extends StatefulWidget{
  @override
  _StatisticsVState createState() => _StatisticsVState();
}

class _StatisticsVState extends State<StatisticsV> {

  HouseL houseL = Get.find<HouseL>();

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  List<Color> gradientColors2 = [
    const Color(0xffef86ef),
  ];

  String dropdownValue1 = '年';
  String dropdownValue2 ;
  String dropdownValue3 = '房租';
  String dropdownValue4 = '应收';

  @override
  Widget build(BuildContext context) {
    return houseL.status.isLoading
        ? Scaffold(body: Center(child: CircularProgressIndicator()),)
        : Scaffold(
      body: Container(
        child: ListView(
          padding: EdgeInsets.only(top: context.mediaQuery.padding.top,left: 10, right: 10),
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: context.width/30,bottom: 10, top: 10),
              child: Text('收入',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
            ),
            houseL.houseState.housesM.houseList.length != 0 ? dropDownButton() : Container(),
            Container(
              margin: EdgeInsets.only(left: context.width/100, right: context.width/100),
              child: AspectRatio(
                aspectRatio: 1.7,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(18),
                    ),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 18.0, left: 12.0, top: 24, bottom: 12),
                    child: LineChart(
                      houseL.houseState.housesM.houseList.length != 0 ? mainData() : avgData(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row dropDownButton(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        DropdownButton<String>(
          value: dropdownValue1,
          elevation: 16,
          underline: Container(
            height: 0,
            color: Colors.black,
          ),
          style: TextStyle(
              color: Colors.black
          ),
          onChanged: (String newValue) {
            setState(() {
              dropdownValue1 = newValue;
            });
          },
          items: <String>['年', '季', '月',].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        DropdownButton<String>(
          value: dropdownValue2??houseL.houseState.housesM.houseList.first.houseName,
          elevation: 16,
          underline: Container(
            height: 0,
            color: Colors.black,
          ),
          style: TextStyle(
              color: Colors.black
          ),
          onChanged: (String newValue) {
            setState(() {
              dropdownValue2 = newValue;
            });
          },
          items: houseL.houseState.housesM.houseList.map<DropdownMenuItem<String>>((HouseM value) {
            return DropdownMenuItem<String>(
              value: value.houseName,
              child: Text(value.houseName),
            );
          }).toList(),
        ),
        DropdownButton<String>(
          value: dropdownValue3,
          elevation: 16,
          underline: Container(
            height: 0,
            color: Colors.black,
          ),
          style: TextStyle(
              color: Colors.black
          ),
          onChanged: (String newValue) {
            setState(() {
              dropdownValue3 = newValue;
            });
          },
          items: <String>['房租', '水', '电', '垃圾'].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        DropdownButton<String>(
          value: dropdownValue4,
          elevation: 16,
          underline: Container(
            height: 0,
            color: Colors.black,
          ),
          style: TextStyle(
              color: Colors.black
          ),
          onChanged: (String newValue) {
            setState(() {
              dropdownValue4 = newValue;
            });
          },
          items: <String>['应收', '实收', ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.grey,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) =>
          const TextStyle(color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 16),
          getTitles: (value) {
            if(dropdownValue1 == '年'){
              switch (value.toInt()) {
                case 1:
                  return '2018';
                case 4:
                  return '2019';
                case 7:
                  return '2020';
                case 10:
                  return '2021';
              }
            }else if(dropdownValue1 == '季'){
              switch (value.toInt()) {
                case 1:
                  return '季度1';
                case 4:
                  return '季度2';
                case 7:
                  return '季度3';
                case 10:
                  return '季度4';
              }
            }else if(dropdownValue1 == '月'){
              switch (value.toInt()) {
                case 0:
                  return '1';
                case 1:
                  return '2';
                case 2:
                  return '3';
                case 3:
                  return '4';
                case 4:
                  return '5';
                case 5:
                  return '6';
                case 6:
                  return '7';
                case 7:
                  return '8';
                case 8:
                  return '9';
                case 9:
                  return '10';
                case 10:
                  return '11';
                case 11:
                  return '12';
              }
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '10k';
              case 3:
                return '30k';
              case 5:
                return '50k';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData:
      FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(1, 5),
            FlSpot(3, 4),
            FlSpot(5, 1),
            FlSpot(7, 5),
          ],
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
        LineChartBarData(
          spots: [
            FlSpot(1, 2),
            FlSpot(3, 5),
            FlSpot(5, 3.1),
            FlSpot(7, 3),
          ],
          isCurved: true,
          colors: gradientColors2,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: gradientColors2.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) =>
          const TextStyle(color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'MAR';
              case 5:
                return 'JUN';
              case 8:
                return 'SEP';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '10k';
              case 3:
                return '30k';
              case 5:
                return '50k';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData:
      FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          colors: [
            ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2),
            ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2),
          ],
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(show: true, colors: [
            ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2).withOpacity(0.1),
            ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2).withOpacity(0.1),
          ]),
        ),
      ],
    );
  }

}