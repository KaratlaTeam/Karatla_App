import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class MyCircleButton extends StatelessWidget{
  const MyCircleButton({
    Key key,
    this.child,
    this.height,
    this.width,
    this.color,
    this.onPressed,
    this.shape,
  }):super(key:key);
  final Widget child;
  final double height;
  final double width;
  final Color color;
  final VoidCallback onPressed;
  final ShapeBorder shape;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      textColor: Colors.white,
      color: color,
      elevation: 14,
      shape: shape,
      onPressed: onPressed,
      child: Container(
        alignment: Alignment.center,
        height: height,
        width: width,
        child: child,
      ),
    );
  }
}

class MyOpenContainer extends StatelessWidget{

  const MyOpenContainer({
    Key key,
    this.closedColor,
    this.openColor,
    this.height,
    this.width,
    this.openContainerBuilder,
    this.closedShape: const CircleBorder(),
    this.margin,
    this.closedBuilder,
    this.closedElevation:1,
    this.tappable:true,
  }):super(key:key);

  final Color closedColor;
  final Color openColor;
  final double height;
  final double width;
  final OpenContainerBuilder openContainerBuilder;
  final ShapeBorder closedShape;
  final EdgeInsetsGeometry margin;
  final OpenContainerBuilder closedBuilder;
  final double closedElevation;
  final bool tappable;

  @override
  Widget build(BuildContext context) {
    //  
    return Container(
      height: height,
      width: width,
      margin: margin,
      child: OpenContainer(
        transitionDuration: const Duration(milliseconds: 300),
        transitionType: ContainerTransitionType.fade,
        tappable: tappable,
        closedElevation: closedElevation,
        closedColor: closedColor,
        closedShape: closedShape,
        closedBuilder: closedBuilder,
        openColor: openColor,
        openBuilder: openContainerBuilder,
      ),
    );
  }
}