import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pku_online/core/colors.dart';

class ChatPage extends StatefulWidget {
  final dynamic selectedDoctor;
  final dynamic selectedUser;
  final dynamic chatId;
  final dynamic bookingId;

  ChatPage({
    required this.selectedDoctor,
    required this.selectedUser,
    required this.chatId,
    required this.bookingId,
  });

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  bool isCurrentUserDoctor = false;
  bool isChatArchived = false;

  @override
  void initState() {
    super.initState();
    checkUserRole();
    checkChatStatus();
  }

  Future<void> checkUserRole() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final snapshot = await FirebaseFirestore.instance
        .collection('Booking')
        .where('doctorUID', isEqualTo: userId)
        .limit(1)
        .get();
    setState(() {
      isCurrentUserDoctor = snapshot.docs.isNotEmpty;
    });
  }

  Future<void> checkChatStatus() async {
    final chatDoc = await FirebaseFirestore.instance
        .collection('Chats')
        .doc(getChatId())
        .get();
    if (chatDoc.exists) {
      final chatStatus = chatDoc['status'] as String;
      setState(() {
        isChatArchived = chatStatus == 'archived';
      });
    }
  }

  void _sendMessage() {
    final String text = _messageController.text.trim();

    if (text.isNotEmpty) {
      final String currentUserEmail =
          FirebaseAuth.instance.currentUser?.email ?? '';
      final String doctorEmail = widget.selectedDoctor['email'];

      // Sort the emails in alphabetical order to ensure consistent chat IDs
      final List<String> sortedEmails = [currentUserEmail, doctorEmail]..sort();

      final chatId = sortedEmails.join('_');

      final chatRef =
          FirebaseFirestore.instance.collection('Chats').doc(chatId);

      chatRef.set({
        'participants': sortedEmails,
        'chatId': chatId,
        'status': 'active',
        'user': widget.selectedUser,
        'doctor': widget.selectedDoctor,
        'bookingId': widget.bookingId,
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

  Future<void> _endChat() async {
    final chatId = getChatId();
    final bookingId = widget.bookingId;

    final confirmed = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('End Chat'),
          content: Text('Are you sure you want to end this chat?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('End Chat'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      // Update chat status
      FirebaseFirestore.instance
          .collection('Chats')
          .doc(chatId)
          .update({'status': 'archived'}).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Chat ended')),
        );
        setState(() {
          isChatArchived = true;
        });

        // Update booking status
        FirebaseFirestore.instance
            .collection('Booking')
            .doc(bookingId)
            .update({'status': 'Complete'}).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Booking completed')),
          );
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to complete booking: $error')),
          );
        });
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to end chat: $error')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        backgroundColor: blueButton,
        actions: [
          if (isCurrentUserDoctor && !isChatArchived)
            IconButton(
              icon: Icon(Icons.close),
              onPressed: _endChat,
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Chats')
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
                            .where('email', isEqualTo: sender)
                            .limit(1)
                            .get()
                            .then((snapshot) => snapshot.docs.first),
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
                                padding: EdgeInsets.only(
                                  left: isCurrentUser ? 64.0 : 0.0,
                                  right: isCurrentUser ? 0.0 : 64.0,
                                  bottom: 4.0,
                                ),
                                child: Row(
                                  mainAxisAlignment: isCurrentUser
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    if (!isCurrentUser)
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left:
                                                8.0), // Add left padding to the avatar
                                        child: CircleAvatar(
                                          radius: 16,
                                          backgroundImage: NetworkImage(avatar),
                                        ),
                                      ),
                                    SizedBox(
                                        width:
                                            8.0), // Add spacing between avatar and chat bubble
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
                      enabled:
                          !isChatArchived, // Disable input for archived chats
                    ),
                    enabled:
                        !isChatArchived, // Disable input for archived chats
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: isChatArchived ? null : _sendMessage,
                  color: isChatArchived ? Colors.grey : null,
                ),
              ],
            ),
          ),
          if (isChatArchived)
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'This chat has ended',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
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
}
