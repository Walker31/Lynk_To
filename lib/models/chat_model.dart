class ChatMessageModel {
  final String? message;
  final DateTime timestamp;
  final String rollno; // Adding rollno property

  const ChatMessageModel({
    this.message,
    required this.timestamp,
    required this.rollno, // Adding rollno to the constructor
  });

  factory ChatMessageModel.fromMap(Map data) {
    return ChatMessageModel(
      message: data['message'],
      timestamp: DateTime.now(), // You can adjust this based on your actual timestamp
      rollno: data['rollno'], // Parsing rollno from the data map
    );
  }
}
