import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hm/logic/houseL.dart';
import 'package:hm/model/houseExpensesM.dart';
import 'package:hm/model/houseM.dart';

class StatisticsCostV extends StatefulWidget{
  @override
  _StatisticsCostVState createState() => _StatisticsCostVState();
}

class _StatisticsCostVState extends State<StatisticsCostV> {

  HouseL houseL = Get.find<HouseL>();
  int yearNow ;
  double bottomAmount = 11;
  List<HouseExpensesM> houseExpensesMList = [];
  Map bottomDataCostMap = Map();
  List<int> yearList = [];
  List bottomDataCost = [];
  double maxNumber;

  List<Color> gradientColors = [
    const Color(0xffba5ee0),
    const Color(0xffe05a5a),
  ];

  String dropdownValueHouse ;
  String dropdownValueDateType ;
  List<String> dropDownDateTypeValueList = [];


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(left: context.width/30,bottom: 0, top: 10),
          child: Text('支出',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
        ),
        Offstage(
          offstage: this.yearList.length == 0,
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_left),
                    onPressed:  yearList.indexWhere((element) => element==yearNow) == 0
                        ? null
                        : (){
                      int index = yearList.indexWhere((element) => element==yearNow);
                      if(index > 0){
                        yearNow = yearList[index-1];
                        calculateData();
                      }
                      setState(() {});
                    },
                  ),
                  Container(
                    child: Text(this.yearNow == null ? '' : this.yearNow.toString()),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_right),
                    onPressed: yearList.indexWhere((element) => element==yearNow) == yearList.length-1
                        ? null
                        : (){
                      int index = yearList.indexWhere((element) => element==yearNow);
                      if(index < yearList.length-1){
                        yearNow = yearList[index+1];
                        calculateData();
                      }
                      setState(() {});
                    },
                  ),
                ],
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: gradientColors[1].withOpacity(0.5),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      margin: EdgeInsets.only(right: 10),
                      child: Text("支出"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        houseL.houseState.housesM.houseList.length != 0 ? dropDownButton() : Container(),
        Container(
          margin: EdgeInsets.only(left: context.width/100, right: context.width/100),
          child: AspectRatio(
            aspectRatio: 1.9,
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(18),
                    ),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 1.0, left: 1.0, top: 5, bottom: 2),
                    child: LineChart(
                      houseL.houseState.housesM.houseList.length != 0 && (dropdownValueDateType != null && dropdownValueHouse != null)
                          ? mainData()
                          : avgData(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Row dropDownButton(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [

        DropdownButton<String>(
          hint: Text("房屋"),
          value: dropdownValueHouse,
          elevation: 16,
          underline: Container(
            height: 0,
            color: Colors.black,
          ),
          style: TextStyle(
              color: Colors.black
          ),
          onChanged: (String newValue) {
            getDataMapList(newValue);
            divideData();
            setState(() {});
          },
          items: houseL.houseState.housesM.houseList.map< DropdownMenuItem<String>>((HouseM value) {
            return DropdownMenuItem<String>(
              value: value.houseName,
              child: Container(
                width: 80,
                //constraints: BoxConstraints(maxWidth: 100),
                child: Text(value.houseName,maxLines: 1,overflow: TextOverflow.ellipsis,),
              ),
            );
          }).toList(),
        ),

        DropdownButton<String>(
          hint: Text("时间"),
          value: dropdownValueDateType,
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
              dropdownValueDateType = newValue;
              newValue == '月' ? this.bottomAmount = 12 : this.bottomAmount = 11;
              calculateData();
            });
          },
          items: this.dropDownDateTypeValueList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }

  getDataMapList(newValue){
    dropdownValueHouse = newValue;
    int houseIndex = houseL.houseState.housesM.houseList.indexWhere((element) => element.houseName == newValue);
    this.houseExpensesMList = houseL.getLineChartAllCostData(houseIndex);
  }

  divideData(){
    this.yearList = [];
    this.yearNow = null;
    this.dropdownValueDateType = null;
    this.dropDownDateTypeValueList = [];
    this.bottomDataCostMap = Map();

    if(this.houseExpensesMList.length > 0){
      for(var expensesM in this.houseExpensesMList){
        /// get years
        getYears(expensesM);

        /// organize data
        organizeData(expensesM);
      }
      this.yearList.sort();
      this.yearNow = this.yearList[this.yearList.length-1];
      this.dropDownDateTypeValueList = ['年', '季', '月',];
    }
  }

  getYears(HouseExpensesM expensesM){
    if(!this.yearList.contains(expensesM.expenseDate.year)){
      this.yearList.add(expensesM.expenseDate.year);
    }
  }

  organizeData(HouseExpensesM expensesM){
    int month = expensesM.expenseDate.month;
    int year = expensesM.expenseDate.year;
    String typeM = expensesM.expense.type;
    double cost = expensesM.expense.cost;
    if(this.bottomDataCostMap[year] != null){
      if(this.bottomDataCostMap[year][month] != null){
        for(int i = 0; i < this.bottomDataCostMap[year][month].length; i++){
          if(this.bottomDataCostMap[year][month][i]['type'] == typeM ){
            this.bottomDataCostMap[year][month][i]['cost'] += cost;
          }else{
            if(i == this.bottomDataCostMap[year][month].length - 1){
              this.bottomDataCostMap[year][month].add({'type': typeM, 'cost': cost});
              break;
            }
          }
        }
      }else{
        this.bottomDataCostMap[year][month] = [{'type': typeM, 'cost': cost}];
      }
    }else{
      this.bottomDataCostMap[year] = {month: [{'type': typeM, 'cost': cost}]};
    }
  }

  String getLineTooltipItemText(LineBarSpot barSpot){
    return '支出: ${this.bottomDataCost[barSpot.spotIndex]}';
  }

  LineChartData mainData() {
    final lineBarData = [
      LineChartBarData(
        //showingIndicators: showIndexes,
        spots: _getBottomFlSpotsData(),
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
    ];

    return LineChartData(
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              return LineTooltipItem(
                getLineTooltipItemText(barSpot),
                TextStyle(
                  fontFamily: 'Jost*',
                  fontSize: 15,
                  color: Colors.white,
                ),
              );
            }).toList();
          },
        ),
      ),
      gridData: FlGridData(show: false,),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitles: (value) => _getBottomTitles(value),
          margin: 10,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          margin: 12,
          interval: (this.maxNumber~/8).toDouble(),
        ),
      ),
      borderData:
      FlBorderData(show: false, border: Border.all(color: const Color(0xff37434d), width: 1)),
      //minX: 0,
      maxX: this.bottomAmount,
      //maxY: 6,
      lineBarsData: lineBarData,
    );
  }


  List<FlSpot> _getBottomFlSpotsData(){
    List<FlSpot> data = [];

    if(this.dropdownValueDateType == '年'){
      data = [
        FlSpot(1, this.bottomDataCost[0]),
        FlSpot(4, this.bottomDataCost[1]),
        FlSpot(7, this.bottomDataCost[2]),
        FlSpot(10, this.bottomDataCost[3]),
      ];
    }else if(this.dropdownValueDateType == '季'){
      data = [
        FlSpot(1, this.bottomDataCost[0]),
        FlSpot(4, this.bottomDataCost[1]),
        FlSpot(7, this.bottomDataCost[2]),
        FlSpot(10, this.bottomDataCost[3]),
      ];
    }else if(this.dropdownValueDateType == '月'){
      data = [
        FlSpot(0, this.bottomDataCost[0]),
        FlSpot(1, this.bottomDataCost[1]),
        FlSpot(2, this.bottomDataCost[2]),
        FlSpot(3, this.bottomDataCost[3]),
        FlSpot(4, this.bottomDataCost[4]),
        FlSpot(5, this.bottomDataCost[5]),
        FlSpot(6, this.bottomDataCost[6]),
        FlSpot(7, this.bottomDataCost[7]),
        FlSpot(8, this.bottomDataCost[8]),
        FlSpot(9, this.bottomDataCost[9]),
        FlSpot(10, this.bottomDataCost[10]),
        FlSpot(11, this.bottomDataCost[11]),
      ];
    }
    return data;
  }

  getMaxNumber(){
    double max2 = 0;
    for(var i in this.bottomDataCost){
      if(i > max2){
        max2 = i;
      }
    }
    this.maxNumber = max2;
  }

  calculateData(){
    if(this.dropdownValueDateType == '年'){
      calculateYearData();
    }else if(this.dropdownValueDateType == '季'){
      calculateSeasonData();
    }else if(this.dropdownValueDateType == '月'){
      calculateMonthData(this.yearNow);
    }
    getMaxNumber();
  }

  calculateYearData(){
    List a = [0.0, 0.0, 0.0, 0.0];
    for(int i = 0; i < 4; i++){
      calculateMonthData(this.yearNow-(3-i));
      for(int j = 0; j < this.bottomDataCost.length; j++){
        a[i] += this.bottomDataCost[j];
      }
    }
    this.bottomDataCost = a;

    ///printInfo(info: 'bottomDataCost ${this.yearNow}: Year: ${this.bottomDataCost}');
  }

  calculateSeasonData(){
    calculateMonthData(this.yearNow);

    List b = [0.0, 0.0, 0.0, 0.0];
    for(int i = 0; i < this.bottomDataCost.length; i++){
      if(i < 3){
        b[0] += this.bottomDataCost[i];
      }else if(i >= 3 && i < 6){
        b[1] += this.bottomDataCost[i];
      }if(i >= 6 && i < 9){
        b[2] += this.bottomDataCost[i];
      }else if(i >= 9 ){
        b[3] += this.bottomDataCost[i];
      }
    }
    this.bottomDataCost = b;
    ///printInfo(info: 'bottomDataCost ${this.yearNow}: Season: ${this.bottomDataCost}');
  }

  calculateMonthData(int year){

    this.bottomDataCost = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,];
    Map yearMap2 = this.bottomDataCostMap[year];
    if(yearMap2 != null){
      yearMap2.forEach((month, allFee) {
        double amount = 0;
        for(var fee in allFee){
          amount += fee['cost'];
        }
        this.bottomDataCost[month-1] = amount;
      });
    }
    ///printInfo(info: 'bottomDataCost $year: Month: ${this.bottomDataCost}');
  }

  _getBottomTitles(double value){
    if(dropdownValueDateType == '年'){
      switch (value.toInt()) {
        case 1:
          return '${this.yearNow-3}';
        case 4:
          return '${this.yearNow-2}';
        case 7:
          return '${this.yearNow-1}';
        case 10:
          return '${this.yearNow}';
      }
    }else if(dropdownValueDateType == '季'){
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
    }else if(dropdownValueDateType == '月'){
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
  }

  LineChartData avgData() {
    return LineChartData(
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) =>
          const TextStyle(color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 16),
          getTitles: (value) => value.toInt() == 5 ? '' : '',
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '';
              case 3:
                return '';
              case 5:
                return '';
            }
            return '';
          },
          reservedSize: 10,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 10,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(),
      ],
    );
  }
}