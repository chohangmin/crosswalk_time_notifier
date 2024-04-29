import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class CurrentTimeWidget extends StatefulWidget {
  const CurrentTimeWidget({super.key});

  @override
  State<CurrentTimeWidget> createState() => _CurrentTimeWidgetState();
}

class _CurrentTimeWidgetState extends State<CurrentTimeWidget> {
  late Timer _timer;
  late String _currentTime;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _startTimer();
  }

  void _updateTime() {
    setState(() {
      _currentTime = DataFormat.Hms().format(Datat)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('$time'),
      ),
    );
  }
}
