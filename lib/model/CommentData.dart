class CommentData {
  late int id;
  late String content;
  late String writer;
  late DateTime createdAt;

  CommentData(
      {required this.id,
      required this.content,
      required this.writer,
      required this.createdAt});
}
