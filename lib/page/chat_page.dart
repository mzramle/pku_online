import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pku_online/core/colors.dart';

class ChatPage extends StatefulWidget {
  final dynamic selectedDoctor;

  ChatPage({required this.selectedDoctor});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  void _sendMessage() {
    final String text = _messageController.text.trim();

    if (text.isNotEmpty) {
      final String currentUserEmail =
          FirebaseAuth.instance.currentUser?.email ?? '';
      final String doctorEmail = widget.selectedDoctor['email'];

      // Sort the emails in alphabetical order to ensure consistent chat IDs
      final List<String> sortedEmails = [currentUserEmail, doctorEmail]..sort();

      final chatId = sortedEmails
          .join('_'); // Generate a unique chat ID based on sorted emails

      final chatRef =
          FirebaseFirestore.instance.collection('chats').doc(chatId);

      chatRef.set({
        'participants': sortedEmails,
      }, SetOptions(merge: true)).then((_) {
        chatRef.collection('messages').add({
          'sender': currentUserEmail,
          'text': text,
          'timestamp': DateTime.now(),
        });
      });

      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(getChatId())
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final messages = snapshot.data!.docs;

                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message =
                          messages[index].data() as Map<String, dynamic>;
                      final sender = message['sender'] as String;
                      final text = message['text'] as String;
                      final isCurrentUser =
                          sender == FirebaseAuth.instance.currentUser?.email;

                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('User')
                            .doc(getUserId(sender))
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final userData =
                                snapshot.data!.data() as Map<String, dynamic>;
                            final avatar = userData['avatar'] as String;

                            return Align(
                              alignment: isCurrentUser
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 8,
                                ),
                                child: Row(
                                  mainAxisAlignment: isCurrentUser
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    if (!isCurrentUser)
                                      CircleAvatar(
                                        radius: 16,
                                        backgroundImage: NetworkImage(avatar),
                                      ),
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: isCurrentUser
                                            ? blueButton
                                            : Colors.grey[300],
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        text,
                                        style: TextStyle(
                                          color: isCurrentUser
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                    if (isCurrentUser) SizedBox(width: 8),
                                  ],
                                ),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return SizedBox();
                          }
                        },
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: 'Message',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getChatId() {
    final String currentUserEmail =
        FirebaseAuth.instance.currentUser?.email ?? '';
    final String doctorEmail = widget.selectedDoctor['email'];

    // Sort the emails in alphabetical order to ensure consistent chat IDs
    final List<String> sortedEmails = [currentUserEmail, doctorEmail]..sort();

    return sortedEmails
        .join('_'); // Generate the chat ID based on sorted emails
  }

  String getUserId(String email) {
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    return uid;
  }
}
