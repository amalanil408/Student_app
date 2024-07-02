import 'package:flutter/material.dart';
import 'package:project_2/db/functions/db_functions.dart';
import 'package:project_2/screens/homeScreen.dart';

void main(List<String> args) async{
  WidgetsFlutterBinding.ensureInitialized();
  await initzlizeDB();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: screenHome(),
    );
  }
}