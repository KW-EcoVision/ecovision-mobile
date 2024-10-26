import 'package:eco_vision/model/CommentData.dart';
import 'package:eco_vision/model/PostData.dart';
import 'package:eco_vision/service/CommentTest.dart';
import 'package:eco_vision/view/const/EcoVisionColor.dart';
import 'package:eco_vision/view/widget/EcoTextField.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostViewPage extends StatefulWidget {
  final PostData postData;
  const PostViewPage({super.key, required this.postData});

  @override
  State<PostViewPage> createState() => _PostViewPageState();
}

class _PostViewPageState extends State<PostViewPage> {
  bool isCommentsInitialized = false;
  late List<CommentData> comments;
  CommentTest test = CommentTest();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    test.CommentDataInit().then((_) {
      setState(() {
        comments = test.getComments();
        isCommentsInitialized = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.postData.title;
    String content = widget.postData.content;
    String writer = widget.postData.writer;
    String createdAt = DateFormat.yMMMd().format(widget.postData.createdAt);
    String location = widget.postData.location;
    return Scaffold(
      backgroundColor: EcoVisionColor.background,
      appBar: AppBar(
        backgroundColor: EcoVisionColor.background,
        title: const Text(
          '게시글',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
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
                          '$createdAt | $location\n',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        Text(title,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('\n$content'),
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
                                              '\n${comments[index].writer}',
                                              style: const TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(comments[index].content),
                                            Text(
                                              DateFormat.yMMMd().format(
                                                  comments[index].createdAt),
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
                          height: MediaQuery.of(context).size.height / 11,
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
              child: Container(
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
                      setState(() {});
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
