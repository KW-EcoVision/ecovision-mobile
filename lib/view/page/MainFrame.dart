import 'package:eco_vision/view/const/EcoVisionColor.dart';
import 'package:eco_vision/view/page/HistoryPage.dart';
import 'package:eco_vision/view/page/HomePage.dart';
import 'package:eco_vision/view/page/Setting.dart';
import 'package:eco_vision/view/page/ActivityPage.dart';
import 'package:flutter/material.dart';

class MainFrame extends StatefulWidget {
  const MainFrame({super.key});

  @override
  State<MainFrame> createState() => _MainFrameState();
}

class _MainFrameState extends State<MainFrame> {
  int currentIndex = 0;
  List pages = [Home(), Activity(), History(), Setting()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: pages[currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        fixedColor: EcoVisionColor.mainGreen,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.directions_run_outlined), label: 'activity'),
          BottomNavigationBarItem(
              icon: Icon(Icons.history_outlined), label: 'history'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'setting'),
        ],
        onTap: (value) {
          currentIndex = value;
          setState(() {});
        },
      ),
    );
  }
}
