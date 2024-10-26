import 'package:eco_vision/model/PostData.dart';
import 'package:eco_vision/service/PostTest.dart';
import 'package:eco_vision/view/const/EcoVisionColor.dart';
import 'package:eco_vision/view/page/home/PostViewPage.dart';
import 'package:eco_vision/view/page/home/PostWritePage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isHistoriesInitialized = false;
  late List<PostData> posts;
  PostTest test = PostTest();

  @override
  void initState() {
    super.initState();
    // test대신 기록 받아오는 api 넣기

    test.PostDataInit().then((_) {
      setState(() {
        posts = test.getPosts();
        isHistoriesInitialized = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EcoVisionColor.background,
      appBar: AppBar(
        backgroundColor: EcoVisionColor.background,
        title: const Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: isHistoriesInitialized
            ? posts.isNotEmpty
                ? ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                        width: MediaQuery.of(context).size.width - 20,
                        child: InkWell(
                          splashColor: Colors.transparent,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PostViewPage(
                                          postData: posts[index],
                                        )));
                          },
                          child: Card(
                            color: Colors.white,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    posts[index].title,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    posts[index].content,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                      '${posts[index].writer}\n${DateFormat.yMMMd().format(posts[index].createdAt)} | ${posts[index].location}'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text('게시글이 없습니다.'),
                  )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: EcoVisionColor.mainGreen,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const PostWritePage()));
        },
        child: const Icon(
          Icons.edit_note_outlined,
          color: Colors.white,
        ),
      ),
    );
  }
}
