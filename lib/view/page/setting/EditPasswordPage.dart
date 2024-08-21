import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EditPasswordPage extends StatefulWidget {
  const EditPasswordPage({super.key});

  @override
  State<EditPasswordPage> createState() => _EditPasswordPageState();
}

class _EditPasswordPageState extends State<EditPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '비밀번호 변경',
          style: TextStyle(fontFamily: 'bmjua'),
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(child: Container()),
    );
  }
}
