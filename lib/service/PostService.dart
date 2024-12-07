import 'dart:convert';

import 'package:eco_vision/model/PostData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PostService {
  late String token;
  late SharedPreferences prefs;
  late List<PostData> posts = [];

  Future<List<PostData>> postDataInit() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('accessToken')!;

    http.Response response = await http.get(
        Uri.parse("http://43.201.1.7:8080/board"),
        headers: {'Content-Type': 'application/json', 'Authorization': token});

    posts = [];
    if (response.statusCode == 200) {
      int i = 0;

      List dto = jsonDecode(utf8.decode(response.bodyBytes));

      while (i < dto.length) {
        PostData data = PostData(
          id: dto[i]["id"],
          title: dto[i]["title"],
          content: dto[i]["content"],
          writer: dto[i]["name"],
          createdAt: DateTime.parse(dto[i]["write_time"]),
        );

        posts.add(data);
        i++;
      }
    }
    return posts;
  }

  List<PostData> getPosts() {
    return posts;
  }
}
