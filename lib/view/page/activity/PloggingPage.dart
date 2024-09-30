import 'dart:async';

import 'package:camera/camera.dart';
import 'package:eco_vision/view/page/activity/CameraPage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

//legacy : to be deleted

class PloggingPage extends StatefulWidget {
  const PloggingPage({super.key});

  @override
  State<PloggingPage> createState() => _PloggingPageState();
}

class _PloggingPageState extends State<PloggingPage> {
  final stopWatchTimer = StopWatchTimer(mode: StopWatchMode.countUp);

  late List<CameraDescription> descriptions;
  late CameraController cameraController;
  bool isCameraInitialized = false;

  double currentSpeed = 0;
  StreamSubscription<Position>? positionStream;
  int test = 0;
  double timeInterval = 0;
  double lastTime = 0;
  double distanceStack = 0;

  Future<void> initCamera() async {
    descriptions = await availableCameras();
    cameraController = CameraController(descriptions[0], ResolutionPreset.high);
    await cameraController.initialize();
    // print('camera is ready!');
    setState(() {
      isCameraInitialized = true;
    });
  }

  @override
  void initState() {
    super.initState();
    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
          // accuracy: LocationAccuracy.high,
          // distanceFilter: 10, // 위치 변경이 10m 이상일 때만 알림을 받음
          ),
    ).listen((Position position) {
      double now = stopWatchTimer.rawTime.value / 1000;
      timeInterval = now - lastTime;
      // print('now : $now');
      // print('time : $timeInterval');
      lastTime = now;

      setState(() {
        if (position.speed < 1) {
          distanceStack += 0 * timeInterval;
        } else {
          currentSpeed = position.speed * 3.6; // 속도 업데이트
          distanceStack += position.speed * timeInterval;
        }
      });
      // print('speed : $currentSpeed');

      // print('distance : $distanceStack');
    });
  }

  @override
  void dispose() {
    positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${currentSpeed.toStringAsFixed(2)} km/h'),
            Text('${distanceStack.toStringAsFixed(2)} m'),
            StreamBuilder<int>(
                stream: stopWatchTimer.rawTime,
                builder: (context, snap) {
                  final int? value = snap.data;
                  final String displayTime =
                      StopWatchTimer.getDisplayTime(value!, milliSecond: false);
                  // time = StopWatchRecord.fromRawValue(value->)
                  return Text(
                    displayTime,
                    // style: TextStyle(
                    //     fontSize: MediaQuery.of(context).size.width / 8,
                    //     fontWeight: FontWeight.bold),
                  );
                }),
            TextButton(
                onPressed: () {
                  stopWatchTimer.onStartTimer();
                },
                child: Text('start')),
            TextButton(
                onPressed: () {
                  stopWatchTimer.onStopTimer();
                },
                child: Text('stop')),
            TextButton(
                onPressed: () {
                  stopWatchTimer.onResetTimer();
                },
                child: Text('reset')),
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.camera_alt_outlined),
        onPressed: () async {
          await initCamera();
          if (isCameraInitialized) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CameraPage(cameraController: cameraController),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Camera is not initialized yet!')),
            );
          }
        },
      ),
    );
  }
}
