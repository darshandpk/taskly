import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:taskly/pages/home_pages.dart';

void main() async{
  await Hive.initFlutter("hive_boxes");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      color: Color.fromRGBO(80, 30, 50, 1.0),
      home: HomePage(),
    );
  }
}