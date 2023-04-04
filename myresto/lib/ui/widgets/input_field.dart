import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType type;
  TextInputAction action;
  final String hintText;
  final bool secureText;
  final bool readOnly; // add this line
  final Function onTap;

  InputField({
    this.controller,
    this.type,
    this.hintText,
    this.secureText = false,
    this.readOnly = false, // set a default value
    this.onTap,
    this.action,
  });

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
          obscureText: secureText,
          readOnly: readOnly,
          decoration:
              InputDecoration(hintText: hintText, border: InputBorder.none),
        ),
      ),
    );
  }
}
