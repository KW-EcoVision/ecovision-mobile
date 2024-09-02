import 'package:eco_vision/model/StatisticalData.dart';
import 'package:eco_vision/service/StatisticalDataTest.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isStatisticalDataInitialized = false;
  late StatisticalData statisticalData;
  StatisticalDataTest test = StatisticalDataTest();

  @override
  void initState() {
    super.initState();

    test.initData().then((_) {
      setState(() {
        statisticalData = test.getStatisticalData();
        isStatisticalDataInitialized = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: isStatisticalDataInitialized
              ? Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(8, 8, 4, 0),
                          width: MediaQuery.of(context).size.width / 2 - 14,
                          height: MediaQuery.of(context).size.width / 2 - 14,
                          child: Card(
                            color: Colors.white,
                            child: Center(
                              child: Text(
                                  '총 거리 : ${statisticalData.distance.toStringAsFixed(2)}km'),
                            ),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.fromLTRB(4, 8, 8, 0),
                            width: MediaQuery.of(context).size.width / 2 - 14,
                            height: MediaQuery.of(context).size.width / 2 - 14,
                            child: Card(
                              color: Colors.white,
                              child: Center(
                                child: Text('총 시간 : ${statisticalData.time}분'),
                              ),
                            ))
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 8, 10, 0),
                      width: MediaQuery.of(context).size.width - 20,
                      height: MediaQuery.of(context).size.width / 2 - 14,
                      child: Card(
                        color: Colors.white,
                        child: Center(
                          child:
                              Text('총 주운 쓰레기 : ${statisticalData.trashCount}개'),
                        ),
                      ),
                    ),
                  ],
                )
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
