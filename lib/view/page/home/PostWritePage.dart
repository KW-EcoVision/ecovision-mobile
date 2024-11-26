import 'dart:convert';

import 'package:eco_vision/view/const/EcoVisionColor.dart';
import 'package:eco_vision/view/page/MainFrame.dart';
import 'package:eco_vision/view/widget/EcoTextField.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PostWritePage extends StatefulWidget {
  const PostWritePage({super.key});

  @override
  State<PostWritePage> createState() => _PostWritePageState();
}

class _PostWritePageState extends State<PostWritePage> {
  String tempTitle = '';
  String tempContent = '';

  Future<void> createComment(String title, String content) async {
    late String token;
    late SharedPreferences prefs;

    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('accessToken')!;

    await http.post(Uri.parse("http://43.201.1.7:8080/board/post"),
        headers: {'Content-Type': 'application/json', 'Authorization': token},
        body: json.encode({"title": title, "content": content}));
  }

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
                if (tempContent.isNotEmpty && tempTitle.isNotEmpty) {
                  createComment(tempTitle, tempContent).then((_) {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const MainFrame(
                                  index: 0,
                                )),
                        (route) => false);
                  });
                }
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
                  setState(() {
                    tempTitle = value;
                  });
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
                  setState(() {
                    tempContent = value;
                  });
                }),
          ],
        ),
      )),
    );
  }
}
