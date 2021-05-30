import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomButton extends StatelessWidget {
  var onPress;
  Widget child;
  var color;

  CustomButton({this.onPress, required this.child, this.color});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 56.0,
      onPressed: onPress,
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      textColor: Colors.white,
      child: child,
      color: color ?? Theme.of(context).accentColor,
    );
  }
}
