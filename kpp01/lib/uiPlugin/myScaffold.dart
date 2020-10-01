import 'package:kpp01/myPlugin/dataAppSizePlugin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyScaffold extends StatelessWidget{
  const MyScaffold({
    Key key,
    this.top,
    this.scaffold,
    this.color,
}):super(key:key);
  final double top;
  final Scaffold scaffold;
  final Color color;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        Container(
          height: top,
          color: color,
        ),
        Expanded(child: scaffold),
      ],
    );
  }
}