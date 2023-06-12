import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key? key,
    required this.title,
    required this.backgroundColour,
    required this.textColour,
    required this.onPressed,
    this.height = 52.0,
    this.fontSize = 18,
  }) : super(key: key);

  final Color backgroundColour;
  final Color textColour;
  final String title;
  final Function onPressed;
  final double height;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      color: backgroundColour,
      borderRadius: BorderRadius.circular(100.0),
      child: MaterialButton(
        onPressed: () => onPressed(),
        minWidth: 100.0,
        height: height,
        child: Text(
          title,
          style: TextStyle(color: textColour, fontSize: fontSize),
        ),
      ),
    );
  }
}
