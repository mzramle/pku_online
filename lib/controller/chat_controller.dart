import 'package:flutter/foundation.dart';
import 'package:pku_online/models/chat_model.dart';

class ChatController {
  List<ChatModel> chats = [];

  int getChatsCount() {
    return chats.length;
  }

  void sendMessage({
    required String senderId,
    required String receiverId,
    required String message,
  }) {
    final newChat = ChatModel(
      senderId: senderId,
      receiverId: receiverId,
      message: message,
      timestamp: DateTime.now(),
    );
    chats.add(newChat);
  }

  List<ChatModel> getChatsForReceiver(String receiverId) {
    return chats.where((chat) => chat.receiverId == receiverId).toList();
  }
}
