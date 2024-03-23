import 'dart:async';
import 'package:flutter/material.dart';

class CalendarCard extends StatefulWidget {
  final StreamController<String> streamController;

  const CalendarCard({Key? key, required this.streamController}) : super(key: key);

  @override
  State<CalendarCard> createState() => _CalendarCardState();
}

class _CalendarCardState extends State<CalendarCard> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _emitSelectedDate(_selectedDate); // Emit initial selected date
  }

  void _emitSelectedDate(DateTime selectedDate) {
    widget.streamController.add(selectedDate.toString()); // Emit selected date through stream
  }

  @override
  Widget build(BuildContext context) {
    return CalendarDatePicker(
      firstDate: DateTime(2020, 12, 1),
      lastDate: DateTime(2029, 12, 1),
      initialDate: _selectedDate,
      onDateChanged: (value) {
        setState(() {
          _selectedDate = value;
        });
        _emitSelectedDate(_selectedDate); // Emit selected date when date changes
      },
    );
  }
}
