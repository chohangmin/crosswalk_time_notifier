import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class ApiTimeWidget extends StatefulWidget {
  double utcTime;
  final String name;

  ApiTimeWidget({
    super.key,
    required this.name,
    required this.utcTime,
  });

  @override
  State<ApiTimeWidget> createState() => _ApiTimeWidgetState();
}

class _ApiTimeWidgetState extends State<ApiTimeWidget> {
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
      widget.utcTime += 1000;
    });
  }

  void _updateTime() {
    setState(() {
      DateTime currentTimeAPI =
          DateTime.fromMillisecondsSinceEpoch(widget.utcTime.toInt());
DateTime currentTimeKST = currentTimeAPI.add(Duration(hours: 9));
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
      '${widget.name} : $_currentTime',
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
