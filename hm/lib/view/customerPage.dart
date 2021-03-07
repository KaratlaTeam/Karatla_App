import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomerPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(icon: Icon(Icons.add), onPressed: (){})
        ],
      ),
      body: Container(),
    );
  }
}