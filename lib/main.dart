import 'package:crosswalk_time_notifier/screens/show_screen.dart';
import 'package:flutter/material.dart';
import 'package:crosswalk_time_notifier/services/db_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // DbService dbService = DbService();
  // dbService.makeDb();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ShowScreen(),
    );
  }
}
