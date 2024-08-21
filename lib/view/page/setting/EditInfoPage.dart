import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EditInfoPage extends StatefulWidget {
  const EditInfoPage({super.key});

  @override
  State<EditInfoPage> createState() => _EditInfoPageState();
}

class _EditInfoPageState extends State<EditInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '내 정보 수정',
          style: TextStyle(fontFamily: 'bmjua'),
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(child: Container()),
    );
  }
}
