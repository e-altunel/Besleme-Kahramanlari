import "package:flutter/material.dart";

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  final void Function(String)
      onTextChanged; // Callback function for text changes

  MyTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.onTextChanged,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        onChanged: onTextChanged,
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          fillColor: Color.fromARGB(224, 155, 154, 154),
          filled: true,
          hintText: hintText,
        ),
      ),
    );
  }
}
