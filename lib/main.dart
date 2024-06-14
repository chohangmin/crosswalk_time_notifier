import 'package:crosswalk_time_notifier/widgets/db_fetch_load_widget.dart';
import 'package:flutter/material.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();


  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DbFetchLoadWidget(),
    );
  }
}
