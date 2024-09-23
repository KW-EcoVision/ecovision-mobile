import 'dart:math';

import 'package:eco_vision/model/PostData.dart';

class PostTest {
  int randomLength = Random().nextInt(10);
  late List<PostData> posts = [];

  Future<void> PostDataInit() async {
    posts = [];
    int randomLength = Random().nextInt(10);
    int i = 0;

    while (i <= randomLength) {
      String randomWriter = "김에코";
      String randomTitle = "오늘 8시에 같이 플로깅 하실분!";
      String randomContent = "오늘 저녁 8시에 우이천에서 같이 플로깅하실 분 구해요!";

      DateTime randomCreatedAt = DateTime.now();
      String randomLocation = "서울시 노원구";

      PostData data = PostData(
        title: randomTitle,
        content: randomContent,
        writer: randomWriter,
        location: randomLocation,
        createdAt: randomCreatedAt,
      );

      posts.add(data);
      i++;
    }
    await Future.delayed(const Duration(seconds: 1)); // 테스트용 2초 딜레이
  }

  List<PostData> getPosts() {
    return posts;
  }
}
