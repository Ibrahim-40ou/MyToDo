class Task {
  final String? task_id;
  final String user_id;
  final String title;
  final String body;
  late bool? prioritized;
  late String? status;
  final String date_time;

  Task({
    this.task_id,
    required this.user_id,
    required this.title,
    required this.body,
    required this.prioritized,
    required this.status,
    required this.date_time,
  });

  static Task fromJson(Map<String, dynamic> json) {
    return Task(
      task_id: json['task_id'],
      user_id: json['user_id'],
      title: json['title'],
      body: json['body'],
      prioritized: json['prioritized'],
      status: json['status'],
      date_time: json['date_time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': user_id,
      'title': title,
      'body': body,
      'prioritized': prioritized,
      'status': status,
      'date_time': date_time,
    };
  }
}
