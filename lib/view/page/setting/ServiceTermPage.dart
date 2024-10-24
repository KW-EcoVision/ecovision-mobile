import 'package:flutter/material.dart';

class ServiceTermPage extends StatelessWidget {
  const ServiceTermPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          '위치 기반 서비스 이용약관',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Image.asset('assets/images/serviceterm.png')),
      ),
    );
  }
}
