import 'package:flutter/material.dart';
import 'package:ridemate/pages/main_page.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('Starting app with custom logging level');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
      theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.green,
      ),
    );
  }
}