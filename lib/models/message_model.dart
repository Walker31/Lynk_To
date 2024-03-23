class MessageModel {
  MessageModel({
    required this.message,
    required this.timestamp,
    required this.rollno,
  });

  final String message;
  final DateTime timestamp;
  final String rollno;

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      message: json["message"] ?? "",
      timestamp: DateTime.parse(json["timestamp"]),
      rollno: json["rollno"] ?? "", // Assuming rollno is a String
    );
  }
}
