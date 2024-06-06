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

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  void _updateTime() {
    setState(() {
      // _currentTime = DateFormat.Hms().format(DateTime.now());
      DateTime currentTimeUTC = DateTime.now().toUtc();
      DateTime currentTimeKST = currentTimeUTC.add(const Duration(hours: 9));
      _currentTime = DateFormat.Hms().format(currentTimeKST);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _currentTime,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
