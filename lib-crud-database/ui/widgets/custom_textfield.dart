import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  TextInputAction action;
  TextInputType type;
  TextEditingController controller;
  String hinText;

  CustomTextField({this.action, this.type, this.controller, this.hinText});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        textInputAction: action,
        keyboardType: type,
        controller: controller,
        decoration: InputDecoration(hintText: hinText),
      ),
    );
  }
}
