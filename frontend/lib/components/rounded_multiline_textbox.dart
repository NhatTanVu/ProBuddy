import 'package:flutter/material.dart';

class RoundedMultiLineTextField extends StatefulWidget {
  const RoundedMultiLineTextField(
      {Key? key,
      required this.hintText,
      required this.backgroundColour,
      required this.textColour,
      this.icon,
      this.controller,
      this.obscureText = false,
      this.height = 65,
      this.width,
      this.fontSize = 18})
      : super(key: key);

  final Color backgroundColour;
  final Color textColour;
  final String hintText;
  final IconData? icon;
  final bool obscureText;
  final double height;
  final double? width;
  final double fontSize;
  final TextEditingController? controller;

  @override
  State<RoundedMultiLineTextField> createState() =>
      _RoundedMultiLineTextFieldState();
}

class _RoundedMultiLineTextFieldState extends State<RoundedMultiLineTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          prefixIcon: (widget.icon != null)
              ? Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: const Color(0xFFE2E2E2),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(width: 1, color: Colors.white)),
                  child: Icon(widget.icon,
                      color: const Color(0xFF49454F), size: 20),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          labelText: widget.hintText,
          labelStyle:
              TextStyle(color: widget.textColour, fontSize: widget.fontSize),
          fillColor: widget.backgroundColour,
        ),
        style: TextStyle(color: widget.textColour, fontSize: widget.fontSize),
        obscureText: widget.obscureText,
        maxLines: null,
        expands: true,
        keyboardType: TextInputType.multiline,
      ),
    );
  }
}
