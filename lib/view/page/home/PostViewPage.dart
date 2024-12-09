import 'dart:convert';

import 'package:eco_vision/model/CommentData.dart';
import 'package:eco_vision/model/PostData.dart';
import 'package:eco_vision/service/CommentService.dart';
import 'package:eco_vision/view/const/EcoVisionColor.dart';
import 'package:eco_vision/view/widget/EcoTextField.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PostViewPage extends StatefulWidget {
  final PostData postData;
  const PostViewPage({super.key, required this.postData});

  @override
  State<PostViewPage> createState() => _PostViewPageState();
}

class _PostViewPageState extends State<PostViewPage> {
  bool isCommentsInitialized = false;
  late List<CommentData> comments;
  CommentService service = CommentService();
  String tempComment = '';
  @override
  void initState() {
    super.initState();

    service.CommentDataInit(widget.postData.id).then((comments) {
      setState(() {
        this.comments = comments;
        isCommentsInitialized = true;
      });
    });
  }

  Future<void> createComment(String content) async {
    late String token;
    late SharedPreferences prefs;

    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('accessToken')!;

    await http.post(
        Uri.parse("http://43.201.1.7:8080/board/${widget.postData.id}/comment"),
        headers: {'Content-Type': 'application/json', 'Authorization': token},
        body: json.encode({"boardId": widget.postData.id, "content": content}));
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.postData.title;
    String content = widget.postData.content;
    String writer = widget.postData.writer;
    String createdAt =
        "${DateFormat.yMMMd().format(widget.postData.createdAt)} | ${DateFormat.Hm().format(widget.postData.createdAt)}";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('게시글'),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Stack(
            children: [
              SizedBox(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: ListView(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            writer,
                            style: const TextStyle(fontSize: 20),
                          ),
                          Text(
                            '$createdAt\n',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          Text(title,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Text('\n$content\n'),
                          const Divider(
                              thickness: 1, height: 2, color: Colors.grey),
                          Container(
                            margin: const EdgeInsets.fromLTRB(3, 8, 3, 0),
                            width: MediaQuery.of(context).size.width - 6,
                            child: isCommentsInitialized
                                ? comments.isNotEmpty
                                    ? ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: comments.length,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Text(
                                                comments[index].writer,
                                                style: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(comments[index].content),
                                              Text(
                                                "${DateFormat.yMMMd().format(comments[index].createdAt)} | ${DateFormat.Hm().format(comments[index].createdAt)}"
                                                "\n",
                                                style: const TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          );
                                        })
                                    : const Center(
                                        child: Text('댓글이 없습니다'),
                                      )
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 12,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                  child: Row(
                    children: [
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.fromLTRB(13, 0, 13, 0),
                        child: EcoTextField(
                          labelText: '댓글을 입력하세요',
                          width: MediaQuery.of(context).size.width - 26,
                          height: MediaQuery.of(context).size.height / 11,
                          enabledBorderColor: Colors.white,
                          focusedBorderColor: EcoVisionColor.neonGreen,
                          radius: 10,
                          isPassword: false,
                          onChanged: (value) {
                            setState(() {
                              tempComment = value;
                            });
                          },
                          onSubmitted: (value) {
                            if (tempComment.isNotEmpty) {
                              createComment(tempComment).then((_) {
                                service.CommentDataInit(widget.postData.id)
                                    .then((comments) {
                                  setState(() {
                                    this.comments = comments;
                                    isCommentsInitialized = true;
                                  });
                                });
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
