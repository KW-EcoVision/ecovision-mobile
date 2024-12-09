import 'dart:convert';

import 'package:eco_vision/model/CommentData.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CommentService {
  late String token;
  late SharedPreferences prefs;
  late List<CommentData> comments = [];

  Future<List<CommentData>> CommentDataInit(int id) async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('accessToken')!;

    http.Response response = await http.get(
        Uri.parse("http://43.201.1.7:8080/board/$id/comment"),
        headers: {'Content-Type': 'application/json', 'Authorization': token});
    List dto = jsonDecode(utf8.decode(response.bodyBytes));
    comments = [];
    int i = 0;

    while (i < dto.length) {
      CommentData data = CommentData(
        id: dto[i]["id"],
        content: dto[i]["content"],
        writer: dto[i]["writer"],
        createdAt: DateTime.parse(dto[i]["write_time"]),
      );

      comments.add(data);
      i++;
    }
    return comments;
  }

  List<CommentData> getComments() {
    return comments;
  }
}
