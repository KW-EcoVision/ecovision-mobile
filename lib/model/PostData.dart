class PostData {
  late int id;
  late String title;
  late String content;
  late String writer;
  late DateTime createdAt;

  PostData(
      {required this.id,
      required this.title,
      required this.content,
      required this.writer,
      required this.createdAt});
}
