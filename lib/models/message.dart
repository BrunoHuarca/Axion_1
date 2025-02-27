class Message {
  final String user;
  final String text;
  final String timestamp;

  Message({required this.user, required this.text, required this.timestamp});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      user: json['user'],
      text: json['text'],
      timestamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'text': text,
      'timestamp': timestamp,
    };
  }
}
