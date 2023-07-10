import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key? key,
    required this.title,
    required this.backgroundColour,
    required this.textColour,
    required this.onPressed,
    this.height = 52,
    this.fontSize = 18,
    this.width = 100,
  }) : super(key: key);

  final Color backgroundColour;
  final Color textColour;
  final String title;
  final Function onPressed;
  final double height;
  final double width;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(textColour),
            backgroundColor: MaterialStateProperty.all<Color>(backgroundColour),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(color: backgroundColour))),
          ),
          onPressed: () => onPressed(),
          child: Text(title, style: TextStyle(fontSize: fontSize))),
    );
  }
}
