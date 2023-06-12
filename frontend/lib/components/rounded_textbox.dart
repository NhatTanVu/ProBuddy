import 'package:flutter/material.dart';

class RoundedTextField extends StatelessWidget {
  RoundedTextField(
      {Key? key,
      required this.hintText,
      required this.backgroundColour,
      required this.textColour,
      this.icon,
      this.obscureText = false,
      this.height = 65,
      this.width,
      this.fontSize = 18})
      : super(key: key);

  final Color backgroundColour;
  final Color textColour;
  final String hintText;
  IconData? icon;
  final bool obscureText;
  final double height;
  final double? width;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: (icon != null)
              ? Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: const Color(0xFFE2E2E2),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(width: 1, color: Colors.white)),
                  child: Icon(icon, color: const Color(0xFF49454F), size: 20),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          filled: true,
          labelText: hintText,
          labelStyle: TextStyle(color: textColour, fontSize: fontSize),
          fillColor: backgroundColour,
        ),
        style: TextStyle(color: textColour, fontSize: fontSize),
        obscureText: obscureText,
      ),
    );
  }
}
