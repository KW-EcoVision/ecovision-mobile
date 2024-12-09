class HistoryData {
  late int id;
  late String location;
  late int time;
  late int distance;
  late int trashCount;
  late DateTime createdAt;

  HistoryData(
      {required this.id,
      required this.location,
      required this.time,
      required this.distance,
      required this.trashCount,
      required this.createdAt});
}
