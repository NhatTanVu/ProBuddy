import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'rounded_textbox.dart';

class DateTimePicker extends StatefulWidget {
  const DateTimePicker({
    Key? key,
    required this.hintText,
    required this.controller,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;

  @override
  DateTimePickerState createState() => DateTimePickerState();
}

class DateTimePickerState extends State<DateTimePicker> {
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.controller.text != "") {
      selectedDate = DateFormat('yyyy-MM-dd').parse(widget.controller.text);
    } else {
      selectedDate = DateTime.now();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 180,
          color: Theme.of(context).dialogBackgroundColor,
          child: Column(
            children: [
              SizedBox(
                height: 120,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  backgroundColor: const Color(0xFFCAC4D0),
                  initialDateTime: selectedDate,
                  onDateTimeChanged: (DateTime newDate) {
                    setState(() {
                      selectedDate = newDate;
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              CupertinoButton(
                // color: const Color(0xFF49454F),
                onPressed: () {
                  Navigator.of(context).pop(selectedDate);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        widget.controller.text = DateFormat('yyyy-MM-dd').format(selectedDate!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RoundedTextField(
          controller: widget.controller,
          readOnly: true,
          hintText: widget.hintText,
          backgroundColour: const Color(0xFF49454F),
          textColour: const Color(0xFFCAC4D0),
          height: 40,
          width: 120,
          fontSize: 16,
        ),
        const SizedBox(height: 16),
        IconButton(
          icon: const Icon(Icons.calendar_today),
          color: const Color(0xFFCAC4D0),
          iconSize: 24,
          tooltip: 'Tap to open date picker',
          onPressed: () => _selectDate(context),
        ),
      ],
    );
  }
}
