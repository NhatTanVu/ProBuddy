import 'package:flutter/material.dart';

class RoundedTextField extends StatefulWidget {
  const RoundedTextField(
      {Key? key,
      required this.hintText,
      required this.backgroundColour,
      required this.textColour,
      this.icon,
      this.controller,
      this.readOnly = false,
      this.obscureText = false,
      this.height = 65,
      this.width,
      this.fontSize = 18,

      })
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
  final bool readOnly;

  @override
  State<RoundedTextField> createState() => _RoundedTextFieldState();
}

class _RoundedTextFieldState extends State<RoundedTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: TextField(
        controller: widget.controller,
        enabled: !widget.readOnly,
        decoration: InputDecoration(
          prefixIcon: (widget.icon != null)
              ? Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: const Color(0xFFE2E2E2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(width: 1, color: Colors.white)),
                  child: Icon(widget.icon, color: const Color(0xFF49454F), size: 20),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          filled: true,
          labelText: widget.hintText,
          labelStyle: TextStyle(color: widget.textColour, fontSize: widget.fontSize),
          fillColor: widget.backgroundColour,
        ),
        style: TextStyle(color: widget.textColour, fontSize: widget.fontSize),
        obscureText: widget.obscureText,
      ),
    );
  }
}
