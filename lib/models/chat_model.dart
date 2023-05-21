class ChatModel {
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime timestamp;

  ChatModel({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
  });
}
