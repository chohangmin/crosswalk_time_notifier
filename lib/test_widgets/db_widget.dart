import 'package:crosswalk_time_notifier/services/db_service.dart';
import 'package:flutter/material.dart';

class DbWidget extends StatelessWidget {
  DbService dbService = DbService();

  DbWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder(
          future: dbService.getAllow(),
          builder:
              (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error : ${snapshot.error}'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(snapshot.data![index]['id'].toString()),
                    subtitle: Text(
                        'name : ${snapshot.data![index]['name']} (lat, lon): (${snapshot.data![index]['lat']},${snapshot.data![index]['lon']},)'),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
