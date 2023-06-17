import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pku_online/core/colors.dart';
import 'package:pku_online/page/chat_page.dart';

class ChatListPage extends StatefulWidget {
  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage>
    with SingleTickerProviderStateMixin {
  late String currentUserEmail;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    getCurrentUserEmail();
    _tabController = TabController(length: 2, vsync: this);
  }

  void getCurrentUserEmail() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        currentUserEmail = currentUser.email!;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat List'),
        backgroundColor: blueButton,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Active'),
            Tab(text: 'Archived'),
          ],
          indicatorColor: white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10), // Adjust the padding as needed
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildChatList('active'),
            _buildChatList('archived'),
          ],
        ),
      ),
    );
  }

  Widget _buildChatList(String status) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Chats')
          .where('participants', arrayContains: currentUserEmail)
          .where('status', isEqualTo: status)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final chats = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index].data() as Map<String, dynamic>;
              final chatId = chat['chatId'] as String;
              final participants = chat['participants'] as List<dynamic>;
              final bookingId =
                  chat['bookingId'] as String; // Retrieve the booking ID

              // Find the other user's email
              final otherUserEmail =
                  participants.firstWhere((email) => email != currentUserEmail);

              return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('User')
                    .where('email', isEqualTo: otherUserEmail)
                    .limit(1)
                    .snapshots()
                    .map((event) => event.docs.first),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final userData =
                        snapshot.data!.data() as Map<String, dynamic>;
                    final avatarUrl = userData['avatar'] as String;
                    final userName = userData['name'] as String;

                    return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Chats')
                          .doc(chatId)
                          .collection('messages')
                          .orderBy('timestamp', descending: true)
                          .limit(1)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final messages = snapshot.data!.docs;

                          if (messages.isNotEmpty) {
                            final latestMessage =
                                messages.first.data() as Map<String, dynamic>;
                            final messageText = latestMessage['text'] as String;
                            final timestamp =
                                latestMessage['timestamp'] as Timestamp;

                            // Format the timestamp as desired
                            final messageTime =
                                DateFormat('HH:mm').format(timestamp.toDate());

                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(avatarUrl),
                              ),
                              title: Text(userName,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                '$messageText · $messageTime',
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                              onTap: () {
                                // Navigate to the chat page with the selected chat's details
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                      selectedDoctor: userData,
                                      selectedUser: currentUserEmail,
                                      chatId: chatId,
                                      bookingId:
                                          bookingId, // Pass the booking ID to ChatPage
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        }

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(avatarUrl),
                          ),
                          title: Text(userName,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            'No messages yet',
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                          onTap: () {
                            // Navigate to the chat page with the selected chat's details
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatPage(
                                  selectedDoctor: userData,
                                  selectedUser: currentUserEmail,
                                  chatId: chatId,
                                  bookingId:
                                      bookingId, // Pass the booking ID to ChatPage
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return ListTile(
                      leading: CircleAvatar(),
                      title: Text('Loading...'),
                    );
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
    );
  }
}
