import 'package:eco_vision/view/const/EcoVisionColor.dart';
import 'package:eco_vision/view/page/history/HistoryPage.dart';
import 'package:eco_vision/view/page/home/HomePage.dart';
import 'package:eco_vision/view/page/setting/Setting.dart';
import 'package:eco_vision/view/page/activity/ActivityPage.dart';
import 'package:flutter/material.dart';

class MainFrame extends StatefulWidget {
  final int? index;
  const MainFrame({super.key, this.index});

  @override
  State<MainFrame> createState() => _MainFrameState();
}

class _MainFrameState extends State<MainFrame> {
  int currentIndex = 1;
  List pages = [
    const Home(),
    const Activity(),
    const History(),
    const Setting()
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.index != null) {
      currentIndex = widget.index!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        fixedColor: EcoVisionColor.mainGreen,
        backgroundColor: EcoVisionColor.background,
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
