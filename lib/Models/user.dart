class MyUser {
  final String user_id;
  final String user_name;
  final String user_email;

  MyUser({
    required this.user_id,
    required this.user_name,
    required this.user_email,
  });

  static MyUser fromJson(Map<String, dynamic> json) {
    return MyUser(
      user_id: json['user_id'],
      user_name: json['user_name'],
      user_email: json['user_email'],
    );
  }

  Map<String, dynamic> toJson() => {
    'user_id': user_id,
    'user_name': user_name,
    'user_email': user_email,
  };
}
