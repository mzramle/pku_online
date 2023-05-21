import 'package:flutter/material.dart';
import 'package:pku_online/controller/chat_controller.dart';
import 'package:pku_online/models/chat_model.dart';
import 'package:uuid/uuid.dart';

class ChatPage extends StatefulWidget {
  final ChatController chatController;
  final String receiverId;

  ChatPage({required this.chatController, required this.receiverId});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 137, 18, 9),
        title: Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.chatController
                  .getChatsForReceiver(widget.receiverId)
                  .length,
              itemBuilder: (context, index) {
                ChatModel chat = widget.chatController
                    .getChatsForReceiver(widget.receiverId)[index];
                bool isSender = chat.senderId == widget.receiverId;

                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  alignment:
                      isSender ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSender ? Colors.blue : Colors.grey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      chat.message,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    String message = _messageController.text.trim();
                    if (message.isNotEmpty) {
                      String senderID = Uuid().v4();
                      widget.chatController.sendMessage(
                        senderId: senderID,
                        receiverId: widget.receiverId,
                        message: message,
                      );
                      _messageController.clear();
                      setState(() {});
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
