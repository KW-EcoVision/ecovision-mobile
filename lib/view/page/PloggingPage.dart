import 'package:camera/camera.dart';
import 'package:eco_vision/view/page/CameraPage.dart';
import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

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
  void dispose() {
    super.dispose();
    stopWatchTimer.dispose();
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
            StreamBuilder<int>(
                stream: stopWatchTimer.rawTime,
                builder: (context, snap) {
                  final int? value = snap.data;
                  final String displayTime =
                      StopWatchTimer.getDisplayTime(value!);
                  return Text(displayTime);
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
