import 'package:eco_vision/view/page/LoginPage.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  // debugPaintSizeEnabled = true;
  await initializeDateFormatting();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'NanumSquareNeo-bRg',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
      ),
      title: 'Eco Vision',
      home: const LoginPage(),
    );
  }
}
