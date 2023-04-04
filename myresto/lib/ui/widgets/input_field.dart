import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  TextEditingController controller;
  TextInputAction action;
  TextInputType type;
  String hintText;
  bool sercureText;
  bool readOnly;
  Function onTap;

  InputField(
      {this.controller,
      this.action,
      this.type,
      this.hintText,
      this.sercureText,
      this.readOnly,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: TextField(
          controller: controller,
          onTap: () => onTap != null ? onTap() : {},
          textInputAction: action,
          keyboardType: type,
          obscureText: sercureText,
          readOnly: readOnly,
          decoration:
              InputDecoration(hintText: hintText, border: InputBorder.none),
        ),
      ),
    );
  }
}
