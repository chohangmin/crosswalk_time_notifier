import 'package:crosswalk_time_notifier/services/search_service.dart';
import 'package:crosswalk_time_notifier/widgets/db_widget.dart';
import 'package:crosswalk_time_notifier/widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:crosswalk_time_notifier/widgets/locator_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: SearchWidget(),
    );
  }
}
