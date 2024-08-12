import 'package:uuid/uuid.dart';

class Question {
  final String qid;
  final String title;

  const Question({
    required this.qid,
    required this.title,
  });

  static Question fromJson(Map json) {
    return Question(
      qid: const Uuid().v1(),
      title: json["title"],
    );
  }

  Map<String, dynamic> toJson() => {
        "qid": qid,
        "title": title,
      };
}
