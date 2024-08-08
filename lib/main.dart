import 'package:flutter/material.dart';
import "package:hive/hive.dart";
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quantum_task/Views/Home.dart';
void main() async{
  await Hive.initFlutter();
  await Hive.openBox("MyData");
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner:false,
      home:Home(),
    );
  }
}
