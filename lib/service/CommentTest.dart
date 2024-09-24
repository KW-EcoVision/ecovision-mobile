import 'dart:math';

import 'package:eco_vision/model/CommentData.dart';

class CommentTest {
  int randomLength = Random().nextInt(10);
  late List<CommentData> comments = [];

  Future<void> CommentDataInit() async {
    comments = [];
    int randomLength = Random().nextInt(10);
    int i = 0;

    while (i <= randomLength) {
      String randomWriter = "박에코";
      String randomContent = "싫어요 안 나갈래요ㅋ";

      DateTime randomCreatedAt = DateTime.now();

      CommentData data = CommentData(
        content: randomContent,
        writer: randomWriter,
        createdAt: randomCreatedAt,
      );

      comments.add(data);
      i++;
    }
    await Future.delayed(const Duration(seconds: 1)); // 테스트용 2초 딜레이
  }

  List<CommentData> getComments() {
    return comments;
  }
}
