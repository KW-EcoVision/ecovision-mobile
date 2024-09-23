class PostData {
  late String title;
  late String content;
  late String writer;
  late String location;
  late DateTime createdAt;

  PostData(
      {required this.title,
      required this.content,
      required this.writer,
      required this.location,
      required this.createdAt});
}
