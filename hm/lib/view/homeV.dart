import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hm/main.dart';
import 'package:hm/view/customerPage.dart';
import 'package:hm/view/houseV.dart';

class HomeV extends StatefulWidget {

  @override
  _HomeVState createState() => _HomeVState();
}

class _HomeVState extends State<HomeV> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: TextButton(
                child: Text("房屋"),
                onPressed: (){
                  Get.toNamed(RN.house);
                },
              ),
            ),
            Container(
              child: TextButton(
                child: Text("房客"),
                onPressed: (){
                  Get.toNamed(RN.customer);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}