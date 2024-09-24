import 'package:eco_vision/view/const/EcoVisionColor.dart';
import 'package:eco_vision/view/widget/EcoTextField.dart';
import 'package:flutter/material.dart';

class PostWritePage extends StatefulWidget {
  const PostWritePage({super.key});

  @override
  State<PostWritePage> createState() => _PostWritePageState();
}

class _PostWritePageState extends State<PostWritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('게시글 작성'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('확인'))
        ],
      ),
      body: SafeArea(
          child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            EcoTextField(
                labelText: '제목을 입력하세요',
                width: MediaQuery.of(context).size.width - 26,
                height: MediaQuery.of(context).size.height / 11,
                enabledBorderColor: Colors.white,
                focusedBorderColor: EcoVisionColor.neonGreen,
                radius: 10,
                isPassword: false,
                onChanged: (value) {
                  setState(() {});
                }),
            EcoTextField(
                labelText: '내용을 입력하세요',
                maxLine: 18,
                width: MediaQuery.of(context).size.width - 26,
                height: MediaQuery.of(context).size.height / 2,
                enabledBorderColor: Colors.white,
                focusedBorderColor: EcoVisionColor.neonGreen,
                radius: 10,
                isPassword: false,
                onChanged: (value) {
                  setState(() {});
                }),
          ],
        ),
      )),
    );
  }
}
