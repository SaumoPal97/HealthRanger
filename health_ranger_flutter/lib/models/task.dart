// village specific tasks

class Task {
  final String tid;
  final String title;
  final bool isDone;

  const Task({
    required this.tid,
    required this.title,
    required this.isDone,
  });

  Map<String, dynamic> toJson() => {
        "id": tid,
        "title": title,
        "isDone": isDone,
      };
}
