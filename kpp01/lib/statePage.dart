import 'package:flutter/material.dart';

class StatePageWaiting extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(body: Center(child: CircularProgressIndicator(),),);
  }
}

class StatePageLoading extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.red,
        body: Center(
          child: Text("Loading"),
        ),
      ),
    );
  }
}

class StatePageError extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text("Error"),
        ),
      ),
    );
  }
}