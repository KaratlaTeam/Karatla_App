import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hm/logic/houseL.dart';
import 'package:hm/model/houseM.dart';

class StatisticsIncomeV extends StatefulWidget{
  @override
  _StatisticsIncomeVState createState() => _StatisticsIncomeVState();
}

class _StatisticsIncomeVState extends State<StatisticsIncomeV> {

  HouseL houseL = Get.find<HouseL>();
  int yearNow ;
  double bottomAmount = 11;
  List<String> rentalType = [];
  List<Map> feeDataMapList = [];
  List<int> yearList = [];
  List bottomDataPayed = [];
  List bottomDataShouldPay = [];
  Map shouldPayMap = Map();
  Map payedMap = Map();

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  List<Color> gradientColors2 = [
    const Color(0xffecd0de),
    const Color(0xffe7c1bf),
  ];

  String dropdownValueHouse ;
  String dropdownValueDateType ;
  String dropdownValueFeeType ;
  List<String> dropDownDateTypeValueList = [];


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(left: context.width/30,bottom: 0, top: 10),
          child: Text('收入',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
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
                  ///IconButton(icon: Icon(Icons.refresh), onPressed: (){
                  ///  getDataMapList(this.dropdownValueHouse);
                  ///  divideFeeTypeData();
                  ///  calculateData();
                  ///  setState(() {});
                  ///}),
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
                      child: Text("实收"),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: gradientColors2[1].withOpacity(0.5),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      margin: EdgeInsets.only(left: 5,right: 10),
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      child: Text("应收"),
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
            aspectRatio: 1.7,
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
                    padding: const EdgeInsets.only(right: 20.0, left: 1.0, top: 20, bottom: 2),
                    child: LineChart(
                      houseL.houseState.housesM.houseList.length != 0 && (dropdownValueDateType != null && dropdownValueHouse != null && dropdownValueFeeType != null)
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
            divideFeeTypeData();
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
        DropdownButton<String>(
          hint: Text("类型"),
          value: dropdownValueFeeType,
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
              dropdownValueFeeType = newValue;
              calculateData();
            });
          },
          items: this.rentalType.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }
  
  getDataMapList(String newValue){
    dropdownValueHouse = newValue;
    int houseIndex = houseL.houseState.housesM.houseList.indexWhere((element) => element.houseName == newValue);
    this.feeDataMapList = houseL.getLineChartFeeDataMap(houseIndex);
  }

  divideFeeTypeData(){
    this.dropdownValueFeeType = null;
    this.rentalType = [];
    this.yearList = [];
    this.yearNow = null;
    this.dropdownValueDateType = null;
    this.shouldPayMap = Map();
    this.dropDownDateTypeValueList = [];
    this.payedMap = Map();

    if(this.feeDataMapList.length > 0){
      for(var feeDataMap in this.feeDataMapList){
        /// get date
        getYears(feeDataMap);

        /// get type
        getTypes(feeDataMap);

        /// get should Data amount
        getShouldPayData(feeDataMap);

        /// get Payed data
        getPayedData(feeDataMap);
      }
      this.yearList.sort();
      this.yearNow = this.yearList[this.yearList.length-1];
      this.dropDownDateTypeValueList = ['年', '季', '月',];
      ///printInfo(info: shouldPayMap.toString());
      ///printInfo(info: payedMap.toString());
    }
  }

  getPayedData(var feeDataMap){
    if(feeDataMap['payedTime'] != null){
      int yearP = feeDataMap['payedTime']['year'];
      int monthP = feeDataMap['payedTime']['month'];
      List<Map> typeP = feeDataMap['feeM'];
      ///print(yearP);
      if(payedMap[yearP] != null){
        if(payedMap[yearP][monthP] != null){
          for(int i = 0; i < typeP.length; i++){
            //int payedLength = payedMap[yearP][monthP].length;
            for(int a = 0; a < payedMap[yearP][monthP].length; a++){
              ///print('i = $i --- ${typeP[i]['type']}');
              ///print('a = $a --- ${payedMap[yearP][monthP][a]['type']}');
              if(payedMap[yearP][monthP][a]['type'] == typeP[i]['type']){
                ///print(1);
                ///print('${typeP[i]['payedFee']}');
                payedMap[yearP][monthP][a]['payedFee'] += typeP[i]['payedFee'];
                break;
              }else if(a == payedMap[yearP][monthP].length-1){
                ///print(2);
                ///print('${typeP[i]['payedFee']}');
                Map m = Map();
                m['type'] = typeP[i]['type'];
                m['payedFee'] = typeP[i]['payedFee'];
                payedMap[yearP][monthP].add(m);
                break;
              }
            }
            ///print("--");
          }
        }else{
          List p = [];
          ///print('no month');
          for(var a in feeDataMap['feeM']){
            ///print('${a['type']} -- ${a['payedFee']} ');
            Map m = Map();
            m['type'] = a['type'];
            m['payedFee'] = a['payedFee'];
            p.add(m);
          }
          payedMap[yearP][monthP] = p;
        }
      }else{
        List p = [];
        ///print('no year');
        for(var a in feeDataMap['feeM']){
          ///print('${a['type']} -- ${a['payedFee']} ');
          Map m = Map();
          m['type'] = a['type'];
          m['payedFee'] = a['payedFee'];
          p.add(m);
        }
        payedMap[yearP] = {
          monthP: p
        };
      }
    }

  }

  getShouldPayData(var feeDataMap){
    int yearP = feeDataMap['shouldPayTime']['year'];
    int monthP = feeDataMap['shouldPayTime']['month'];
    List<Map> typeP = feeDataMap['feeM'];
    ///print(yearP);
    if(shouldPayMap[yearP] != null){
      if(shouldPayMap[yearP][monthP] != null){
        for(int i = 0; i < typeP.length; i++){
          //int shouldLength = shouldPayMap[yearP][monthP].length;
          for(int a = 0; a < shouldPayMap[yearP][monthP].length; a++){
            ///print('i = $i --- ${typeP[i]['type']}');
            ///print('a = $a --- ${shouldPayMap[yearP][monthP][a]['type']}');
            if(shouldPayMap[yearP][monthP][a]['type'] == typeP[i]['type']){
              ///print(1);
              ///print('${typeP[i]['cost']}-${typeP[i]['amount']}');
              shouldPayMap[yearP][monthP][a]['cost'] += typeP[i]['cost']*typeP[i]['amount'];
              break;
            }else if(a == shouldPayMap[yearP][monthP].length-1){
              ///print(2);
              ///print('${typeP[i]['cost']}-${typeP[i]['amount']}');
              Map m = Map();
              m['type'] = typeP[i]['type'];
              m['cost'] = typeP[i]['cost']*typeP[i]['amount'];
              shouldPayMap[yearP][monthP].add(m);
              break;
            }
          }
          ///print("--");
        }
      }else{
        List p = [];
        ///print('no month');
        for(var a in feeDataMap['feeM']){
          ///print('${a['type']} -- ${a['cost']} -- ${a['amount']}');
          Map m = Map();
          m['type'] = a['type'];
          m['cost'] = a['cost']*a['amount'];
          p.add(m);
        }
        shouldPayMap[yearP][monthP] = p;
      }
    }else{
      List p = [];
      ///print('no year');
      for(var a in feeDataMap['feeM']){
        ///print('${a['type']} -- ${a['cost']} -- ${a['amount']}');
        Map m = Map();
        m['type'] = a['type'];
        m['cost'] = a['cost']*a['amount'];
        p.add(m);
      }
      shouldPayMap[yearP] = {
        monthP: p
      };
    }
  }

  getYears(var feeDataMap){
    if(feeDataMap['payedTime'] != null && !this.yearList.contains(feeDataMap['payedTime']['year'])){
      this.yearList.add(feeDataMap['payedTime']['year']);
    }
    if(feeDataMap['shouldPayTime'] != null && !this.yearList.contains(feeDataMap['shouldPayTime']['year'])){
      this.yearList.add(feeDataMap['shouldPayTime']['year']);
    }
  }

  getTypes(var feeDataMap){
    if(!this.rentalType.contains('全部')){
      this.rentalType.add('全部');
    }
    for(var a in feeDataMap['feeM']){
      if(!this.rentalType.contains(a['type'])){
        this.rentalType.add(a['type']);
      }
    }
  }

  String getLineTooltipItemText(LineBarSpot barSpot){
    if(barSpot.barIndex == 0){
      return '实: ${this.bottomDataPayed[barSpot.spotIndex]}';
    }else if(barSpot.barIndex == 1){
      return '应: ${this.bottomDataShouldPay[barSpot.spotIndex]}';
    }
    return '';
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
      LineChartBarData(
        //showingIndicators: showIndexes,
        spots: _getBottomFlSpotsData2(),
        isCurved: true,
        colors: gradientColors2,
        barWidth: 5,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: true,
        ),
        belowBarData: BarAreaData(
          show: true,
          colors: gradientColors2.map((color) => color.withOpacity(0.2)).toList(),
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
          interval: this.getInterval(),
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
        FlSpot(1, this.bottomDataPayed[0]),
        FlSpot(4, this.bottomDataPayed[1]),
        FlSpot(7, this.bottomDataPayed[2]),
        FlSpot(10, this.bottomDataPayed[3]),
      ];
    }else if(this.dropdownValueDateType == '季'){
      data = [
        FlSpot(1, this.bottomDataPayed[0]),
        FlSpot(4, this.bottomDataPayed[1]),
        FlSpot(7, this.bottomDataPayed[2]),
        FlSpot(10, this.bottomDataPayed[3]),
      ];
    }else if(this.dropdownValueDateType == '月'){
      data = [
        FlSpot(0, this.bottomDataPayed[0]),
        FlSpot(1, this.bottomDataPayed[1]),
        FlSpot(2, this.bottomDataPayed[2]),
        FlSpot(3, this.bottomDataPayed[3]),
        FlSpot(4, this.bottomDataPayed[4]),
        FlSpot(5, this.bottomDataPayed[5]),
        FlSpot(6, this.bottomDataPayed[6]),
        FlSpot(7, this.bottomDataPayed[7]),
        FlSpot(8, this.bottomDataPayed[8]),
        FlSpot(9, this.bottomDataPayed[9]),
        FlSpot(10, this.bottomDataPayed[10]),
        FlSpot(11, this.bottomDataPayed[11]),
      ];
    }
    return data;
  }

  List<FlSpot> _getBottomFlSpotsData2(){
    List<FlSpot> data = [];

    if(this.dropdownValueDateType == '年'){
      data = [
        FlSpot(1, this.bottomDataShouldPay[0]),
        FlSpot(4, this.bottomDataShouldPay[1]),
        FlSpot(7, this.bottomDataShouldPay[2]),
        FlSpot(10, this.bottomDataShouldPay[3]),
      ];
    }else if(this.dropdownValueDateType == '季'){
      data = [
        FlSpot(1, this.bottomDataShouldPay[0]),
        FlSpot(4, this.bottomDataShouldPay[1]),
        FlSpot(7, this.bottomDataShouldPay[2]),
        FlSpot(10, this.bottomDataShouldPay[3]),
      ];
    }else if(this.dropdownValueDateType == '月'){
      data = [
        FlSpot(0, this.bottomDataShouldPay[0]),
        FlSpot(1, this.bottomDataShouldPay[1]),
        FlSpot(2, this.bottomDataShouldPay[2]),
        FlSpot(3, this.bottomDataShouldPay[3]),
        FlSpot(4, this.bottomDataShouldPay[4]),
        FlSpot(5, this.bottomDataShouldPay[5]),
        FlSpot(6, this.bottomDataShouldPay[6]),
        FlSpot(7, this.bottomDataShouldPay[7]),
        FlSpot(8, this.bottomDataShouldPay[8]),
        FlSpot(9, this.bottomDataShouldPay[9]),
        FlSpot(10, this.bottomDataShouldPay[10]),
        FlSpot(11, this.bottomDataShouldPay[11]),
      ];
    }
    return data;
  }

  getInterval(){
    double max1 = 0;
    double max2 = 0;
    double max = 0;
    for(var i in this.bottomDataShouldPay){
      if(i > max1){
        max1 = i;
      }
    }
    for(var i in this.bottomDataPayed){
      if(i > max2){
        max2 = i;
      }
    }
    if(max1 > max2){
      max = max1;
    }else{
      max = max2;
    }
    if(max == 0 || max~/8 == 0){
      return null;
    }else {
      return (max~/8).toDouble();
    }
  }

  calculateData(){
    if(this.dropdownValueDateType == '年'){
      calculateYearData();
    }else if(this.dropdownValueDateType == '季'){
      calculateSeasonData();
    }else if(this.dropdownValueDateType == '月'){
      calculateMonthData(this.yearNow);
    }
    getInterval();
  }

  calculateYearData(){
    List a = [0.0, 0.0, 0.0, 0.0];
    List b = [0.0, 0.0, 0.0, 0.0];
    for(int i = 0; i < 4; i++){
      calculateMonthData(this.yearNow-(3-i));
      for(int j = 0; j < this.bottomDataShouldPay.length; j++){
        a[i] += this.bottomDataShouldPay[j];
      }
      for(int k = 0; k < this.bottomDataPayed.length; k++){
        b[i] += this.bottomDataPayed[k];
      }
    }
    this.bottomDataShouldPay = a;
    this.bottomDataPayed = b;

    ///printInfo(info: 'bottomDataShouldPay ${this.yearNow}: Year: ${this.bottomDataShouldPay}');
    ///printInfo(info: 'bottomDataPayed ${this.yearNow}: Year: ${this.bottomDataPayed}');
  }

  calculateSeasonData(){
    calculateMonthData(this.yearNow);

    List a = [0.0, 0.0, 0.0, 0.0];
    for(int i = 0; i < this.bottomDataShouldPay.length; i++){
      if(i < 3){
        a[0] += this.bottomDataShouldPay[i];
      }else if(i >= 3 && i < 6){
        a[1] += this.bottomDataShouldPay[i];
      }if(i >= 6 && i < 9){
        a[2] += this.bottomDataShouldPay[i];
      }else if(i >= 9 ){
        a[3] += this.bottomDataShouldPay[i];
      }
    }
    this.bottomDataShouldPay = a;
    ///printInfo(info: 'bottomDataShouldPay ${this.yearNow}: Season: ${this.bottomDataShouldPay}');

    List b = [0.0, 0.0, 0.0, 0.0];
    for(int i = 0; i < this.bottomDataPayed.length; i++){
      if(i < 3){
        b[0] += this.bottomDataPayed[i];
      }else if(i >= 3 && i < 6){
        b[1] += this.bottomDataPayed[i];
      }if(i >= 6 && i < 9){
        b[2] += this.bottomDataPayed[i];
      }else if(i >= 9 ){
        b[3] += this.bottomDataPayed[i];
      }
    }
    this.bottomDataPayed = b;
    ///printInfo(info: 'bottomDataPayed ${this.yearNow}: Season: ${this.bottomDataPayed}');
  }

  calculateMonthData(int year){
    this.bottomDataShouldPay = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,];
    Map yearMap = this.shouldPayMap[year];
    if(yearMap != null){
      yearMap.forEach((month, allFee) {
        double amount = 0;
        for(var b in allFee){
          if(this.dropdownValueFeeType == "全部"){
            amount += b['cost'];
          }else{
            if(b['type'] == this.dropdownValueFeeType){
              amount += b['cost'];
            }
          }

        }
        this.bottomDataShouldPay[month-1] = amount;
      });
    }
    ///printInfo(info: 'bottomDataShouldPay $year: Month: ${this.bottomDataShouldPay}');

    this.bottomDataPayed = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,];
    Map yearMap2 = this.payedMap[year];
    if(yearMap2 != null){
      yearMap2.forEach((month, allFee) {
        double amount = 0;
        for(var b in allFee){
          if(this.dropdownValueFeeType == "全部"){
            amount += b['payedFee'];
          }else if(b['type'] == this.dropdownValueFeeType){
            amount += b['payedFee'];
          }
        }
        this.bottomDataPayed[month-1] = amount;
      });
    }
    ///printInfo(info: 'bottomDataPayed $year: Month: ${this.bottomDataPayed}');
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