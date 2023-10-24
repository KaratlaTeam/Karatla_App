import 'package:flutter/material.dart';

class VSetting extends StatelessWidget{
  const VSetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
      ),
      body: const Center(
        child: Text('Setting'),
      ),
    );
  }
}